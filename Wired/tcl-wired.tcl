# $nNodes $nFlows $pcktRate
# ==============================================================================
# Variables
# ==============================================================================
set num_node           [lindex $argv 0]
set num_flow			[lindex $argv 1]
set cbr_pckt_rate     [lindex $argv 2]
set cbr_interval		[expr 1.0/$cbr_pckt_rate]
# http://prog3.com/sbdm/blog/ysynhtt/article/details/37922773

set val(nn) $num_node

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

set qLimit 10

set time_duration    15 ;	#[lindex $argv 5] ;#50
set start_time          1
set extra_time          5

set flow_start_gap   0.1
set parallel_start_gap 0.1
set cross_start_gap 0.0
set random_start_gap 0.2

set num_parallel_flow 0;# along column
set num_cross_flow 0;#along row
set num_random_flow $num_flow


puts "Simulating With: #Nodes=$num_node #Flow=$num_flow PKT_rate=$cbr_pckt_rate "
# set motion_start_gap    0.05



# set source_type			Agent/UDP
# set sink_type			Agent/Null
set source_type			Agent/TCP
set sink_type			Agent/TCPSink


# ==============================================================================
# Files
# ==============================================================================
set trace_file_name		TRACE.tr
set nam_file_name		NAM.nam
set topo_file_name		TOPO.topo
set directory			""
set queue_trace_file_name qm.out
# http://www.mathcs.emory.edu/~cheung/Courses/558-old/Syllabus/90-NS/trace.html#QMon
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
$ns_ namtrace-all $namtrace 

set queue_trace_file [open $queue_trace_file_name w]

# create a topology object that keeps track of movements...
# ...of mobilenodes within the topological boundary.
set topo_file   [open $directory$topo_file_name "w"]




set topo	[new Topography]

$ns_ rtproto DV 

# create the object God
# create-god $val(nn)

# ==============================================================================



# ==============================================================================
# Create Nodes and Set Initial Positions
# ==============================================================================
puts "start node creation"
for {set i 0} {$i < $num_node} {incr i} {
	set node_($i) [$ns_ node]
}


# Create Edges in a grid-like way
puts "Creating Edges between the nodes..."


for {set i 0} {$i < $num_node} {incr i} { 
    set nodeColm [expr $i % $num_col]

    set rightNode [expr $i + 1]
    set downNode [expr $i + $num_col]

    if {$nodeColm != [expr $num_col-1]} {
        $ns_ duplex-link $node_($i) $node_($rightNode) 2Mb 10ms DropTail
		$ns_ queue-limit $node_($i) $node_($rightNode) $qLimit

		set qmon [$ns_ monitor-queue $node_($i) $node_($rightNode) $queue_trace_file 0.1]
		[$ns_ link $node_($i) $node_($rightNode)] queue-sample-timeout
    }

    if {$downNode < [expr $num_node-1]} {
        $ns_ duplex-link $node_($i) $node_($downNode) 2Mb 10ms DropTail
		$ns_ queue-limit $node_($i) $node_($downNode) $qLimit

		set qmon [$ns_ monitor-queue $node_($i) $node_($downNode) $queue_trace_file 0.1]
		[$ns_ link $node_($i) $node_($downNode)] queue-sample-timeout
    }
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
	$udp_($i) set class_ $i
	$udp_($i) set fid_ $i
	# $udp_($i) set windowOption_ 15
	$udp_($i) set packetSize_ 960
	# $udp_($i) attach $tracefd	
	# $udp_($i) tracevar cwnd_
	# $udp_($i) tracevar ssthresh_
	# $udp_($i) tracevar ack_	

	if { [expr $i%2] == 0} {
		$ns_ color $i Red
	} else {
		$ns_ color $i Blue
	}
}


# # ======================= Random flow =========================
# set num_random_flow 0
puts "Random flow: $num_random_flow"

set k [expr $num_parallel_flow+$num_cross_flow]
# assign agent to node
for {set i 0} {$i < $num_random_flow} {incr i} {
	set source_number [expr int($num_node*rand())]
	set sink_number [expr int($num_node*rand())]
	# set source_number 0
	# set sink_number [expr int($num_node-1)]
	while {$sink_number==$source_number} {
		set sink_number [expr int($num_node*rand())]
	}

	$ns_ attach-agent $node_($source_number) $udp_($k)
  	$ns_ attach-agent $node_($sink_number) $null_($k)

	# set ftp [new Application/FTP]
	# $ftp attach-agent $udp_($k)
	# $ns_ at [expr $start_time+0.5] "$ftp start"

	puts -nonewline $topo_file "RANDOM:  Src: $source_number Dest: $sink_number\n"
	incr k
}


set k [expr $num_parallel_flow+$num_cross_flow]
# Creating packet generator (CBR) for source node
for {set i 0} {$i < $num_random_flow } {incr i} {
	set cbr_($k) [create_CBR_App]
	# set cbr_($i) [new Application/FTP]
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
$ns_ at [expr $start_time+$time_duration +$extra_time] "$ns_ nam-end [$ns_ now]; puts \"NS Exiting...\"; $ns_ halt"


proc finish {} {
    puts "finishing"
    global ns_ tracefd namtrace topo_file nam_file_name
    $ns_ flush-trace
    close $tracefd
	close $topo_file
    close $namtrace
    # exec nam $nam_file_name &
    exit 0
}

puts "Starting Simulation..."
$ns_ run
