for cidr in `cat cahq-targets.txt`; do
  echo ${cidr}
  netblock=`echo ${cidr} | cut -f 1 -d '/'`
  echo ${netblock}
  mkdir -p /root/billm/${netblock}
  cd /root/billm/${netblock}
  masscan --rate=5000 -p1- -oG ${netblock}-masscan.grep ${cidr}
  cat ${netblock}-masscan.grep | grep "Host:" | grep Timestamp | cut -f 3 -d " " | sort -u > living-hosts
  cat ${netblock}-masscan.grep | grep "Host:" | grep Timestamp | cut -f 5 -d " " | cut -f 1 -d '/' | sort -u > portlist
  for i in `cat portlist`; do
          echo -n ${i},
  done > portlist-commas
  nmap -A -sS -sV -p $(cat portlist-commas | sed -e 's/,$//') -iL living-hosts -oA living-hosts -v -T3
  cd /root/billm
done
