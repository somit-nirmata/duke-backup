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
