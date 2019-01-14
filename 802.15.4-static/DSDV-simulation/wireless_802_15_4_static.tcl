# STEP 1 :::: Set values of the parameters

set nnode [lindex $argv 0]
set nflow [lindex $argv 1]
set ppc   [lindex $argv 2]
set cvar  [lindex $argv 3]

set nodestr "Nodes_"
set flowstr "Flows_"
set ppcstr "Ppc_"
set castr "CVGArea_"
set fstr "X"

set genF "GENERATED_FILE/"
set dataF "DATA/"

set namM ".nam"
set trM ".tr"
set topoM ".txt"

set extension	$nodestr$nnode$flowstr$nflow$ppcstr$ppc$castr$cvar$fstr
# STEP 1.a :::: Network size


set Tx_range_factor [lindex $argv 3]

set cbr_size 64; 
set cbr_rate 11Mb 
set cbr_pckt_per_sec [lindex $argv 2]
set cbr_interval [expr 1.0/$cbr_pckt_per_sec] 

set time_duration 25 ;#50
set start_time 5 ;#100
set parallel_start_gap 0.2
set cross_start_gap 0.5

set grid 0
set extra_time 10 ;#10

# STEP 1.b :::: Number and positioning of nodes

set num_row 1 ;#[lindex $argv 0] ;#number of row
set num_col [lindex $argv 0] ;#number of column
set x_dim [expr  $Tx_range_factor * 200]
set y_dim [expr  $Tx_range_factor * 200]


# STEP 1.c :::: Number and other attributes of flows

set num_parallel_flow 0 ;#[lindex $argv 0]	# along column
set num_cross_flow 0 ;#[lindex $argv 0]		#along row
set num_random_flow [lindex $argv 1]



# STEP 1.d :::: Energy parameters

set val(energymodel_15_4)    EnergyModel     ;
set val(initialenergy_15_4)  1000            ;# Initial energy in Joules
set val(idlepower_15_4) 56.4e-3		;#LEAP	(active power in spec)
set val(rxpower_15_4) 59.1e-3			;#LEAP
set val(txpower_15_4) 52.2e-3			;#LEAP
set val(sleeppower_15_4) 0.6e-3		;#LEAP
set val(transitionpower_15_4) 35.708e-3		;#LEAP: 
set val(transitiontime_15_4) 2.4e-3		;#LEAP


# STEP 1.e :::: Protocols and models for different layers

set tcp_src Agent/TCP
set tcp_sink Agent/TCPSink

set val(chan) Channel/WirelessChannel ;# channel type
set val(prop) Propagation/TwoRayGround ;# radio-propagation model
set val(netif) Phy/WirelessPhy/802_15_4 ;# network interface type
set val(mac) Mac/802_15_4 ;# MAC type
set val(ifq) Queue/DropTail/PriQueue ;# interface queue type
set val(ll) LL ;# link layer type
set val(ant) Antenna/OmniAntenna ;# antenna model
set val(ifqlen) 100 ;# max packet in ifq
set val(rp) DSDV ;# routing protocol

Mac/802_15_4 set syncFlag_ 1
Mac/802_15_4 set dataRate_ 11Mb
Mac/802_15_4 set dutyCycle_ cbr_interval


# STEP 1.f :::: Extra and Bonus task




# STEP 2 :::::: Initialize ns

set ns_ [new Simulator]

# STEP 3 :::::: Open required files such as trace file

set nm $genF$extension$namM
set tr $genF$extension$trM
set topo_file $dataF$extension$topoM

set tracefd [open $tr w]
$ns_ trace-all $tracefd

#$ns_ use-newtrace ;# use the new wireless trace file format

set namtrace [open $nm w]
$ns_ namtrace-all-wireless $namtrace $x_dim $y_dim


set topofile [open $topo_file "w"]

# STEP 4 :::::: Set node configuration

set dist(50m)  	1.84577e-09
set dist(100m)  4.61444e-10
set dist(150m)  2.05086e-10
set dist(200m)  1.15361e-10
set dist(250m)  7.38310e-11
set dist(300m)  5.12715e-11
set dist(350m)  3.76689e-11
set dist(400m)  2.88402e-11
set dist(450m)  2.27873e-11
set dist(500m)  1.84577e-11
set dist(550m)  1.52543e-11
set dist(600m)  1.10093e-11
set dist(700m)  5.94255e-12
set dist(800m)  3.48341e-12
set dist(900m)  2.17468e-12
set dist(1000m)  1.42681e-12


