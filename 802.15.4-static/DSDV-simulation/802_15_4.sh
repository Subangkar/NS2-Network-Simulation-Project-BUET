rm -r DATA
rm -r GENERATED_FILE
rm -r GRAPH

mkdir GRAPH
mkdir DATA
mkdir GENERATED_FILE


l=0;thr=0.0;del=0.0;s_packet=0.0;r_packet=0.0;d_packet=0.0;del_ratio=0.0;
dr_ratio=0.0;time=0.0;t_energy=0.0;energy_bit=0.0;energy_byte=0.0;energy_packet=0.0;total_retransmit=0.0;energy_efficiency=0.0;
jitter=0.0;


dataF="DATA/plotingvarynode.txt";
for node in 20 40 60 80 100
do 
	echo "Node: $node"
	echo -ne "$node " >> $dataF
	ns wireless_802_15_4_static.tcl $node 30 300 3
	echo "SIMULATION COMPLETE. BUILDING STAT......"
	before="GENERATED_FILE/Nodes_"
	afterT="Flows_30Ppc_300CVGArea_3X.tr"
	afterO="Flows_30Ppc_300CVGArea_3X.out"
	traceF="$before$node$afterT"
	outF="$before$node$afterO"
	awk -f wireless_802_15_4_static.awk $traceF > $outF
	echo "AWK FILE COMPLETE"
	while read val
	do
			
		l=$(($l+1))


		if [ "$l" == "1" ]; then
			thr=$(echo "scale=5; $thr+$val/$node*1.0" | bc)
			echo -ne "throughput: $thr "
		elif [ "$l" == "2" ]; then
			del=$(echo "scale=5; $del+$val/$node*1.0" | bc)
			echo -ne "delay: "
		elif [ "$l" == "3" ]; then
			s_packet=$(echo "scale=5; $s_packet+$val/$node*1.0" | bc)
			echo -ne "send packet: "
		elif [ "$l" == "4" ]; then
			r_packet=$(echo "scale=5; $r_packet+$val/$node*1.0" | bc)
			echo -ne "received packet: "
		elif [ "$l" == "5" ]; then
			d_packet=$(echo "scale=5; $d_packet+$val/$node*1.0" | bc)
			echo -ne "drop packet: "
		elif [ "$l" == "6" ]; then
			del_ratio=$(echo "scale=5; $del_ratio+$val/$node*1.0" | bc)
			echo -ne "delivery ratio: "
		elif [ "$l" == "7" ]; then
			dr_ratio=$(echo "scale=5; $dr_ratio+$val/$node*1.0" | bc)
			echo -ne "drop ratio: "
		elif [ "$l" == "8" ]; then
			time=$(echo "scale=5; $time+$val/$node*1.0" | bc)
			echo -ne "time: "
		elif [ "$l" == "9" ]; then
			t_energy=$(echo "scale=5; $t_energy+$val/$node*1.0" | bc)
			echo -ne "total_energy: "
		elif [ "$l" == "10" ]; then
			energy_bit=$(echo "scale=5; $energy_bit+$val/$node*1.0" | bc)
			echo -ne "energy_per_bit: "
		elif [ "$l" == "11" ]; then
			energy_byte=$(echo "scale=5; $energy_byte+$val/$*1.0" | bc)
			echo -ne "energy_per_byte: "
		elif [ "$l" == "12" ]; then
			energy_packet=$(echo "scale=5; $energy_packet+$val/$node*1.0" | bc)
			echo -ne "energy_per_packet: "
		elif [ "$l" == "13" ]; then
			total_retransmit=$(echo "scale=5; $total_retransmit+$val/$node*1.0" | bc)
			echo -ne "total_retrnsmit: "
		elif [ "$l" == "14" ]; then
			energy_efficiency=$(echo "scale=9; $energy_efficiency+$val/$*1.0" | bc)
			echo -ne "energy_efficiency: "
		elif [ "$l" == "15" ]; then
			jitter=$(echo "scale=1; $jitter+$val" | bc)
			echo -ne "jitter: "
		fi
		echo "$val"
		echo -ne "$val " >> $dataF
	done < $outF
	echo "" >> $dataF

done





enr_nj=$(echo "scale=2; $energy_efficiency*1000000000.0" | bc)

	
	
dir="DATA/VaryingNode"
output_file="$dir.out"

