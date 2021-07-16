#!/bin/bash
cd ~/chia-p
rm *.tmp
cd ~/chia-log
echo "#!/bin/sh" > cpu.sh
ls -1s /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor | sed 's/0/echo performance >/1' >> cpu.sh
chmod +x cpu.sh
sudo ./cpu.sh
rm cpu.sh
logfile=`basename $0 | cut -d . -f 1`
rm $logfile.log &> /dev/null
user=`whoami`
group=`id -gn`
pkey="abeef2ef3751f1d3d27adbb4607b485896373a77aa8b9fca35f0e2c9469e8a103b4eb45945e0caf3842299d6d4f2acfe"
fkey="95baed9fb5545be345db88ba607bd36d212a99d579d0c23fba6383f1fb4d73643fd847062bba2bd16d05f9e844d113a4"
ckey="xch1dk79jxt3j40hryapv7ue54lpm0ltz7qdsut3ck2sek958rqc8cusxrehwe"
count=$1

for i in "$@"
do
	if [ $i == $1 ]; then
		printf "Start $i plots "
	else
		space=`df -B 1 $i | tail -1 | awk '{print $4}'`
		sudo chown -R $user:$group $i
		if [ $space -gt 109000000000 ] ;then
			until [ $count == 0 ]
			do
				echo "$i: free space $space"
				cd ~/chia-plotter/build;
#				./chia_plot -p $pkey -f $fkey -t ~/chia-p/ -2 ~/chia-p/ -r $(nproc) -u 6 -n 1 >> ~/chia-log/$logfile.log
				./chia_plot -c $ckey -f $fkey -t ~/chia-p/ -2 ~/chia-p/ -r $(nproc) -u 6 -n 1 >> ~/chia-log/$logfile.log
				cd ~/chia-p
				rm *.tmp &> /dev/null
				space=`df -B 1G $i | tail -1 | awk '{print $4}'`
				rsync --remove-source-files plot*.plot $i &
				if [ $space -gt 203 ] ;then
					((count--))
				else
					echo "$i: Not enought space $space, skip"
					break
				fi
			done
		else
			echo "$i: Not enought space $space, skip"
			continue
		fi
	fi
done