set XXXm [expr 100 * $Tx_range_factor]
set charx m
set mStr $XXXm$charx

Phy/WirelessPhy set CSThresh_ $dist($mStr)
Phy/WirelessPhy set RXThresh_ $dist($mStr)
Phy/WirelessPhy set Pt_ 0.281838
Phy/WirelessPhy set freq_ 5.9e+9


# STEP 5 :::::: Create nodes with positioning


# set up topography object
set topo       [new Topography]
$topo load_flatgrid $x_dim $y_dim
create-god [expr $num_row * $num_col ]



$ns_ node-config -adhocRouting $val(rp) \
		-llType $val(ll) \
     	-macType $val(mac)  \
     	-ifqType $val(ifq) \
     	-ifqLen $val(ifqlen) \
     	-antType $val(ant) \
     	-propType $val(prop) \
     	-phyType $val(netif) \
     	-channel  [new $val(chan)] \
     	-topoInstance $topo \
     	-agentTrace ON \
     	-routerTrace OFF\
     	-macTrace ON \
     	-movementTrace OFF \
	 	-energyModel $val(energymodel_15_4) \
		-idlePower $val(idlepower_15_4) \
		-rxPower $val(rxpower_15_4) \
		-txPower $val(txpower_15_4) \
        -sleepPower $val(sleeppower_15_4) \
        -transitionPower $val(transitionpower_15_4) \
		-transitionTime $val(transitiontime_15_4) \
		-initialEnergy $val(initialenergy_15_4)

 

puts "start node creation"
for {set i 0} {$i < [expr $num_row*$num_col]} {incr i} {
	set node_($i) [$ns_ node]
	$node_($i) random-motion 0
}


#FULL CHNG
set x_start [expr $x_dim/($num_col*2)];
set y_start [expr $y_dim/($num_row*2)];
set i 0;
while {$i < $num_row } {
    for {set j 0} {$j < $num_col } {incr j} {
	set m [expr $i*$num_col+$j];
#CHNG
	if {$grid == 1} {
		set x_pos [expr $x_start+$j*($x_dim/$num_col)];#grid settings
		set y_pos [expr $y_start+$i*($y_dim/$num_row)];#grid settings
	} else {
		set x_pos [expr int($x_dim*rand())] ;#random settings
		set y_pos [expr int($y_dim*rand())] ;#random settings
	}
	$node_($m) set X_ $x_pos;
	$node_($m) set Y_ $y_pos;
	$node_($m) set Z_ 0.0
	puts -nonewline $topofile "$m x: [$node_($m) set X_] y: [$node_($m) set Y_] \n"
    }
    incr i;
}; 

if {$grid == 1} {
	puts "GRID topology"
} else {
	puts "RANDOM topology"
}
puts "node creation complete"

# STEP 6 :::::: Create flows and associate them with nodes


#CHNG
if {$num_parallel_flow > $num_row} {
	set num_parallel_flow $num_row
}

#CHNG
if {$num_cross_flow > $num_col} {
	set num_cross_flow $num_col
}

#CHNG
for {set i 0} {$i < [expr $num_parallel_flow + $num_cross_flow + $num_random_flow]} {incr i} {
	set udp_($i) [new $tcp_src]
	$udp_($i) set class_ $i
	set null_($i) [new $tcp_sink]
	$udp_($i) set fid_ $i
	if { [expr $i%2] == 0} {
		$ns_ color $i Blue
	} else {
		$ns_ color $i Red
	}

} 

################################################PARALLEL FLOW

#CHNG
for {set i 0} {$i < $num_parallel_flow } {incr i} {
	set udp_node $i
	set null_node [expr $i+(($num_col)*($num_row-1))];#CHNG
	$ns_ attach-agent $node_($udp_node) $udp_($i)
  	$ns_ attach-agent $node_($null_node) $null_($i)
	puts -nonewline $topofile "PARALLEL: Src: $udp_node Dest: $null_node\n"
} 

#CHNG
for {set i 0} {$i < $num_parallel_flow } {incr i} {
     $ns_ connect $udp_($i) $null_($i)
}
#CHNG
for {set i 0} {$i < $num_parallel_flow } {incr i} {
	set cbr_($i) [new Application/Traffic/CBR]
	$cbr_($i) set packetSize_ $cbr_size
	$cbr_($i) set rate_ $cbr_rate
	$cbr_($i) set interval_ $cbr_interval
	$cbr_($i) attach-agent $udp_($i)
} 

