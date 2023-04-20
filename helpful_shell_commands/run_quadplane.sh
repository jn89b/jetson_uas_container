#go to ardupilot directory
cd ../
cd ardupilot/ArduPlane/

#run quad 
../Tools/autotest/sim_vehicle.py j4 -f quadplane --console --map  --out=udp:127.0.0.1:14560 --out=udp:127.0.01:14570 --out=udp:127.0.0.1:14551 

