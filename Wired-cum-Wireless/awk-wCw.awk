BEGIN {
	max_node = 2000;
	nSentPackets = 0.0 ;		
	nReceivedPackets = 0.0 ;
	rTotalDelay = 0.0 ;
	max_pckt = 10000;
	
	idHighestPacket = 0;
	idLowestPacket = 100000;
	rStartTime = 10000.0;
	rEndTime = 0.0;
	nReceivedBytes = 0;

	nDropPackets = 0.0;

	temp = 0;

	for (i=0; i<max_node; i++) {
		node_thr[i] = 0;		
	}

	total_retransmit = 0;
	for (i=0; i<max_pckt; i++) {
		retransmit[i] = 0;		
	}

}

{
	if ( $5 == "---" ) {
		#	event = $1;    time = $2;    node = $3;    type = $4;    reason = $5;    node2 = $5;    
		#	packetid = $6;    mac_sub_type=$7;    size=$8;    source = $11;    dest = $10;

			strEvent = $1 ;			rTime = $2 ;
			node = $3 ;
			strAgt = $4 ;			idPacket = $6 ;
			strType = $7 ;			nBytes = $8;

			
			num_retransmit = $20;
			
			sub(/^_*/, "", node);
			sub(/_*$/, "", node);

			

			if (strType == "tcp" ) {
				if (idPacket > idHighestPacket) idHighestPacket = idPacket;
				if (idPacket < idLowestPacket) idLowestPacket = idPacket;

				if(rTime>rEndTime) rEndTime=rTime;
				if(rTime<rStartTime) rStartTime=rTime;

				if ( strEvent == "s" ) {
					nSentPackets += 1 ;	rSentTime[ idPacket ] = rTime ;
				}

				if ( strEvent == "r" && idPacket >= idLowestPacket) {
					nReceivedPackets += 1 ;		nReceivedBytes += nBytes;
					rReceivedTime[ idPacket ] = rTime ;
					rDelay[idPacket] = rReceivedTime[ idPacket] - rSentTime[ idPacket ];
					rTotalDelay += rDelay[idPacket]; 
					node_thr[node] += nBytes;
				}
			}

			if( strEvent == "D"   &&   strType == "tcp" )
			{
				if(rTime>rEndTime) rEndTime=rTime;
				if(rTime<rStartTime) rStartTime=rTime;
				nDropPackets += 1;
			}

			if( strType == "tcp" )
			{
				retransmit[idPacket] = num_retransmit;		
			}
			



	}
	else {
		strEvent = $1;  
		rTime = $2;
		from_node = $3;
		to_node = $4;
		pkt_type = $5;
		pkt_size = $6;
		flgStr = $7;
		flow_id = $8;
		src_addr = $9;
		dest_addr = $10;
		#seq_no = $11;
		pkt_id = $11;

		sub(/^_*/, "", node);
		sub(/_*$/, "", node);

		
		
		if(pkt_type == "tcp"){

			if (pkt_id > idHighestPacket) idHighestPacket = pkt_id;
			if (pkt_id < idLowestPacket) idLowestPacket = pkt_id;	
			
		
			if(rTime<rStartTime) rStartTime=rTime;
			if(rTime>rEndTime) rEndTime=rTime;	
			if ( strEvent == "+" && pkt_size == "1040") {
				
				source = int(from_node)
				potential_source = int(src_addr)
				if(source == potential_source) {
					nSentPackets += 1 ;	rSentTime[ pkt_id ] = rTime ;
					send_flag[pkt_id] = 1;
				}
				
				
				
			}
			potential_dest = int(to_node)
			dest = int(dest_addr) 
			if ( strEvent == "r" && potential_dest == dest && pkt_size == "1040") {
				nReceivedPackets += 1 ;		nReceivedBytes += pkt_size;
				potential_source = int(src_addr)
				rReceivedTime[ pkt_id ] = rTime ;
				rDelay[pkt_id] = rReceivedTime[ pkt_id] - rSentTime[ pkt_id ];
				rTotalDelay += rDelay[pkt_id]; 
				node_thr[potential_source] += pkt_size;
			}
			if(strEvent == "d" && pkt_size == "1040"){
				#printf("Packet Dropped\n");
				
				nDropPackets += 1;
			}
		}


	}



}

END {
	rTime = rEndTime - rStartTime ;
	rThroughput = nReceivedBytes*8 / rTime;
	rPacketDeliveryRatio = nReceivedPackets / nSentPackets * 100 ;
	rPacketDropRatio = nDropPackets / nSentPackets * 100;


	if ( nReceivedPackets != 0 ) {
		rAverageDelay = rTotalDelay / nReceivedPackets ;
	}

	

	for (i=0; i<max_pckt; i++) {
		total_retransmit += retransmit[i] ;		
	}

	printf( "%15.2f\n%15.5f\n%15.2f\n%15.2f\n%15.2f\n%10.2f\n%10.2f\n%10.5f\n", rThroughput, rAverageDelay, nSentPackets, nReceivedPackets, nDropPackets, rPacketDeliveryRatio, rPacketDropRatio,rTime) ;
	printf( "%15.0f\n", total_retransmit);
	

	for (i=0; i<max_node; i++) {
		if (node_thr[i] > 0) {
			printf("%15d %15.5f\n", i, node_thr[i]*8 / rTime );
		}
	}



}


