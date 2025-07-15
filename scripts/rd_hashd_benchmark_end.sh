i=0
while [ $i -le $1 ]; do
  sudo systemctl stop func-$i.service
  i=$(( i + 1 ))
done

i=0
while [ $i -le $1 ]; do
  sudo systemctl status func-$i.service
  i=$(( i + 1 ))
done

echo "number of requests is"
cat ./rd-hashd/results/logs-*/*  | grep -a -oE '[0-9]+\.[0-9]+ms'   | wc -l

ls ./rd-hashd/results/logs-*
