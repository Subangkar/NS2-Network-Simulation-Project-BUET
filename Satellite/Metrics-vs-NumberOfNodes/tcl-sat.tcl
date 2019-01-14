
global ns_
set ns_ [new Simulator]

#######################input

set num_node [lindex $argv 0]
# $ns_ rtproto Static

###########################################################################
# Global configuration parameters                                         #
###########################################################################

HandoffManager/Term set elevation_mask_ 8.2
HandoffManager/Term set term_handoff_int_ 10
HandoffManager set handoff_randomization_ false

global opt
set opt(chan)           Channel/Sat
set opt(bw_down)	1.5Mb; # Downlink bandwidth (satellite to ground)
set opt(bw_up)		1.5Mb; # Uplink bandwidth
set opt(bw_isl)		25Mb
set opt(phy)            Phy/Sat
set opt(mac)            Mac/Sat
set opt(ifq)            Queue/DropTail
set opt(qlim)		50
set opt(ll)             LL/Sat
# set opt(wiredRouting)   ON
set opt(wiredRouting)   ON

set opt(alt)		780; # Polar satellite altitude (Iridium)
set opt(inc)		90; # Orbit inclination w.r.t. equator


# IMPORTANT This tracing enabling (trace-all) must precede link and node 
#           creation.  Then following all node, link, and error model
#           creation, invoke "$ns_ trace-all-satlinks $outfile" 
set outfile [open sat_trace.tr w]
$ns_ trace-all $outfile

###########################################################################
# Set up satellite and terrestrial nodes                                  #
###########################################################################

# Let's first create a single orbital plane of Iridium-like satellites
# 11 satellites in a plane

# Set up the node configuration

$ns_ node-config -satNodeType polar \
		-llType $opt(ll) \
		-ifqType $opt(ifq) \
		-ifqLen $opt(qlim) \
		-macType $opt(mac) \
		-phyType $opt(phy) \
		-channelType $opt(chan) \
		-downlinkBW $opt(bw_down) \
		-wiredRouting $opt(wiredRouting)


puts "start node creation"

for {set i 0} {$i < [expr $num_node]} {incr i} {
	set node_($i) [$ns_ node]     
}

set plane 1


set ang_dist [ expr 360.0/$num_node ] 

for {set i 0} {$i < [expr $num_node]} {incr i} {

    $node_($i) set-position $opt(alt) $opt(inc) 0 [expr 0 + ( 1.0 * $i * $ang_dist ) ] $plane 
}



# This next step is specific to polar satellites
# By setting the next_ variable on polar sats; handoffs can be optimized  
# This step must follow all polar node creation

for {set i 0} {$i < [expr $num_node]} {incr i} {

    set start_ $i 
    set end_ [expr ($i - 1 + $num_node)%$num_node]

    $node_($start_) set_next $node_($end_)
    
}


# GEO satellite:  above North America-- lets put it at 100 deg. W
$ns_ node-config -satNodeType geo
set n11 [$ns_ node]
$n11 set-position -100

# Terminals:  Let's put two within the US, two around the prime meridian
$ns_ node-config -satNodeType terminal 
set n100 [$ns_ node]; set n101 [$ns_ node]
$n100 set-position 37.9 -122.3; # Berkeley
$n101 set-position 42.3 -71.1; # Boston
set n200 [$ns_ node]; set n201 [$ns_ node]
$n200 set-position 0 10 
$n201 set-position 0 -10

########### Add any necessary ISLs or GSLs

# GSLs to the geo satellite:


$n100 add-gsl geo $opt(ll) $opt(ifq) $opt(qlim) $opt(mac) $opt(bw_up) \
  $opt(phy) [$n11 set downlink_] [$n11 set uplink_]

$n101 add-gsl geo $opt(ll) $opt(ifq) $opt(qlim) $opt(mac) $opt(bw_up) \
  $opt(phy) [$n11 set downlink_] [$n11 set uplink_]

# Attach n200 and n201 initially to a satellite on other side of the earth
# (handoff will automatically occur to fix this at the start of simulation)

set accesspoint [expr int(14797*rand())%$num_node] 

$n200 add-gsl polar $opt(ll) $opt(ifq) $opt(qlim) $opt(mac) $opt(bw_up) \
  $opt(phy) [$node_($accesspoint) set downlink_] [$node_($accesspoint) set uplink_]

$n201 add-gsl polar $opt(ll) $opt(ifq) $opt(qlim) $opt(mac) $opt(bw_up) \
  $opt(phy) [$node_($accesspoint) set downlink_] [$node_($accesspoint) set uplink_]


# ISLs for the polar satellites

for {set i 0} {$i < [expr $num_node]} {incr i} {

    set start_ $i 
    set end_ [expr ($i + 1)%$num_node]

    $ns_ add-isl intraplane $node_($start_) $node_($end_) $opt(bw_isl) $opt(ifq) $opt(qlim)
}



###########################################################################
# Tracing                                                                 #
###########################################################################
$ns_ trace-all-satlinks $outfile

###########################################################################
# Attach agents                                                           #
###########################################################################

set udp0 [new Agent/UDP]
$ns_ attach-agent $n100 $udp0
set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0
$cbr0 set interval_ 0.601

set udp1 [new Agent/UDP]
$ns_ attach-agent $n200 $udp1
$udp1 set class_ 1
set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1
$cbr1 set interval_ 0.95

set null0 [new Agent/Null]
$ns_ attach-agent $n101 $null0

set null1 [new Agent/Null]
$ns_ attach-agent $n201 $null1

$ns_ connect $udp0 $null0
$ns_ connect $udp1 $null1


###########################################################################
# Satellite routing                                                       #
###########################################################################

set satrouteobject_ [new SatRouteObject]
$satrouteobject_ compute_routes

$ns_ at 1.0 "$cbr0 start"
$ns_ at 305.0 "$cbr1 start"

$ns_ at 9000.0 "finish"

proc finish {} {
	global ns_ outfile 
    
	$ns_ flush-trace
	close $outfile

	exit 0
}


$ns_ run

