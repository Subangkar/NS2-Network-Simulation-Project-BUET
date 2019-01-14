# $nNodes $nFlows $pcktRate $speed
# ==============================================================================
# Variables
# ==============================================================================
set num_node           [lindex $argv 0]
set num_flow			[lindex $argv 1]
set cbr_pckt_rate     [lindex $argv 2]
set Tx_range 	    	[lindex $argv 3]
set cbr_interval		[expr 1.0/$cbr_pckt_rate]
# http://prog3.com/sbdm/blog/ysynhtt/article/details/37922773

set num_col 5
if {$num_node >= 50} {
	set num_col [expr 2*$num_col]
	# puts "$num_col"
}
set num_row [expr $num_node/$num_col]

# ==============================================================================


# ==============================================================================
# Network Parameters
# ==============================================================================
set cbr_type CBR
set cbr_size            16 ;	#[lindex $argv 2]; #4,8,16,32,64
set cbr_rate            0.256Mb;#11.0Mb
set grid_x_dim		[expr $Tx_range];# 500 ;	#[lindex $argv 1]
set grid_y_dim  	[expr $Tx_range];#500 ;	#[lindex $argv 1]
set time_duration    15 ;	#[lindex $argv 5] ;#50
set start_time          1
set extra_time          5
set flow_start_gap   0.1
set parallel_start_gap 0.1
set cross_start_gap 0.0
set random_start_gap 0.2

# set num_parallel_flow [expr ($num_row*$num_col)];# along column
set num_parallel_flow [expr (int($num_row/2))*$num_col];# along column
set num_parallel_flow 0;# along column
if {$num_parallel_flow > [expr $num_flow/2]} {
	set num_parallel_flow [expr $num_flow/2]
}
set num_cross_flow [expr $num_flow-$num_parallel_flow] ;#along row
# set num_cross_flow $num_flow;#along row
set num_random_flow 0
if {$num_cross_flow > [expr (int($num_col/2))*$num_row]} {
	# puts $num_cross_flow
	set num_random_flow  [expr $num_cross_flow - (int($num_col/2))*$num_row]
	# set num_random_flow  [expr $num_cross_flow-$num_row]
	# set num_cross_flow $num_row
	set num_cross_flow [expr (int($num_col/2))*$num_row]
}
set num_parallel_flow 0;# along column
set num_cross_flow 0;#along row
set num_random_flow $num_flow


puts "Simulating With: #Nodes=$num_node #Flow=$num_flow PKT_rate=$cbr_pckt_rate #TX_Area=$grid_x_dim x $grid_y_dim"
# set motion_start_gap    0.05



set source_type			Agent/UDP
set sink_type			Agent/Null

# ==============================================================================
# source / sink options
# ==============================================================================
# UDP:		Agent/UDP					Agent/Null
# TAHOE:	Agent/TCP					Agent/TCPSink
# RENO:		Agent/TCP/Reno				Agent/TCPSink
# NEWRENO:	Agent/TCP/Newreno			Agent/TCPSink
# SACK: 	Agent/TCP/FullTcp/Sack		Agent/TCPSink/Sack1
# VEGAS:	Agent/TCP/Vegas				Agent/TCPSink
# FACK:		Agent/TCP/Fack				Agent/TCPSink
# LINUX:	Agent/TCP/Linux				Agent/TCPSink

# ==============================================================================



# ==============================================================================
# Files
# ==============================================================================
set trace_file_name		TRACE.tr
set nam_file_name		NAM.nam
set topo_file_name		TOPO.topo
set directory			""
# ==============================================================================




# ==============================================================================
# Define options
# ==============================================================================
set val(chan)		Channel/WirelessChannel  	;# channel type
set val(prop)		Propagation/TwoRayGround 	;# radio-propagation model
set val(netif)		Phy/WirelessPhy/802_15_4    ;# network interface type
set val(mac)		Mac/802_15_4 			 	;# MAC type wireless 802.15.4
set val(ifq)		Queue/DropTail/PriQueue  	;# Interface queue type
set val(ll)			LL                       	;# Link layer type
set val(ant)		Antenna/OmniAntenna      	;# Antenna type
set val(ifqlen)		100                       	;# max packet in ifq
set val(rp)			AODV ;#DSDV                     	;# ad-hoc routing protocol
set val(nn)			$num_node                	;# number of mobilenodes
# ==============================================================================



