BEGIN {
	max_node = 2000;
	nSentPackets = 0.0 ;		
	nReceivedPackets = 0.0 ;
	rTotalDelay = 0.0 ;
	max_pckt = 10000;

	header = 0;#20;	

	idHighestPacket = 0;
	idLowestPacket = 100000;
	rStartTime = 10000.0;
	rEndTime = 0.0;
	nReceivedBytes = 0;
	rEnergyEfficeincy = 0;

	nDropPackets = 0.0;

	total_energy_consumption = 0;

	temp = 0;

	for(i=0; i<max_node; i++) {
		nTrhoughput[i] = 0;
	}
	
	for (i=0; i<max_node; i++) {
		energy_consumption[i] = 0;		
	}

	total_retransmit = 0;
	for (i=0; i<max_pckt; i++) {
		retransmit[i] = 0;		
	}
	delayX=0.0;
	delayX2=0.0;
	delayC=0;
}

{

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

	if ( strAgt == "AGT"   &&   strType == "tcp") {
		if (idPacket > idHighestPacket) idHighestPacket = idPacket;
		if (idPacket < idLowestPacket) idLowestPacket = idPacket;

		if(rTime<rStartTime) {
			rStartTime=rTime;
		}

		if ( strEvent == "s" ) {
			nSentPackets += 1 ;	r
			SentTime[ idPacket ] = rTime ;
		}
		if ( strEvent == "r" && idPacket >= idLowestPacket) {
			nReceivedPackets += 1 ;		
			nReceivedBytes += (nBytes-header);
			nThroughput[node%max_node]+=(nBytes-header);
			rReceivedTime[ idPacket ] = rTime ;
			rDelay[idPacket] = rReceivedTime[ idPacket] - rSentTime[ idPacket ];
			rTotalDelay += rDelay[idPacket]; 
			delayX+=rDelay[idPacket];
			delayX2+=(rDelay[idPacket])*(rDelay[idPacket]);
			delayC++;
		}
	}

	if( strEvent == "D"   &&   strType == "tcp" )
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
	rPacketDeliveryRatio = nReceivedPackets / nSentPackets * 100 ;
	rPacketDropRatio = nDropPackets / nSentPackets * 100;
	

	jitter=sqrt((delayX2/delayC)-(delayX/delayC)*(delayX/delayC));

	for(i=0; i<max_node;i++) {
		nThroughput[i]=nThroughput[i]*8/rTime;
	}


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


	

	for(i=0; i<max_node;i++) {
		nThroughput[i]=nThroughput[i]*8/rTime;
		if(nThroughput[i] != 0.0)
		{
			printf("%d\t%f\n",i,nThroughput[i]);			
		}
	}
}


