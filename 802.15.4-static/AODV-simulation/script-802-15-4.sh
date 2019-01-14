
#INPUT: output file AND number of iterations
outputDirectory="out/"
rm -rf outputDirectory
rm -rf Output
mkdir -p $outputDirectory
iteration_float=10.0;
under="_";
param=4


###################   FILES   ###################
outFileName="$outputDirectory""OUT"
outFileExt=".out"
outFile="$outputDirectory""OUT.out"
tempFile="$outputDirectory""TEMPFILE.tmp"
graphData="$outputDirectory""GRAPH.graph"
graphFileName="out/GRAPH.graph"
tclFile="tcl-802-15-4.tcl"
awkFile="awk-802-15-4.awk"

###################   Parameters starting/default values   ###################
nNodesInit=40
nFlowsInit=10
pcktRateInit=100
txRangeInit=40;#40
# 40x40 grid


defFactor=1

(( nNodesDef =  $defFactor * $nNodesInit ))
(( nFlowsDef =  $defFactor * $nFlowsInit ))
(( pcktRateDef = $defFactor * $pcktRateInit ))
(( txRangeDef = 2 * $txRangeInit ))

nNodes=$nNodesDef
nFlows=$nFlowsDef
pcktRate=$pcktRateDef
txRange=$txRangeDef

iteration=$(printf %.0f $iteration_float);

#echo 'PLease enter # of nodes, # of flows, packet rate, and coverage area'
#read nNodes nFlows pcktRate area

echo '================='
echo '=====802.15.4===='
echo '================='

# echo 'Which parameter do you want to vary?'
# echo 'For # of nodes, please enter 1'
# echo 'For # of flows, please enter 2'
# echo 'For packet rate, please enter 3'
# echo 'For area, please enter 4'
# read param
# param=3

# echo 'Please enter the # of datasets'
# read nDataSet
nDataSet=5



if [ "$param" == "1" ]; then
	nNodes=$nNodesInit
	echo "Varying #Nodes"
elif [ "$param" == "2" ]; then
	nFlows=$nFlowsInit
	echo "Varying #Flows"
elif [ "$param" == "3" ]; then
	pcktRate=$pcktRateInit
	echo "Varying #PktRate"
elif [ "$param" == "4" ]; then
	txRange=$txRangeInit
	echo "Varying Coverage"
fi



round=1

