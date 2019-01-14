BEGIN {
	
	
	max_node = 2000;
	nSentPackets = 0.0 ;		
	nReceivedPackets = 0.0 ;
	rTotalDelay = 0.0 ;
	max_pckt = 100000000;
	
	idHighestPacket = 0;
	idLowestPacket = 100000;
	rStartTime = 10000.0;
	rEndTime = 0.0;
	nReceivedBytes = 0;

	nDropPackets = 0.0;

	# header = 20;	
	header = 40;# for tcp	

	# for (i=0; i<max_pckt; i++) {
	# 	rReceivedTime[i] = 0.0;
	# }

}

{
# + 0.00017 0 1 rtProtoDV 20 ------- 0 0.2 1.4 -1 0
# - 0.00017 0 1 rtProtoDV 20 ------- 0 0.2 1.4 -1 0
# r 0.020234 5 10 rtProtoDV 20 ------- 0 5.1 10.1 -1 10
# + 29.750102 3 2 cbr 16 ------- 6 19.2 0.0 2871 30195
# - 29.750102 3 2 cbr 16 ------- 6 19.2 0.0 2871 30195
# r 29.750128 3 2 cbr 16 ------- 6 19.2 0.0 2870 30185
# http://www.mathcs.emory.edu/~cheung/Courses/558-old/Syllabus/90-NS/PerfAnal.html
# r [0-9]+\.[0-9]+ [0-9]+ [0-9]+ cbr

	strEvent = $1 ;	
	rTime = $2 ;
	from = $3;
	to = $4;
	pcktType = $5;
	pcktSize = $6;
	flags = $7; flagid = $8;
	source = $9; dest = $10; # node.port -> actual src & dest
	seqNum = $11; idPacket = $12;

	source = int(source);
	dest = int(dest);
	
	# if(pcktType=="cbr"){
	if(pcktType=="tcp"){

		if(rTime < rStartTime) rStartTime=rTime;
		if(rTime > rEndTime) rEndTime=rTime;

		if(strEvent == "+" && from == source)
		{
			nSentPackets += 1 ;	rSentTime[ idPacket ] = rTime ;
		}
		if(strEvent == "r" && to == dest && rReceivedTime[ idPacket ] == 0.0)
		{
			nReceivedPackets += 1 ;	
			nReceivedBytes += (pcktSize-header);
			rReceivedTime[ idPacket ] = rTime ;
			rDelay[idPacket] = rReceivedTime[ idPacket] - rSentTime[ idPacket ];
			rTotalDelay += rDelay[idPacket]; 
		}

		if( strEvent == "d")
		{
			nDropPackets += 1;
		}
	}

}

END {
	rTime = rEndTime - rStartTime ;
	rThroughput = (nReceivedBytes*8) / rTime;
	rPacketDeliveryRatio = (nReceivedPackets / nSentPackets) * 100 ;
	rPacketDropRatio = (nDropPackets / nSentPackets) * 100;

	if ( nReceivedPackets != 0 ) {
		rAverageDelay = rTotalDelay / nReceivedPackets ;
	}
	# printf( "%15.5f\n%10.2f\n%10.2f\n%10.2f\n", rThroughput, rAverageDelay,rPacketDeliveryRatio, rPacketDropRatio) ;
	printf( "%15.2f\n%15.5f\n%15.2f\n%15.2f\n%15.2f\n%10.2f\n%10.2f\n%10.5f\n%10.5f\n", rThroughput, rAverageDelay, nSentPackets, nReceivedPackets, nDropPackets, rPacketDeliveryRatio, rPacketDropRatio,rTime,rTotalDelay) ;

}

