Follow this if you are using Ubuntu 18.04 or higher specificly  
- First download "ns2-allinone-2.35.tar.xz" from [sourceforge.net](https://sourceforge.net/projects/nsnam/files/latest/download) or [here](https://drive.google.com/file/d/1O3ZgLYc-gDqjrkXQdCGklMJdIvr_ExB-/view?usp=sharing)  
- change directory to the folder containing ns-allinone-2.35.tar.gz folder. Recommanded directory : ~ (home directory)
- compilation of ns2 requires specifically gcc-4.8 g++-4.8 , higher version will cause error. (Default in 18.04 is version 7+)  
>>sudo apt-get install gcc-4.8 g++-4.8
>>sudo apt-get install autoconf automake build-essential libxmu-dev libtool libxt-dev
Now comes installation part  
- unzip
- move your tar.gz into your home folder
>>mv ns-allinone-2.35.tar.gz ~
- untar the tar
>>cd ~
>>tar -xvzf ns-allinone-2.35.tar.gz
- modify makefile and set gcc and g++ version
>>cd ns-allinone-2.35
>>cd ns-2.35
>>gedit Makefile.in
- change gcc and g++ version to 4.8 (gcc-4.8, g++-4.8)
- save and close Makefile.in
>>gedit linkstate/ls.h
- search for the line eraseAll()
- replace erase with this->erase
- now move to ns2-allinone-2.35 root folder and install
>>cd ..
>>./install

- add these following lines to ".bashrc" file after 3rd line containing #for examples line
>>gedit ~/.bashrc
>>#LD_LIBRARY_PATH
>>OTCL_LIB=~/ns-allinone-2.35/otcl-1.14
>>NS2_LIB=~/ns-allinone-2.35/lib
>>X11_LIB=/usr/X11R6/lib
>>USR_LOCAL_LIB=/usr/local/lib
>>export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$OTCL_LIB:$NS2_LIB:$X11_LIB:$USR_LOCAL_LIB

 >># TCL_LIBRARY
 >>TCL_LIB=~/ns-allinone-2.35/tcl8.5.10/library
 >>USR_LIB=/usr/lib
 >>export TCL_LIBRARY=$TCL_LIB:$USR_LIB

>> # PATH
>> XGRAPH=~/ns-allinone-2.35/bin:~/ns-allinone-2.35/tcl8.5.10/unix:~//ns-allinone-2.35/tk8.5.10/unix
>> NS=~/ns-allinone-2.35/ns-2.35/
>> NAM=~/ns-allinone-2.35/nam-1.15/
>> PATH=$PATH:$XGRAPH:$NS:$NAM

- save and close .bashrc and load PATH variable and validate installation.
>>source ~/.bashrc
>>cd ns-2.35
>>./validate

- If all the test cases have been passed, you are done with installation.