startmysql(){
io=$1
iomax=$3
pushd /data/opt/vadim/bin/Percona-Server-5.7.11-4-Linux.x86_64.ssl100
sync
sysctl -q -w vm.drop_caches=3
echo 3 > /proc/sys/vm/drop_caches
LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so.1 numactl --interleave=all bin/mysqld --defaults-file=/etc/my.ps57.cnf --datadir=/data/flash/tpcc1000 --basedir=$PWD --user=root --ssl=0 --innodb-buffer-pool-size=12884901888 --innodb_log_file_size=2G --innodb-io-capacity=$io --innodb-io-capacity-max=$iomax --innodb_lru_scan_depth=$2
}

shutdownmysql(){
echo "Shutting mysqld down..."
mysqladmin shutdown -S /tmp/mysql.sock
}

restorebackup(){
echo "Restoring backup..."
rm -fr /data/flash/tpcc1000/*
cp -r /data/flash/tpcc1000.back/* /data/flash/tpcc1000/ 
}

waitmysql(){

set +e

while true;
do
mysql -Bse "SELECT 1" mysql

if [ "$?" -eq 0 ]
then
break
fi

sleep 30

echo -n "."
done
set -e

}

scandepth=8192
io=100
i=150
while [ "$i" -le 30000 ] ;
do
echo $i

restorebackup
startmysql $io $scandepth $i &
waitmysql

#cgclassify -g memory:DBLimitedGroup `pidof mysqld`

./tpcc_start -w 1000 -c 100 -h 127.0.0.1 -d tpcc1000 -i 10 -l 900 | tee -a res_log2G_iomax/res.io${i}.iomax${i}.scandepth${scandepth}.txt

shutdownmysql

i=$((($i+$i*30/100)/10*10))
done
