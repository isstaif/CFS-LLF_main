tail -n +1 /local/scratch/rd-hashd/params* | grep -v '\/\/'

i=0
while [ $i -le $1 ]; do
  sudo systemctl stop func-$i.service
  i=$(( i + 1 ))
done

rm -rf /local/scratch/rd-hashd/logs*
rm /local/scratch/rd-hashd/report-*.json
rm /local/scratch/rd-hashd/report-sm-*.json

i=0
while [ $i -le $1 ]; do
  sudo systemctl start func-$i.service
  i=$(( i + 1 ))
done

sleep 10

i=0
while [ $i -le $1 ]; do
  sudo systemctl status func-$i.service
  i=$(( i + 1 ))
done