echo -ne "Throughput:          $thr \n" >> $output_file
echo -ne "AverageDelay:         $del \n" >> $output_file
echo -ne "Sent Packets:         $s_packet \n" >> $output_file
echo -ne "Received Packets:         $r_packet \n" >> $output_file
echo -ne "Dropped Packets:         $d_packet \n" >> $output_file
echo -ne "PacketDeliveryRatio:      $del_ratio \n" >> $output_file
echo -ne "PacketDropRatio:      $dr_ratio \n" >> $output_file
echo -ne "Total time:  $time \n" >> $output_file
echo -ne "\n" >> $output_file
echo -ne "\n" >> $output_file
echo -ne "Total energy consumption:        $t_energy \n" >> $output_file
echo -ne "Average Energy per bit:         $energy_bit \n" >> $output_file
echo -ne "Average Energy per byte:         $energy_byte \n" >> $output_file
echo -ne "Average energy per packet:         $energy_packet \n" >> $output_file
echo -ne "total_retransmit:         $total_retransmit \n" >> $output_file
echo -ne "energy_efficiency(nj/bit):         $enr_nj \n" >> $output_file
echo -ne "jitter:         $jitter \n" >> $output_file
echo "" >> $output_file


l=0;thr=0.0;del=0.0;s_packet=0.0;r_packet=0.0;d_packet=0.0;del_ratio=0.0;
dr_ratio=0.0;time=0.0;t_energy=0.0;energy_bit=0.0;energy_byte=0.0;energy_packet=0.0;total_retransmit=0.0;energy_efficiency=0.0;
jitter=0.0;


dataF="DATA/plotingvaryflow.txt";

for flow in 10 20 30 40 50
do
	echo "Flow : $flow"
	echo -ne "$flow " >> $dataF
	ns wireless_802_15_4_static.tcl 60 $flow 300 3
	echo "SIMULATION COMPLETE. BUILDING STAT......"
	before="GENERATED_FILE/Nodes_60Flows_"
	afterT="Ppc_300CVGArea_3X.tr"
	afterO="Ppc_300CVGArea_3X.out"
	traceF="$before$flow$afterT"
	outF="$before$flow$afterO"
	awk -f wireless_802_15_4_static.awk $traceF > $outF
	echo "AWK FILE COMPLETE"
	while read val
	do
			
		l=$(($l+1))
		node=30

		if [ "$l" == "1" ]; then
			thr=$(echo "scale=5; $thr+$val/$node*1.0" | bc)
			echo -ne "throughput: $thr "
		elif [ "$l" == "2" ]; then
			del=$(echo "scale=5; $del+$val/$node*1.0" | bc)
			echo -ne "delay: "
		elif [ "$l" == "3" ]; then
			s_packet=$(echo "scale=5; $s_packet+$val/$node*1.0" | bc)
			echo -ne "send packet: "
		elif [ "$l" == "4" ]; then
			r_packet=$(echo "scale=5; $r_packet+$val/$node*1.0" | bc)
			echo -ne "received packet: "
		elif [ "$l" == "5" ]; then
			d_packet=$(echo "scale=5; $d_packet+$val/$node*1.0" | bc)
			echo -ne "drop packet: "
		elif [ "$l" == "6" ]; then
			del_ratio=$(echo "scale=5; $del_ratio+$val/$node*1.0" | bc)
			echo -ne "delivery ratio: "
		elif [ "$l" == "7" ]; then
			dr_ratio=$(echo "scale=5; $dr_ratio+$val/$node*1.0" | bc)
			echo -ne "drop ratio: "
		elif [ "$l" == "8" ]; then
			time=$(echo "scale=5; $time+$val/$node*1.0" | bc)
			echo -ne "time: "
		elif [ "$l" == "9" ]; then
			t_energy=$(echo "scale=5; $t_energy+$val/$node*1.0" | bc)
			echo -ne "total_energy: "
		elif [ "$l" == "10" ]; then
			energy_bit=$(echo "scale=5; $energy_bit+$val/$node*1.0" | bc)
			echo -ne "energy_per_bit: "
		elif [ "$l" == "11" ]; then
			energy_byte=$(echo "scale=5; $energy_byte+$val/$*1.0" | bc)
			echo -ne "energy_per_byte: "
		elif [ "$l" == "12" ]; then
			energy_packet=$(echo "scale=5; $energy_packet+$val/$node*1.0" | bc)
			echo -ne "energy_per_packet: "
		elif [ "$l" == "13" ]; then
			total_retransmit=$(echo "scale=5; $total_retransmit+$val/$node*1.0" | bc)
			echo -ne "total_retrnsmit: "
		elif [ "$l" == "14" ]; then
			energy_efficiency=$(echo "scale=9; $energy_efficiency+$val/$*1.0" | bc)
			echo -ne "energy_efficiency: "
		elif [ "$l" == "15" ]; then
			jitter=$(echo "scale=1; $jitter+$val" | bc)
			echo -ne "jitter: "
		fi
		echo "$val"
		echo -ne "$val " >> $dataF
	done < $outF
	echo "" >> $dataF