while [ $round -le $nDataSet ]
do
	echo "total iteration: $iteration"
	###############################START A ROUND

	echo "#####################################################################"
	echo "                         ROUND : $round                              "
	echo "#####################################################################"

	l=0;thr=0.0;del=0.0;s_packet=0.0;r_packet=0.0;d_packet=0.0;del_ratio=0.0;
	dr_ratio=0.0;time=0.0;t_energy=0.0;energy_bit=0.0;energy_byte=0.0;energy_packet=0.0;total_retransmit=0.0;energy_efficiency=0.0;

	i=0
	while [ $i -lt $iteration ]
	do
		#################START AN ITERATION
		echo "                             EXECUTING $(($i+1)) th ITERATION"

		# ns $tclFile $nNodes $nFlows $pcktRate $speed
		ns $tclFile $nNodes $nFlows $pcktRate $txRange
		echo "SIMULATION COMPLETE. BUILDING STAT......"

		awk -f $awkFile TRACE.tr > $tempFile


		# ======================================================================
		# UPDATING THE VALUES IN EACH ITERATION
		# ======================================================================
		l=0
		while read val
		do

			l=$(($l+1))

			if [ "$l" == "1" ]; then
				thr=$(echo "scale=5; $thr+$val/$iteration_float" | bc)
				#		echo -ne "throughput: $thr "
			elif [ "$l" == "2" ]; then
				del=$(echo "scale=5; $del+$val/$iteration_float" | bc)
				#		echo -ne "delay: "
			elif [ "$l" == "3" ]; then
				s_packet=$(echo "scale=5; $s_packet+$val/$iteration_float" | bc)
				#		echo -ne "send packet: "
			elif [ "$l" == "4" ]; then
				r_packet=$(echo "scale=5; $r_packet+$val/$iteration_float" | bc)
				#		echo -ne "received packet: "
			elif [ "$l" == "5" ]; then
				d_packet=$(echo "scale=5; $d_packet+$val/$iteration_float" | bc)
				#		echo -ne "drop packet: "
			elif [ "$l" == "6" ]; then
				del_ratio=$(echo "scale=5; $del_ratio+$val/$iteration_float" | bc)
				#		echo -ne "delivery ratio: "
			elif [ "$l" == "7" ]; then
				dr_ratio=$(echo "scale=5; $dr_ratio+$val/$iteration_float" | bc)
				#		echo -ne "drop ratio: "
			elif [ "$l" == "8" ]; then
				time=$(echo "scale=5; $time+$val/$iteration_float" | bc)
				#		echo -ne "time: "
			elif [ "$l" == "9" ]; then
				t_energy=$(echo "scale=5; $t_energy+$val/$iteration_float" | bc)
				#		echo -ne "total_energy: "
			elif [ "$l" == "10" ]; then
				energy_bit=$(echo "scale=5; $energy_bit+$val/$iteration_float" | bc)
				#		echo -ne "energy_per_bit: "
			elif [ "$l" == "11" ]; then
				energy_byte=$(echo "scale=5; $energy_byte+$val/$iteration_float" | bc)
				#		echo -ne "energy_per_byte: "
			elif [ "$l" == "12" ]; then
				energy_packet=$(echo "scale=5; $energy_packet+$val/$iteration_float" | bc)
				#		echo -ne "energy_per_packet: "
			elif [ "$l" == "13" ]; then
				total_retransmit=$(echo "scale=5; $total_retransmit+$val/$iteration_float" | bc)
				#		echo -ne "total_retrnsmit: "
			elif [ "$l" == "14" ]; then
				energy_efficiency=$(echo "scale=9; $energy_efficiency+$val/$iteration_float" | bc)
				#		echo -ne "energy_efficiency: "
			fi

			#echo "$val"
		done < $tempFile

		i=$(($i+1))
	done

	# don't know what this is; found in sir's code
	enr_nj=$(echo "scale=2; $energy_efficiency*1000000000.0" | bc)


	# ==========================================================================
	# OUTPUT FILE GENERATION
	# ==========================================================================
	# output_file="$outFile$under$round"
	# echo "$outFileName$under$round$outFileExt"
	output_file="$outFileName$under$round$outFileExt"
	echo "" > $output_file # clearing the output file


	echo "# of Nodes:                   $nNodes " >> $output_file
	echo "# of flows:                   $nFlows " >> $output_file
	echo "Packet rate:                  $pcktRate " >> $output_file
	echo "Tx area:                        $txRange " >> $output_file


	echo "" >> $output_file
	echo "" >> $output_file
	echo "" >> $output_file


	echo "Throughput:                   $thr " >> $output_file
	echo "AverageDelay:                 $del " >> $output_file
	echo "Sent Packets:                 $s_packet " >> $output_file
	echo "Received Packets:             $r_packet " >> $output_file
	echo "Dropped Packets:              $d_packet " >> $output_file
	echo "PacketDeliveryRatio:          $del_ratio " >> $output_file
	echo "PacketDropRatio:              $dr_ratio " >> $output_file
	echo "Total time:                   $time " >> $output_file
	echo "Total energy consumption:     $t_energy " >> $output_file
	echo "Average Energy per bit:       $energy_bit " >> $output_file
	echo "Average Energy per byte:      $energy_byte " >> $output_file
	echo "Average energy per packet:    $energy_packet " >> $output_file
	echo "total_retransmit:             $total_retransmit " >> $output_file
	echo "energy_efficiency(nj/bit):    $enr_nj " >> $output_file

	cat $output_file
	# ==========================================================================

	round=$(($round+1))

	# ==========================================================================
	# GRAPH GENERATION
	# ==========================================================================
	if [ "$param" == "1" ]; then
		echo -ne "$nNodes " >> $graphData
		nNodes=$(($nNodesInit*$round))
	elif [ "$param" == "2" ]; then
		echo -ne "$nFlows " >> $graphData
		nFlows=$(($nFlowsInit*$round))
	elif [ "$param" == "3" ]; then
		echo -ne "$pcktRate " >> $graphData
		pcktRate=$(($pcktRateInit*$round))
	elif [ "$param" == "4" ]; then
		echo -ne "$txRange " >> $graphData
		txRange=$(($txRangeInit*$round))
	fi

	echo "$thr $del $del_ratio $dr_ratio $t_energy $energy_byte" >> $graphData
	# ==========================================================================
#######################################END A ROUND
done

if [ "$param" == "1" ]; then
	param="No of nodes"
elif [ "$param" == "2" ]; then
	param="No of flows"
elif [ "$param" == "3" ]; then
	param="Packet Rate"
elif [ "$param" == "4" ]; then
	param="Area ( square-meter )"
fi

arr[0]=""
arr[1]=""
arr[2]="Throughput"
arr[3]="Average Delay"
arr[4]="Packet Delivery Ratio"
arr[5]="Packet Drop Ratio"
arr[6]="Total Energy consumption"
arr[7]="Energy per byte"

arr2[0]=""
arr2[1]=""
arr2[2]="Throughput ( bit/second )"
arr2[3]="Average Delay ( second )"
arr2[4]="Packet Delivery Ratio ( % )"
arr2[5]="Packet Drop Ratio ( % )"
arr2[6]="Total Energy consumption ( J )"
arr2[7]="Energy per byte ( J )"

i=7
while [ $i -ge 2 ]
do
	gnuplot -persist -e "set terminal png size 700,500; set output '$outputDirectory${arr[$i]}VS$param.png'; set title '802.15.4 : ${arr[$i]} vs $param'; set xlabel '$param'; set ylabel '${arr2[$i]}'; plot '$graphFileName' using 1:$i with lines"
	i=$(($i-1))
done

# rm $tempFile
# rm TOPO.txt
# rm TRACE.tr
mv $outputDirectory "Output"
