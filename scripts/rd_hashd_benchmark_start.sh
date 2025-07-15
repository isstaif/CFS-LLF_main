tail -n +1 ./rd-hashd/params* | grep -v '\/\/'

i=0
while [ $i -le $1 ]; do
  sudo systemctl stop func-$i.service
  i=$(( i + 1 ))
done

rm -rf ./rd-hashd/results/logs*
rm ./rd-hashd/results/report-*.json

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