done



enr_nj=$(echo "scale=2; $energy_efficiency*1000000000.0" | bc)

	
	
dir="DATA/VaryingFlow"
output_file="$dir.out"

echo -ne "Throughput:          $thr \n" >> $output_file
echo -ne "AverageDelay:         $del \n" >> $output_file
echo -ne "Sent Packets:         $s_packet \n" >> $output_file
echo -ne "Received Packets:         $r_packet \n" >> $output_file
echo -ne "Dropped Packets:         $d_packet \n" >> $output_file
echo -ne "PacketDeliveryRatio:      $del_ratio \n" >> $output_file
echo -ne "PacketDropRatio:      $dr_ratio \n" >> $output_file
echo -ne "Total time:  $time \n" >> $output_file
echo -ne "\n" >> $output_file
echo -ne "\n" >> $output_file
echo -ne "Total energy consumption:        $t_energy \n" >> $output_file
echo -ne "Average Energy per bit:         $energy_bit \n" >> $output_file
echo -ne "Average Energy per byte:         $energy_byte \n" >> $output_file
echo -ne "Average energy per packet:         $energy_packet \n" >> $output_file
echo -ne "total_retransmit:         $total_retransmit \n" >> $output_file
echo -ne "energy_efficiency(nj/bit):         $enr_nj \n" >> $output_file
echo -ne "jitter:         $jitter \n" >> $output_file
echo "" >> $output_file


l=0;thr=0.0;del=0.0;s_packet=0.0;r_packet=0.0;d_packet=0.0;del_ratio=0.0;
dr_ratio=0.0;time=0.0;t_energy=0.0;energy_bit=0.0;energy_byte=0.0;energy_packet=0.0;total_retransmit=0.0;energy_efficiency=0.0;
jitter=0.0;

dataF="DATA/plotingvarypps.txt";
for pps in 100 200 300 400 500
do
	echo "Packet per second: $pps"
	echo -ne "$pps " >> $dataF
	ns wireless_802_15_4_static.tcl 60 30 $pps 3
	echo "SIMULATION COMPLETE. BUILDING STAT......"
	before="GENERATED_FILE/Nodes_60Flows_30Ppc_"
	afterT="CVGArea_3X.tr"
	afterO="CVGArea_3X.out"
	traceF="$before$pps$afterT"
	outF="$before$pps$afterO"
	awk -f wireless_802_15_4_static.awk $traceF > $outF
	echo "AWK FILE COMPLETE"
	while read val
	do
			
		l=$(($l+1))
		node=30

		if [ "$l" == "1" ]; then
			thr=$(echo "scale=5; $thr+$val/$node*1.0" | bc)
			echo -ne "throughput: $thr "
		elif [ "$l" == "2" ]; then
			del=$(echo "scale=5; $del+$val/$node*1.0" | bc)
			echo -ne "delay: "
		elif [ "$l" == "3" ]; then
			s_packet=$(echo "scale=5; $s_packet+$val/$node*1.0" | bc)
			echo -ne "send packet: "
		elif [ "$l" == "4" ]; then
			r_packet=$(echo "scale=5; $r_packet+$val/$node*1.0" | bc)
			echo -ne "received packet: "
		elif [ "$l" == "5" ]; then
			d_packet=$(echo "scale=5; $d_packet+$val/$node*1.0" | bc)
			echo -ne "drop packet: "
		elif [ "$l" == "6" ]; then
			del_ratio=$(echo "scale=5; $del_ratio+$val/$node*1.0" | bc)
			echo -ne "delivery ratio: "
		elif [ "$l" == "7" ]; then
			dr_ratio=$(echo "scale=5; $dr_ratio+$val/$node*1.0" | bc)
			echo -ne "drop ratio: "
		elif [ "$l" == "8" ]; then
			time=$(echo "scale=5; $time+$val/$node*1.0" | bc)
			echo -ne "time: "
		elif [ "$l" == "9" ]; then
			t_energy=$(echo "scale=5; $t_energy+$val/$node*1.0" | bc)
			echo -ne "total_energy: "
		elif [ "$l" == "10" ]; then
			energy_bit=$(echo "scale=5; $energy_bit+$val/$node*1.0" | bc)
			echo -ne "energy_per_bit: "
		elif [ "$l" == "11" ]; then
			energy_byte=$(echo "scale=5; $energy_byte+$val/$*1.0" | bc)
			echo -ne "energy_per_byte: "
		elif [ "$l" == "12" ]; then
			energy_packet=$(echo "scale=5; $energy_packet+$val/$node*1.0" | bc)
			echo -ne "energy_per_packet: "
		elif [ "$l" == "13" ]; then
			total_retransmit=$(echo "scale=5; $total_retransmit+$val/$node*1.0" | bc)
			echo -ne "total_retrnsmit: "
		elif [ "$l" == "14" ]; then
			energy_efficiency=$(echo "scale=9; $energy_efficiency+$val/$*1.0" | bc)
			echo -ne "energy_efficiency: "
		elif [ "$l" == "15" ]; then
			jitter=$(echo "scale=1; $jitter+$val" | bc)
			echo -ne "jitter: "
		fi
		echo "$val"
		echo -ne "$val " >> $dataF
	done < $outF
	echo "" >> $dataF

