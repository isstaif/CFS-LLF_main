tail -n +1 ./params* | grep -v '\/\/'

i=0
while [ $i -le $1 ]; do
  sudo systemctl stop func-$i.service
  i=$(( i + 1 ))
done

rm -rf ./results/logs*
rm ./results/report-*.json

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

