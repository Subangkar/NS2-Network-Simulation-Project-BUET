# Copyright (c) 1997 Regents of the University of California.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. All advertising materials mentioning features or use of this software
#    must display the following acknowledgement:
#      This product includes software developed by the Computer Systems
#      Engineering Group at Lawrence Berkeley Laboratory.
# 4. Neither the name of the University nor of the Laboratory may be used
#    to endorse or promote products derived from this software without
#    specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.
#
# wireless3.tcl
# simulation of a wired-cum-wireless topology running with mobileIP
# ======================================================================
# Define options
# ======================================================================


global opt
set opt(chan)       Channel/WirelessChannel
set opt(prop)       Propagation/TwoRayGround
set opt(netif)      Phy/WirelessPhy
set opt(mac)        Mac/802_11
set opt(ifq)        Queue/DropTail/PriQueue
set opt(ll)         LL
set opt(ant)        Antenna/OmniAntenna
set opt(x)             500   
set opt(y)              500   
set opt(ifqlen)         50   
set opt(tr)          wired-and-wireless.tr
set opt(namtr)       wired-and-wireless.nam
set opt(nn)             10                       
set opt(adhocRouting)   DSDV                      
set opt(cp)             ""                        
set opt(sc)             "../mobility/scene/scen-3-test"   
set opt(stop)           30                           

set prime1 14789
set prime2 13997

# ==========================Variables============================================

set num_wired_nodes      [lindex $argv 0]
set num_bs_nodes         2
set num_wireless_nodes $opt(nn)
set num_flow 20

# ======================================================================

# check for boundary parameters and random seed
if { $opt(x) == 0 || $opt(y) == 0 } {
	puts "No X-Y boundary values given for wireless topology\n"
}
# if {$opt(seed) > 0} {
# 	puts "Seeding Random number generator with $opt(seed)\n"
# 	ns-random $opt(seed)
# }

set ns_   [new Simulator]
# set up for hierarchical routing
#   $ns_ node-config -addressType hierarchical
#   AddrParams set domain_num_ 3          
#   lappend cluster_num 2 1 1                
#   AddrParams set cluster_num_ $cluster_num
#   lappend eilastlevel 1 1 4 1              
#   AddrParams set nodes_num_ $eilastlevel 

  $ns_ node-config -addressType hierarchical
  AddrParams set domain_num_ 3          
  lappend cluster_num 1 1 1                
  AddrParams set cluster_num_ $cluster_num
  lappend eilastlevel 50 21 1              
  AddrParams set nodes_num_ $eilastlevel 

  set tracefd  [open $opt(tr) w]
  $ns_ trace-all $tracefd
  set namtracefd [open $opt(namtr) w]
  $ns_ namtrace-all $namtracefd


  set topo   [new Topography]
  $topo load_flatgrid $opt(x) $opt(y)
  # god needs to know the number of all wireless interfaces
  create-god [expr $opt(nn) + $num_bs_nodes]

  #create 50 wired nodes
  
  set coOrds {0.0.0 0.0.1 0.0.2 0.0.3 0.0.4 0.0.5 0.0.6 0.0.7 0.0.8 0.0.9 0.0.10 0.0.11 0.0.12 0.0.13 0.0.14 0.0.15 0.0.16 0.0.17 0.0.18 0.0.19 0.0.20 0.0.21 0.0.22 0.0.23 0.0.24 0.0.25 0.0.26 0.0.27 0.0.28 0.0.29 0.0.30 0.0.31 0.0.32 0.0.33 0.0.34 0.0.35 0.0.36 0.0.37 0.0.38 0.0.39 0.0.40 0.0.41 0.0.42 0.0.43 0.0.44 0.0.45 0.0.46 0.0.47 0.0.48 0.0.49}

  for {set i 0} {$i < $num_wired_nodes} {incr i} {
      set W($i) [$ns_ node [lindex $coOrds $i]]
  } 

  $ns_ node-config -adhocRouting $opt(adhocRouting) \
                 -llType $opt(ll) \
                 -macType $opt(mac) \
                 -ifqType $opt(ifq) \
                 -ifqLen $opt(ifqlen) \
                 -antType $opt(ant) \
                 -propInstance [new $opt(prop)] \
                 -phyType $opt(netif) \
                 -channel [new $opt(chan)] \
                 -topoInstance $topo \
                 -wiredRouting ON \
                 -agentTrace ON \
                 -routerTrace OFF \
                 -macTrace OFF

  set coOrds {1.0.0 1.0.1 1.0.2 1.0.3 1.0.4 1.0.5 1.0.6 1.0.7 1.0.8 1.0.9 1.0.10 1.0.11 1.0.12 1.0.13 1.0.14 1.0.15 1.0.16 1.0.17 1.0.18 1.0.19}   
  set BS(0) [$ns_ node [lindex $coOrds 0]]
  set BS(1) [$ns_ node 2.0.0]
  $BS(0) random-motion 0 
  $BS(1) random-motion 0

  $BS(0) set X_ 1.0
  $BS(0) set Y_ 2.0
  $BS(0) set Z_ 0.0
  
  $BS(1) set X_ 100.0
  $BS(1) set Y_ 100.0
  $BS(1) set Z_ 0.0
  
  #configure for mobilenodes
  $ns_ node-config -wiredRouting OFF

  for {set j 0} {$j < $opt(nn)} {incr j} {
    set node_($j) [ $ns_ node [lindex $coOrds \
            [expr $j+1]] ]
    $node_($j) base-station [AddrParams addr2id [$BS(0) node-addr]]
  }
  
  #create links between wired and BS nodes