done


enr_nj=$(echo "scale=2; $energy_efficiency*1000000000.0" | bc)

	
	
dir="DATA/VaryingPPS"
output_file="$dir.out"

echo -ne "Throughput:          $thr \n" >> $output_file
echo -ne "AverageDelay:         $del \n" >> $output_file
echo -ne "Sent Packets:         $s_packet \n" >> $output_file
echo -ne "Received Packets:         $r_packet \n" >> $output_file
echo -ne "Dropped Packets:         $d_packet \n" >> $output_file
echo -ne "PacketDeliveryRatio:      $del_ratio \n" >> $output_file
echo -ne "PacketDropRatio:      $dr_ratio \n" >> $output_file
echo -ne "Total time:  $time \n" >> $output_file
echo -ne "\n" >> $output_file
echo -ne "\n" >> $output_file
echo -ne "Total energy consumption:        $t_energy \n" >> $output_file
echo -ne "Average Energy per bit:         $energy_bit \n" >> $output_file
echo -ne "Average Energy per byte:         $energy_byte \n" >> $output_file
echo -ne "Average energy per packet:         $energy_packet \n" >> $output_file
echo -ne "total_retransmit:         $total_retransmit \n" >> $output_file
echo -ne "energy_efficiency(nj/bit):         $enr_nj \n" >> $output_file
echo -ne "jitter:         $jitter \n" >> $output_file
echo "" >> $output_file


l=0;thr=0.0;del=0.0;s_packet=0.0;r_packet=0.0;d_packet=0.0;del_ratio=0.0;
dr_ratio=0.0;time=0.0;t_energy=0.0;energy_bit=0.0;energy_byte=0.0;energy_packet=0.0;total_retransmit=0.0;energy_efficiency=0.0;
jitter=0.0;


