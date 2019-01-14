set terminal png




set output "GRAPH/TPvsN.png"
set title "Network Throughput vs Number of Nodes"
set xlabel "Number of Nodes"
set ylabel "Network Throughput"
plot "DATA/plotingvarynode.txt" using 1:2 with lines title "Flow 30 PPS 300 CA 3X"

set output "GRAPH/TPvsF.png"
set title "Network Throughput vs Number of Flows"
set xlabel "Number of Flows"
set ylabel "Network Throughput"
plot "DATA/plotingvaryflow.txt" using 1:2 with lines title "Node 60 PPS 300 CA 3X"

set output "GRAPH/TPvsP.png"
set title "Network Throughput vs Packet per second"
set xlabel "Packet per second"
set ylabel "Network Throughput"
plot "DATA/plotingvarypps.txt" using 1:2 with lines title "Node 60 Flow 30 CA 3X"

set output "GRAPH/TPvsC.png"
set title "Network Throughput vs Coverage Area(X100m)"
set xlabel "Coverage Area(X100m)"
set ylabel "Network Throughput"
plot "DATA/plotingvaryca.txt" using 1:2 with lines title "Node 60 Flow 30 PPS 300"




set output "GRAPH/DLvsN.png"
set title "End to end delay vs Number of Nodes"
set xlabel "Number of Nodes"
set ylabel "End to End Delay"
plot "DATA/plotingvarynode.txt" using 1:3 with lines title "Flow 30 PPS 300 CA 3X"

set output "GRAPH/DLvsF.png"
set title "End to end delay vs Number of Flows"
set xlabel "Number of Flows"
set ylabel "End to End Delay"
plot "DATA/plotingvaryflow.txt" using 1:3 with lines title "Node 60 PPS 300 CA 3X"

set output "GRAPH/DLvsP.png"
set title "End to end delay vs Packet per second"
set xlabel "Packet per second"
set ylabel "End to End Delay"
plot "DATA/plotingvarypps.txt" using 1:3 with lines title "Node 60 Flow 30 CA 3X"

set output "GRAPH/DLvsC.png"
set title "End to End delay vs Coverage Area(X100m)"
set xlabel "Coverage Area(X100m)"
set ylabel "End to End Delay"
plot "DATA/plotingvaryca.txt" using 1:3 with lines title "Node 60 Flow 30 PPS 300"





set output "GRAPH/DLRvsN.png"
set title "Packet Delivery Ratio vs Number of Nodes"
set xlabel "Number of Nodes"
set ylabel "Packet Delivery Ratio"
plot "DATA/plotingvarynode.txt" using 1:7 with lines title "Flow 30 PPS 300 CA 3X"

set output "GRAPH/DLRvsF.png"
set title "Packet Delivery Ratio vs Number of Flows"
set xlabel "Number of Flows"
set ylabel "Packet Delivery Ratio"
plot "DATA/plotingvaryflow.txt" using 1:7 with lines title "Node 60 PPS 300 CA 3X"

set output "GRAPH/DLRvsP.png"
set title "Packet Delivery Ratio vs Packet per second"
set xlabel "Packet per second"
set ylabel "Packet Delivery Ratio"
plot "DATA/plotingvarypps.txt" using 1:7 with lines title "Node 60 Flow 30 CA 3X"

set output "GRAPH/DLRvsC.png"
set title "Packet Delivery Ratio vs Coverage Area(X100m)"
set xlabel "Coverage Area(X100m)"
set ylabel "Packet Delivery Ratio"
plot "DATA/plotingvaryca.txt" using 1:7 with lines title "Node 60 Flow 30 PPS 300"





set output "GRAPH/DRRvsN.png"
set title "Packet Drop Ratio vs Number of Nodes"
set xlabel "Number of Nodes"
set ylabel "Packet Drop Ratio"
plot "DATA/plotingvarynode.txt" using 1:8 with lines title "Flow 30 PPS 300 CA 3X"

set output "GRAPH/DRRvsF.png"
set title "Packet Drop Ratio vs Number of Flows"
set xlabel "Number of Flows"
set ylabel "Packet Drop Ratio"
plot "DATA/plotingvaryflow.txt" using 1:8 with lines title "Node 60 PPS 300 CA 3X"

set output "GRAPH/DRRvsP.png"
set title "Packet Drop Ratio vs Packet per second"
set xlabel "Packet per second"
set ylabel "Packet Drop Ratio"
plot "DATA/plotingvarypps.txt" using 1:8 with lines title "Node 60 Flow 30 CA 3X"

set output "GRAPH/DRRvsC.png"
set title "Packet Drop Ratio vs Coverage Area(X100m)"
set xlabel "Coverage Area(X100m)"
set ylabel "Packet Drop Ratio"
plot "DATA/plotingvaryca.txt" using 1:8 with lines title "Node 60 Flow 30 PPS 300"






set output "GRAPH/ENCvsN.png"
set title "Energy Consumption vs Number of Nodes"
set xlabel "Number of Nodes"
set ylabel "Energy Consumption"
plot "DATA/plotingvarynode.txt" using 1:10 with lines title "Flow 30 PPS 300 CA 3X"

set output "GRAPH/ENCvsF.png"
set title "Energy Consumption vs Number of Flows"
set xlabel "Number of Flows"
set ylabel "Energy Consumption"
plot "DATA/plotingvaryflow.txt" using 1:10 with lines title "Node 60PPS 300 CA 3X"

set output "GRAPH/ENCvsP.png"
set title "Energy Consumption vs Packet per second"
set xlabel "Packet per second"
set ylabel "Energy Consumption"
plot "DATA/plotingvarypps.txt" using 1:10 with lines title "Node 60 Flow 30CA 3X"

set output "GRAPH/ENCvsC.png"
set title "Energy Consumption vs Coverage Area(X100m)"
set xlabel "Coverage Area(X100m)"
set ylabel "Energy Consumption"
plot "DATA/plotingvaryca.txt" using 1:10 with lines title "Node 60 Flow 30 PPS 300"









set output "GRAPH/JTvsN.png"
set title "Jitter vs Number of Nodes"
set xlabel "Number of Nodes"
set ylabel "Jitter"
plot "DATA/plotingvarynode.txt" using 1:16 with lines title "Flow 30 PPS 300 CA 3X"

set output "GRAPH/JTvsF.png"
set title "Jitter vs Number of Flows"
set xlabel "Number of Flows"
set ylabel "Jitter"
plot "DATA/plotingvaryflow.txt" using 1:16 with lines title "Node 60 PPS 300 CA 3X"

set output "GRAPH/JTvsP.png"
set title "Jitter vs Packet per second"
set xlabel "Packet per second"
set ylabel "Jitter"
plot "DATA/plotingvarypps.txt" using 1:16 with lines title "Node 60 Flow 30 CA 3X"

set output "GRAPH/JTvsC.png"
set title "Jitter vs Coverage Area(X100m)"
set xlabel "Coverage Area(X100m)"
set ylabel "Jitter"
plot "DATA/plotingvaryca.txt" using 1:16 with lines title "Node 60 Flow 30 PPS 300"
