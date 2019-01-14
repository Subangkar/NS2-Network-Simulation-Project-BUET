BEGIN {
	max_node = 2000;
	nSentPackets = 0.0 ;
	nReceivedPackets = 0.0 ;
	rTotalDelay = 0.0 ;
	max_pckt = 10000;

	header = 20;

	idHighestPacket = 0;
	idLowestPacket = 100000;
	rStartTime = 10000.0;
	rEndTime = 0.0;
	nReceivedBytes = 0;
	total_energy_consumption = 0;
	rEnergyEfficeincy = 0;

	nDropPackets = 0.0;
	total_retransmit = 0;

	temp = 0;

	for (i=0; i<max_node; i++) {
		energy_consumption[i] = 0;
	}

	for (i=0; i<max_pckt; i++) {
		retransmit[i] = 0;
	}

	# for (i=0; i<max_pckt; i++) {
	# 	throughput_per_node[i] = 0;
	# }

	# for (i=0; i<max_pckt; i++) {
	# 	throughput_per_node[i] = 0;
	# }
}

{
#	event = $1;    time = $2;    node = $3;    type = $4;    reason = $5;    node2 = $5;
#	packetid = $6;    mac_sub_type=$7;    size=$8;    source = $11;    dest = $10;    energy=$14;
#   r 1.021685760 _96_ MAC  --- 0 AODV 48 [0 ffffffff 3e 800] [energy 99.998760 ei 0.001 es 0.000 et 0.000 er 0.000] ------- [62:255 -1:255 29 0] [0x2 2 1 [54 0] [96 4]] (REQUEST)
# 	r 7.449846293 _89_ AGT  --- 32109 cbr 84 [0 59 3e 800] [energy 99.969603 ei 0.005 es 0.000 et 0.001 er 0.025] ------- [9:0 89:0 28 89] [1284] 3 0
#	[r].*_[1-9]+_ AGT
# 	r [1-9]+\.[1-9]+ _[1-9]+_ AGT

	strEvent = $1 ;			rTime = $2 ;
	node = $3 ;
	strAgt = $4 ;			idPacket = $6 ;
	strType = $7 ;			nBytes = $8;

	energy = $13;			total_energy = $14;
	idle_energy_consumption = $16;	sleep_energy_consumption = $18;
	transmit_energy_consumption = $20;	receive_energy_consumption = $22;
	num_retransmit = $30;

	sub(/^_*/, "", node);
	sub(/_*$/, "", node);

	if (energy == "[energy") {
		energy_consumption[node] = (idle_energy_consumption + sleep_energy_consumption + transmit_energy_consumption + receive_energy_consumption);
	}

	if( 0 && temp <=25 && energy == "[energy" && strEvent == "D") {
		printf("%s %15.5f %d %s %15.5f %15.5f %15.5f %15.5f %15.5f \n", strEvent, rTime, idPacket, energy, total_energy, idle_energy_consumption, sleep_energy_consumption, transmit_energy_consumption, receive_energy_consumption);
		temp+=1;
	}


	if ( strAgt == "AGT"   &&   strType == "cbr") {
		if (idPacket > idHighestPacket) idHighestPacket = idPacket;
		if (idPacket < idLowestPacket) idLowestPacket = idPacket;

		# printf("%d\n", idPacket); 
		
		if(rTime<rStartTime) {
			rStartTime=rTime;
		}

		if ( strEvent == "s" ) {
			nSentPackets += 1 ;	
			rSentTime[ idPacket ] = rTime ;
		}

		if ( strEvent == "r" && idPacket >= idLowestPacket) {
			# printVar="recv:";
			nReceivedPackets += 1 ;		
			# nReceivedBytes += nBytes;################
			nReceivedBytes += (nBytes-header);################
			rReceivedTime[ idPacket ] = rTime ;
			rDelay[idPacket] = rReceivedTime[ idPacket] - rSentTime[ idPacket ];
			rTotalDelay += rDelay[idPacket];

		}
	}

	if( strEvent == "D"   &&   strType == "cbr" )
	{
		if(rTime>rEndTime) rEndTime=rTime;
		nDropPackets += 1;
	}

	if( strType == "tcp" )
	{
		retransmit[idPacket] = num_retransmit;
	}

	if(rTime>rEndTime) rEndTime=rTime;

}

END {
	rTime = rEndTime - rStartTime ;
	rThroughput = nReceivedBytes*8 / rTime;
	rPacketDeliveryRatio = (nReceivedPackets / nSentPackets) * 100 ;
	rPacketDropRatio = (nDropPackets / nSentPackets) * 100;


	for(i=0; i<max_node;i++) {
		total_energy_consumption += energy_consumption[i];
	}
	if ( nReceivedPackets != 0 ) {
		rAverageDelay = rTotalDelay / nReceivedPackets ;
		avg_energy_per_packet = total_energy_consumption / nReceivedPackets ;
	}

	if ( nReceivedBytes != 0 ) {
		avg_energy_per_byte = total_energy_consumption / nReceivedBytes ;
		avg_energy_per_bit = avg_energy_per_byte / 8;
		rEnergyEfficeincy = total_energy_consumption / (nReceivedBytes*8);
	}

	for (i=0; i<max_pckt; i++) {
		total_retransmit += retransmit[i] ;
	}



	printf( "%15.2f\n%15.5f\n%15.2f\n%15.2f\n%15.2f\n%10.2f\n%10.2f\n%10.5f\n", rThroughput, rAverageDelay, nSentPackets, nReceivedPackets, nDropPackets, rPacketDeliveryRatio, rPacketDropRatio,rTime) ;
	# print "\n"
	printf("%15.5f\n%15.5f\n%15.5f\n%15.5f\n%15.0f\n%15.9f\n", total_energy_consumption, avg_energy_per_bit, avg_energy_per_byte, avg_energy_per_packet, total_retransmit, rEnergyEfficeincy);

#	printf( "Throughput: %15.2f AverageDelay: %15.5f \nSent Packets: %15.2f Received Packets: %15.2f Dropped Packets: %15.2f \nPacketDeliveryRatio: %10.2f PacketDropRatio: %10.2f\nTotal time: %10.5f\n", rThroughput, rAverageDelay, nSentPackets, nReceivedPackets, nDropPackets, rPacketDeliveryRatio, rPacketDropRatio,rTime) ;
#	printf("\n\nTotal energy consumption: %15.5f Average Energy per bit: %15.5f Average Energy per byte: %15.5f Average energy per packet: %15.5f\n", total_energy_consumption, avg_energy_per_bit, avg_energy_per_byte, avg_energy_per_packet);
}
