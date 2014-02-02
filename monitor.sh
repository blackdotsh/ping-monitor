#!/bin/bash
#Coded by black @ LET
#Licensed under GPLv3
#Please give credit if you plan on using this for non-personal use

#add the hosts you want to check in a file called monitorList
#each host must be on a separate line

while [ true ]
do

for host in `cat monitorList`
do
	ping $host -c 5 -q -i 2;
	if [ $? -eq 1 ]
	then
		grep "$host" downList;
		if [ $? -ne 0 ]
		then
			##check high avability site 
			ping google.com -c 5 -q -i 2;
			if [ $? -eq 0 ]
			then
			##ugh i'm getting too many texts, check it again
			ping $host -c 5 -q -i 2;
				#still down, send text message
				if [ $? -eq 1 ]
				then
				#Your host is down, do something here, I have emails sent using an SMS gateway, you can find yours here
				# http://en.wikipedia.org/wiki/List_of_SMS_gateways
				# make sure your outbound email is working!

				
				echo "$host" >> downList;
				fi
			fi
		fi
	fi
done

for host in `cat downList`
do
	ping $host -c 3 -q;
        if [ $? -eq 0 ]
	then
		#Host is back online, do something here


		delLine=`grep "$host" downList -n | cut -d ":" -f1`;
		sed -i -e "$delLine d" downList;
	fi
done
sleep 60;
done
