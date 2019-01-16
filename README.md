# ns2-network-simulation  
  
A network simulation project in ns2 of Wired-802.3, IEEE802.15.4, Satellite, Wired-Wireless-802.11 cross network measuring performance metrics like total energy consumption, throughput, packet transfer ratio, average end-to-end delay, energy consumption per byte etc. with respect to variation in number of nodes, flows, number of packets per second and coverage area.  
Some modifications have also been performed to observe the impact of modifications on performance metrics.    
This simulation project work has been performed as an assignment of Computer Networking Sessional course in Level-3, Term-2 of Department of CSE, BUET. The tasks have been performed according to the specifications in "ns-2 project.pdf".    
  
  
**Networks under simulation**:  
- Wired  
- Wireless 802.15.4 (static)  
- Satellite  
- Wired-cum-Wireless 802.11  
  
   
**Modifications carried out in the ns2 simulator**:
- Change in AODV routing protocol.
- Change in Droptail queue's deque operation.
- Change in average calculation mechanism of RTT.
  
The details of the modifications can be found in the [project report](https://docs.google.com/document/d/1Ot-690dkxtCrEF8R09rs99eUwky0S6144jPTrgZadEw/).  
  
  
**Setup**:
- First, install ns-allinone-2.35 (preferably in your home folder). You may follow the instructions in "ns2-install-procedure.md" or from any other helping site.  
- To simulate the modified simulator version first replace corresponding files in ns-2.35 source directory (may be "/home/ns-allinone-2.35/ns-2.35/") with files provided in "Source Files (Modified)" folder
- Now, open a terminal in ns-2.35 source directory and execute the following command to compile the modified version:
    > make clean && make
  

**To simulate the network**:  
- run the shell script file in terminal to simulate the corresponding network.