# ==============================================================================
# Energy Parameters
# ==============================================================================
# set val(energymodel)	EnergyModel;
# set val(initialenergy)	100;

set val(energymodel_15_4)    EnergyModel ;
set val(initialenergy_15_4)  1000            ;# Initial energy in Joules

set val(idlepower_15_4) 56.4e-3		;#LEAP	(active power in spec)
set val(rxpower_15_4) 59.1e-3			;#LEAP
set val(txpower_15_4) 52.2e-3			;#LEAP
set val(sleeppower_15_4) 0.6e-3		;#LEAP
set val(transitionpower_15_4) 35.708e-3		;#LEAP:
set val(transitiontime_15_4) 2.4e-3		;#LEAP

#set val(idlepower_15_4) 3e-3			;#telos	(active power in spec)
#set val(rxpower_15_4) 38e-3			;#telos
#set val(txpower_15_4) 35e-3			;#telos
#set val(sleeppower_15_4) 15e-6			;#telos
#set val(transitionpower_15_4) 1.8e-6		;#telos: volt = 1.8V; sleep current of MSP430 = 1 microA; so, 1.8 micro W
#set val(transitiontime_15_4) 6e-6		;#telos

Mac/802_15_4 set syncFlag_ 1
Mac/802_15_4 set dataRate_ 0.250Mb
# Mac/802_15_4 set dataRate_ 11Mb
Mac/802_15_4 set dutyCycle_ cbr_interval



# ==============================================================================






# ==============================================================================
# EXCLUSIVE ENERGY PARAMETERS FOR 802.15.4
# ==============================================================================
set dist(5m)  7.69113e-06
set dist(9m)  2.37381e-06
set dist(10m) 1.92278e-06
set dist(11m) 1.58908e-06
set dist(12m) 1.33527e-06
set dist(13m) 1.13774e-06
set dist(14m) 9.81011e-07
set dist(15m) 8.54570e-07
set dist(16m) 7.51087e-07
set dist(20m) 4.80696e-07
set dist(25m) 3.07645e-07
set dist(30m) 2.13643e-07
set dist(35m) 1.56962e-07
set dist(40m) 1.20174e-07
Phy/WirelessPhy set CSThresh_ 2.48293e-08;#[expr 2.2*$dist(40m)]
Phy/WirelessPhy set RXThresh_ $dist(40m)
# Phy/WirelessPhy set TXThresh_ $dist(40m)
# Phy/WirelessPhy/802_15_4 set CSThresh_ $dist(40m)
# Phy/WirelessPhy/802_15_4 set RXThresh_ $dist(40m)
# Phy/WirelessPhy/802_15_4 set TXThresh_ $dist(40m)
# ==============================================================================


# ==============================================================================
# Functions
# ==============================================================================

proc create_CBR_App { } {
	global cbr_type cbr_size cbr_rate cbr_interval

	set cbr_ [new Application/Traffic/CBR]
	$cbr_ set type_ $cbr_type
	$cbr_ set packetSize_ $cbr_size
	$cbr_ set rate_ $cbr_rate
	$cbr_ set interval_ $cbr_interval
	# $cbr_ attach-agent $udp_($k)
	return $cbr_
}

# 0->15 1->16
# 0th row -> last row
# 1st row -> (last-1) row
proc paralell_Node_No {i} {
	global num_row num_col

	set curRow [expr int($i/$num_col)]
	# puts $curRow
	return [expr ($i%$num_col)+(($num_row-1-$curRow)*$num_col)]
}


proc getNodeNoForCross {i} {
	global num_row num_col

	set nodeRow [expr ($i/(int($num_col/2)))]
	set curColm [expr int($i%($num_col/2))]
	# puts $nodeRow
	# puts $curColm
	set i [expr $curColm+($nodeRow*$num_col)]
	return $i	
}

# 0->4 1->3 5->9
# 0th row -> last row
# 1st row -> (last-1) row
proc cross_Node_No {i} {
	global num_row num_col

	set nodeRow [expr ($i/(int($num_col)))]
	set curColm [expr int($i%$num_col)]
	return [expr (($nodeRow+1)*$num_col-1)-$curColm]
}

