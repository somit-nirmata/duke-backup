cd /apps/nirmata/backup/prod

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
echo "Hi, nadm backup is successfull on zephyr production. Backup name is $file and size is $f_size" | mail -r "Zephyr-prod" -s "Backup success: Zephyr Prod" "mg.mostofa_ext@novartis.com","NX_MW_OPS_ORG@dl.mgd.novartis.com","NX_MW_ORG@dl.mgd.novartis.com" # Action if true

else
echo "Hi, nadm backup is failed. Either backup is corrupted or backup file is not available for today. Please look into the case" | mail -r "Zephyr-Prod" -s "Backup failure: Zephyr Prod" "mg.mostofa_ext@novartis.com","NX_MW_OPS_ORG@dl.mgd.novartis.com","NX_MW_ORG@dl.mgd.novartis.com" # Action if false
fi
