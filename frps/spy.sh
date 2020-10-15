    #! /bin/sh
      count=`ps -ef |grep server.py |grep -v "grep" |wc -l`
      time=`date +"%Y-%m-%d %H:%M.%S"`
      if [ 0 == $count ];then
		sh /root/shadowsocksr/logrun.sh
		echo $time" shadowsocksr starting" >> /tmp/spy.log
		time=`date +"%Y-%m-%d %H:%M.%S"`
		echo $time" shadowsocksr start failed" 2>> /tmp/spy.log
		sleep 30
		count=`ps -ef |grep server.py |grep -v "grep" |wc -l`
		if [ 1 == $count ];then
			echo $time" shadowsocksr start successfully" >> /tmp/spy.log
	    	fi
      fi
