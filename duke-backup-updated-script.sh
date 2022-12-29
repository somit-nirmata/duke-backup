#!/bin/bash -x
# Backup script
# 11/2/2018 Nirmata
#PASSWORD=QXByaWxAMjAxOAo=
#PASSWORD=ZGtzQWRtaW5ARGVjMjAxOQo=
PASSWORD=ZGtzQWRtaW5ASnVuZTIwMjEK
#BACKUPDIR=/home/diamanti/backup-nirmata
BACKUPDIR=/data/backup-nirmata
dctl login -u admin -p $(echo $PASSWORD |base64 -d)
export  NADM_HOME=/home/diamanti
/home/diamanti/nirmata/nadm-3.5.4/nadm backup -d $BACKUPDIR -n nirmata --all

cd $BACKUPDIR
file=$(ls -Art | tail -n 1)
f_dt="$(echo "$file"|grep -Eo "[0-9]{4}\-[0-9]{2}\-[0-9]{2}")"
echo $f_dt

s_dt="$( date +%Y-%m-%d )"
echo $s_dt
cd $file

f_size="$(du -sh * |awk '{print $1}')"
echo $f_size

if [ "$f_dt" = "$s_dt" ]
then
echo "Hi, nadm backup is successfull on Nirmata Dev. Backup name is $file and size is $f_size" | mail -r "Nirmata-Dev" -s "Backup success:Nirmata-Dev" "john.coyne@duke-energy.com","dolis@nirmata.com","somit@nirmata.com" # Action if true

else
echo "Hi, nadm backup is failed. Either backup is corrupted or backup file is not available for today. Please look into the case" | mail -r "Zephyr-Prod" -s "Backup failure: Zephyr Prod" "john.coyne@duke-energy.com","dolis@nirmata.com","somit@nirmata.com" # Action if false
fi

for i in `find  /home/diamanti/backup-nirmata -type f -mtime +7` ; do rm -f $i ;done
for i in `find  /home/diamanti/backup-nirmata -type d -mtime +7`; do rmdir $i ;done

backup_dir=/nasbkhomedirmnt/
backup_target=/home/diamanti/
nfs=cdcgpnas02nfs:/ifs/CDCGENNAS01/CDCGPNAS02/SMB/CAAS/diamantihomebk
HOSTNAME=$(hostname)
cluster=d1


mkdir -p $backup_dir
umount -lf $backup_dir
sleep 5
# Maybe switch soft to intr
mount -o soft,vers=3 $nfs $backup_dir
mkdir  -p $backup_dir/$cluster/${HOSTNAME}
rsync --exclude=.kube -azvh $backup_target  $backup_dir/$cluster/${HOSTNAME}/
umount  $backup_dir