set v 5
set v [cross_Node_No $v]
# puts $v
# ==============================================================================


# ==============================================================================
# Initialization
# ==============================================================================

# creating an instance of the simulator
set ns_    [new Simulator]

# setup trace support by opening the trace file
set tracefd     [open $directory$trace_file_name w]
$ns_ trace-all $tracefd

# setum nam (Network Animator) support by opening the nam file
set namtrace    [open $directory$nam_file_name w]
# $ns_ namtrace-all $namtrace 
$ns_ namtrace-all-wireless $namtrace $grid_x_dim $grid_y_dim


# create a topology object that keeps track of movements...
# ...of mobilenodes within the topological boundary.
set topo_file   [open $directory$topo_file_name "w"]




set topo	[new Topography]
$topo load_flatgrid $grid_x_dim $grid_y_dim

# create the object God
create-god $val(nn)

# ==============================================================================



# ==============================================================================
# The configuration API for creating mobilenodes
# ==============================================================================
$ns_ node-config	-adhocRouting $val(rp) \
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
					-initialEnergy $val(initialenergy_15_4) \
					-rxPower $val(rxpower_15_4) \
					-txPower $val(txpower_15_4) \
			 		-idlePower $val(idlepower_15_4) \
          			-sleepPower $val(sleeppower_15_4) \
          			-transitionPower $val(transitionpower_15_4) \
					-transitionTime $val(transitiontime_15_4)
             		# -energyModel $val(energymodel) \
             		# -initialEnergy $val(initialenergy) \
             		# -rxPower 35.28e-3 \
             		# -txPower 31.32e-3 \
	     			# -idlePower 712e-6 \
	     			# -sleepPower 144e-9
# ==============================================================================




# ==============================================================================
# Create Nodes and Set Initial Positions
# ==============================================================================
puts "start node creation"
for {set i 0} {$i < $num_node} {incr i} {
	set node_($i) [$ns_ node]
	# $node_($i) random-motion 0
}


# GRID Topology
set dx [expr ($grid_x_dim/$num_col)]
set dy [expr ($grid_y_dim/$num_row)]

set x_start [expr $dx/2];
set y_start [expr $dy/2];


for {set i 0} {$i < $num_row} {incr i} {
	#in same column
    for {set j 0} {$j < $num_col } {incr j} {
		#in same row
		set m [expr ($i*$num_col)+$j];# n-th node

		set y_pos [expr $y_start+($i*$dy)];#grid settings
		set x_pos [expr $x_start+($j*$dx)];#grid settings

		$node_($m) set X_ $x_pos;
		$node_($m) set Y_ $y_pos;
		$node_($m) set Z_ 0.0

		puts -nonewline $topo_file "$m x: [$node_($m) set X_] y: [$node_($m) set Y_] \n"
    }
}; 




for {set i 0} {$i < $val(nn)} { incr i } {
	$ns_ initial_node_pos $node_($i) 4
    #4 = size of node in nam
}





puts "node creation complete"
# ==============================================================================




# ==============================================================================
# Traffic Flow Generation
# ==============================================================================

# create agent for each flow
for {set i 0} {$i < $num_flow} {incr i} {
	set udp_($i) [new $source_type]
	set null_($i) [new $sink_type]
	$udp_($i) set fid_ $i
	# $ns_ color $i Blue
	if { [expr $i%2] == 0} {
		$ns_ color $i Red
	} else {
		$ns_ color $i Blue
	}
}

set flowNum 0
# # ======================= PARALLEL FLOW =======================
# along column
# set num_parallel_flow 0
puts "Parallel flow: $num_parallel_flow"
set k 0
#CHNG
for {set i 0} {$i < $num_parallel_flow } {incr i} {
	set udp_node $i
	set null_node [paralell_Node_No $i];#CHNG
	# set null_node [expr $i+(($num_col)*($num_row-1))];#CHNG
	$ns_ attach-agent $node_($udp_node) $udp_($k)
  	$ns_ attach-agent $node_($null_node) $null_($k)
	puts -nonewline $topo_file "PARALLEL: Src: $udp_node Dest: $null_node\n"
	incr k
}

set k 0
#CHNG
for {set i 0} {$i < $num_parallel_flow } {incr i} {
     $ns_ connect $udp_($k) $null_($k)
	 incr k
}

