BEGIN {
 	highest_packet_id = 0;
}

{
 	action = $1;
 	time = $2;
 	node_1 = $3;
 	node_2 = $4;
 	src = $5;
 	flow_id = $8;
 	node_1_address = $9;
 	node_2_address = $10;
 	seq_no = $11;
 	packet_id = $12;
 	if ( packet_id > highest_packet_id ) highest_packet_id = packet_id;
 		# getting start time is not a problem, provided you're not starting
 		# traffic at 0.0.
 		# could test for sending node_1_address or flow_id here.
 		if ( start_time[packet_id] == 0 ) start_time[packet_id] = time;

 		# only useful for small unicast where packet_id doesn't wrap.
 		# checking receive means avoiding recording drops
 		if ( action != "d" ) {
 			if ( action == "r" ) {
 			# could test for receiving node_2_address or flow_id here.
 			end_time[packet_id] = time;
 			}
 		} 
 		else {
 			end_time[packet_id] = -1;
 		}
}
END {
 	avg_delay=0;
 	count=0;
 	for ( packet_id = 0; packet_id <= highest_packet_id; packet_id++ ) {
 		start = start_time[packet_id];
 		end = end_time[packet_id];
 		packet_duration = end - start;
 		if ( start < end ) {
			#printf("%f %f\n", start, packet_duration);
			avg_delay+=packet_duration;
			count++;
		}
	}
	avg_delay/=count;
	printf("%f\n",avg_delay);
} 