#   $ns_ duplex-link $W(0) $W(1) 5Mb 2ms DropTail
#   $ns_ duplex-link $W(0) $W(2) 5Mb 2ms DropTail
#   $ns_ duplex-link $W(2) $W(5) 5Mb 2ms DropTail
#   $ns_ duplex-link $W(5) $W(9) 5Mb 2ms DropTail

    for {set i 0} {$i < $num_wired_nodes} {incr i} {
        set start_ $i
        set end_ [expr ($i+1)%$num_wired_nodes]
        $ns_ duplex-link $W($start_) $W($end_) 5Mb 2ms DropTail
    }

  $ns_ duplex-link $W(1) $BS(0) 5Mb 2ms DropTail
  $ns_ duplex-link $W(1) $BS(1) 5Mb 2ms DropTail


# Flow Creation

for {set i 0} {$i < $num_flow} {incr i} {

    set tcp($i) [new Agent/TCP]
    $tcp($i) set class_ 2
    set sink($i) [new Agent/TCPSink]
    set rand_wired [expr int(rand()*$prime1) % $num_wired_nodes]
    set rand_wireless [expr int(rand()*$prime2) % 3]

    if {[expr $i % 2] == 0} {
      # connect even nodes to wireless
        $ns_ attach-agent $W($rand_wired) $tcp($i)
        $ns_ attach-agent $node_($rand_wireless) $sink($i)
    } else {
        $ns_ attach-agent $node_($rand_wireless) $tcp($i)
        $ns_ attach-agent $W($rand_wired) $sink($i)
    }

    $ns_ connect $tcp($i) $sink($i)
    set ftp($i) [new Application/FTP]
    $ftp($i) attach-agent $tcp($i)
 
    $ns_ at [expr 2 + $i * 0.1] "$ftp($i) start"
}

  
  for {set i 0} {$i < $opt(nn)} {incr i} {
      $ns_ initial_node_pos $node_($i) 4
   }

  for {set i } {$i < $opt(nn) } {incr i} {
      $ns_ at $opt(stop).0000010 "$node_($i) reset";
  }
  $ns_ at $opt(stop).0000010 "$BS(0) reset";

  $ns_ at $opt(stop).1 "puts \"NS EXITING...\" ; $ns_ halt"

  puts "Starting Simulation..."
  $ns_ run