set k 0
#CHNG
for {set i 0} {$i < $num_parallel_flow } {incr i} {
	set cbr_($k) [create_CBR_App]
	$cbr_($k) attach-agent $udp_($k)
	incr k
}


set k 0
#CHNG
for {set i 0} {$i < $num_parallel_flow } {incr i} {
     $ns_ at [expr $start_time+$i*$parallel_start_gap] "$cbr_($k) start"
	 incr k
}

####################################CROSS FLOW
# along row 1st -> last
# set num_cross_flow 0
puts "Cros flow: $num_cross_flow"

#CHNG
set k $num_parallel_flow
#CHNG
for {set i 0} {$i < $num_cross_flow } {incr i} {
	set udp_node [getNodeNoForCross $i];#CHNG
	set null_node [cross_Node_No $udp_node];#CHNG
	# set null_node [expr ($i+1)*$num_col-1];#CHNG
	$ns_ attach-agent $node_($udp_node) $udp_($k)
  	$ns_ attach-agent $node_($null_node) $null_($k)
	puts -nonewline $topo_file "CROSS: Src: $udp_node Dest: $null_node\n"
	incr k
} 

#CHNG
set k $num_parallel_flow
#CHNG
for {set i 0} {$i < $num_cross_flow } {incr i} {
	$ns_ connect $udp_($k) $null_($k)
	incr k
}
#CHNG
set k $num_parallel_flow
#CHNG
for {set i 0} {$i < $num_cross_flow } {incr i} {
	set cbr_($k) [create_CBR_App]
	$cbr_($k) attach-agent $udp_($k)
	incr k
}

#CHNG
set k $num_parallel_flow
#CHNG
for {set i 0} {$i < $num_cross_flow } {incr i} {
	$ns_ at [expr $start_time+$i*$cross_start_gap] "$cbr_($k) start"
	incr k
}

# ======================= Random flow =========================
# set num_random_flow 0
puts "Random flow: $num_random_flow"

set k [expr $num_parallel_flow+$num_cross_flow]
# assign agent to node
for {set i 0} {$i < $num_random_flow} {incr i} {
	set source_number [expr int($num_node*rand())]
	set sink_number [expr int($num_node*rand())]
	while {$sink_number==$source_number} {
		set sink_number [expr int($num_node*rand())]
	}

	$ns_ attach-agent $node_($source_number) $udp_($k)
  	$ns_ attach-agent $node_($sink_number) $null_($k)

	puts -nonewline $topo_file "RANDOM:  Src: $source_number Dest: $sink_number\n"
	incr k
}


set k [expr $num_parallel_flow+$num_cross_flow]
# Creating packet generator (CBR) for source node
for {set i 0} {$i < $num_random_flow } {incr i} {
	set cbr_($k) [create_CBR_App]
	$cbr_($k) attach-agent $udp_($k)
	incr k
}


set k [expr $num_parallel_flow+$num_cross_flow]
for {set i 0} {$i < $num_random_flow } {incr i} {
	$ns_ at $start_time "$cbr_($k) start"
	incr k
}

set k [expr $num_parallel_flow+$num_cross_flow]
# Connecting udp_node & null_node
for {set i 0} {$i < $num_random_flow } {incr i} {
     $ns_ connect $udp_($k) $null_($k)
	incr k
}
# =============================================================




puts "flow creation complete"
# ==============================================================================


# ==============================================================================
# Ending the simulation
# ==============================================================================

# Tell nodes when the simulation ends
#
for {set i 0} {$i < $num_node } {incr i} {
    $ns_ at [expr $start_time+$time_duration] "$node_($i) reset";
}

$ns_ at [expr $start_time+$time_duration +$extra_time] "finish"
$ns_ at [expr $start_time+$time_duration +$extra_time] "$ns_ nam-end-wireless [$ns_ now]; puts \"NS Exiting...\"; $ns_ halt"


proc finish {} {
    puts "finishing"
    global ns_ tracefd namtrace topo_file nam_file_name
    $ns_ flush-trace
    close $tracefd
	close $topo_file
    # close $namtrace
    # exec nam $nam_file_name &
    exit 0
}

puts "Starting Simulation..."
$ns_ run