dataF="DATA/plotingvaryca.txt";
for ca in 1 2 3 4 5
do
	echo "Coverage Area : $ca X 100"
	echo -ne "$ca " >> $dataF
	ns wireless_802_15_4_static.tcl 60 30 300 $ca
	echo "SIMULATION COMPLETE. BUILDING STAT......"
	before="GENERATED_FILE/Nodes_60Flows_30Ppc_300CVGArea_"
	afterT="X.tr"
	afterO="X.out"
	traceF="$before$ca$afterT"
	outF="$before$ca$afterO"
	awk -f wireless_802_15_4_static.awk $traceF > $outF
	echo "AWK FILE COMPLETE"
	while read val
	do
			
		l=$(($l+1))
		node=30

		if [ "$l" == "1" ]; then
			thr=$(echo "scale=5; $thr+$val/$node*1.0" | bc)
			echo -ne "throughput: $thr "
		elif [ "$l" == "2" ]; then
			del=$(echo "scale=5; $del+$val/$node*1.0" | bc)
			echo -ne "delay: "
		elif [ "$l" == "3" ]; then
			s_packet=$(echo "scale=5; $s_packet+$val/$node*1.0" | bc)
			echo -ne "send packet: "
		elif [ "$l" == "4" ]; then
			r_packet=$(echo "scale=5; $r_packet+$val/$node*1.0" | bc)
			echo -ne "received packet: "
		elif [ "$l" == "5" ]; then
			d_packet=$(echo "scale=5; $d_packet+$val/$node*1.0" | bc)
			echo -ne "drop packet: "
		elif [ "$l" == "6" ]; then
			del_ratio=$(echo "scale=5; $del_ratio+$val/$node*1.0" | bc)
			echo -ne "delivery ratio: "
		elif [ "$l" == "7" ]; then
			dr_ratio=$(echo "scale=5; $dr_ratio+$val/$node*1.0" | bc)
			echo -ne "drop ratio: "
		elif [ "$l" == "8" ]; then
			time=$(echo "scale=5; $time+$val/$node*1.0" | bc)
			echo -ne "time: "
		elif [ "$l" == "9" ]; then
			t_energy=$(echo "scale=5; $t_energy+$val/$node*1.0" | bc)
			echo -ne "total_energy: "
		elif [ "$l" == "10" ]; then
			energy_bit=$(echo "scale=5; $energy_bit+$val/$node*1.0" | bc)
			echo -ne "energy_per_bit: "
		elif [ "$l" == "11" ]; then
			energy_byte=$(echo "scale=5; $energy_byte+$val/$*1.0" | bc)
			echo -ne "energy_per_byte: "
		elif [ "$l" == "12" ]; then
			energy_packet=$(echo "scale=5; $energy_packet+$val/$node*1.0" | bc)
			echo -ne "energy_per_packet: "
		elif [ "$l" == "13" ]; then
			total_retransmit=$(echo "scale=5; $total_retransmit+$val/$node*1.0" | bc)
			echo -ne "total_retrnsmit: "
		elif [ "$l" == "14" ]; then
			energy_efficiency=$(echo "scale=9; $energy_efficiency+$val/$*1.0" | bc)
			echo -ne "energy_efficiency: "
		elif [ "$l" == "15" ]; then
			jitter=$(echo "scale=1; $jitter+$val" | bc)
			echo -ne "jitter: "
		fi
		echo "$val"
		echo -ne "$val " >> $dataF
	done < $outF
	echo "" >> $dataF
done 


enr_nj=$(echo "scale=2; $energy_efficiency*1000000000.0" | bc)

	
	
dir="DATA/VaryingCA"
output_file="$dir.out"

echo -ne "Throughput:          $thr \n" >> $output_file
echo -ne "AverageDelay:         $del \n" >> $output_file
echo -ne "Sent Packets:         $s_packet \n" >> $output_file
echo -ne "Received Packets:         $r_packet \n" >> $output_file
echo -ne "Dropped Packets:         $d_packet \n" >> $output_file
echo -ne "PacketDeliveryRatio:      $del_ratio \n" >> $output_file
echo -ne "PacketDropRatio:      $dr_ratio \n" >> $output_file
echo -ne "Total time:  $time \n" >> $output_file
echo -ne "\n" >> $output_file
echo -ne "\n" >> $output_file
echo -ne "Total energy consumption:        $t_energy \n" >> $output_file
echo -ne "Average Energy per bit:         $energy_bit \n" >> $output_file
echo -ne "Average Energy per byte:         $energy_byte \n" >> $output_file
echo -ne "Average energy per packet:         $energy_packet \n" >> $output_file
echo -ne "total_retransmit:         $total_retransmit \n" >> $output_file
echo -ne "energy_efficiency(nj/bit):         $enr_nj \n" >> $output_file
echo -ne "jitter:         $jitter \n" >> $output_file
echo "" >> $output_file



##
echo "Plotting Graph"
gnuplot graph.gnu
echo "Plotting GRAPH COMPLETE"

awk -f wireless_802_15_4pnt.awk GENERATED_FILE/Nodes_60Flows_30Ppc_300CVGArea_3X.tr > DATA/pnt.txt

echo "Plotting per node throughput"
gnuplot pnt.gnu
echo "Plotting per node throughput COMPLETE"