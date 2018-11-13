#!/bin/sh

tag='zzjhacn/plantuml'
versions=($(docker images | grep $tag | awk '{print $2}'))
max=0.0

for v in ${versions[*]}
do
  c=$(echo " $v > $max "|bc -l)
  if [ "$c" == "1" ]
  then
    max=$v
  fi
done

next=$(echo "scale=1; $max + 0.1 "|bc -l)

docker build . --tag $tag:$next