#CHNG
for {set i 0} {$i < $num_parallel_flow } {incr i} {
     $ns_ at [expr $start_time+$i*$parallel_start_gap] "$cbr_($i) start"
}
####################################CROSS FLOW
#CHNG
set k 0 
#for {set i 1} {$i < [expr $num_col-1] } {incr i} {
#CHNG
for {set i 0} {$i < $num_cross_flow } {incr i} {
	set udp_node [expr $i*$num_col];#CHNG
	set null_node [expr ($i+1)*$num_col-1];#CHNG
	$ns_ attach-agent $node_($udp_node) $udp_($k)
  	$ns_ attach-agent $node_($null_node) $null_($k)
	puts -nonewline $topofile "CROSS: Src: $udp_node Dest: $null_node\n"
	incr k
} 

#CHNG
set k 0
#CHNG
for {set i 0} {$i < $num_cross_flow } {incr i} {
	$ns_ connect $udp_($k) $null_($k)
	incr k
}
#CHNG
set k 0
#CHNG
for {set i 0} {$i < $num_cross_flow } {incr i} {
	set cbr_($k) [new Application/Traffic/CBR]
	$cbr_($k) set packetSize_ $cbr_size
	$cbr_($k) set rate_ $cbr_rate
	$cbr_($k) set interval_ $cbr_interval
	$cbr_($k) attach-agent $udp_($k)
	incr k
} 

#CHNG
set k 0
#CHNG
for {set i 0} {$i < $num_cross_flow } {incr i} {
	$ns_ at [expr $start_time+$i*$cross_start_gap] "$cbr_($k) start"
	incr k
}
#######################################################################RANDOM FLOW
set r $k
set rt $r
set num_node [expr $num_row*$num_col]
for {set i 1} {$i < [expr $num_random_flow+1]} {incr i} {
	set udp_node [expr int($num_node*rand())] ;# src node
	set null_node $udp_node
	while {$null_node==$udp_node} {
		set null_node [expr int($num_node*rand())] ;# dest node
	}
	$ns_ attach-agent $node_($udp_node) $udp_($rt)
  	$ns_ attach-agent $node_($null_node) $null_($rt)
	puts -nonewline $topofile "RANDOM:  Src: $udp_node Dest: $null_node\n"
	incr rt
} 

set rt $r
for {set i 1} {$i < [expr $num_random_flow+1]} {incr i} {
	$ns_ connect $udp_($rt) $null_($rt)
	incr rt
}
set rt $r
for {set i 1} {$i < [expr $num_random_flow+1]} {incr i} {
	set cbr_($rt) [new Application/Traffic/CBR]
	$cbr_($rt) set packetSize_ $cbr_size
	$cbr_($rt) set rate_ $cbr_rate
	$cbr_($rt) set interval_ $cbr_interval
	$cbr_($rt) attach-agent $udp_($rt)
	incr rt
} 

set rt $r
for {set i 1} {$i < [expr $num_random_flow+1]} {incr i} {
	$ns_ at [expr $start_time] "$cbr_($rt) start"
	incr rt
}

puts "flow creation complete"

# STEP 7 :::::: Set timings of different events

for {set i 0} {$i < [expr $num_row*$num_col] } {incr i} {
    $ns_ at [expr $start_time+$time_duration] "$node_($i) reset";
}
$ns_ at [expr $start_time+$time_duration +$extra_time] "finish"
#$ns_ at [expr $start_time+$time_duration +20] "puts \"NS Exiting...\"; $ns_ halt"
$ns_ at [expr $start_time+$time_duration +$extra_time] "$ns_ nam-end-wireless [$ns_ now]; puts \"NS Exiting...\"; $ns_ halt"

$ns_ at [expr $start_time+$time_duration/2] "puts \"half of the simulation is finished\""
$ns_ at [expr $start_time+$time_duration] "puts \"end of simulation duration\""


# STEP 8 :::::: Write tasks to do after finishing the simulation in a procedure named finish


proc finish {} {
	puts "finishing"
	global ns_ tracefd namtrace topofile nm
	global ns_ topofile
	$ns_ flush-trace
	close $tracefd
	close $namtrace
	close $topofile
	#exec nam $nm &
    exit 0
}


# STEP 9 :::::: Run the simulation


for {set i 0} {$i < [expr $num_row*$num_col]  } { incr i} {
	$ns_ initial_node_pos $node_($i) 4
}

puts "Starting Simulation..."
$ns_ run 


###########################################THE END###################################################################
