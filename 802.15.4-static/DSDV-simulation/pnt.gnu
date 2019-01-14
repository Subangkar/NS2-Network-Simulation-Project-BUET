set terminal png




set output "GRAPH/PNT.png"
set title "Network Throughput vs Node"
set xlabel "Nodes Sequence"
set ylabel "Network Throughput"
plot "DATA/pnt.txt" using 1:2 with impulses title "Node 60 Flow 30 PPS 300 CA 3X"
