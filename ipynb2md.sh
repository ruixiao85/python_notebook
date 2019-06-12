#!/bin/bash
if [ $# -eq 0 ]
  then
	type="markdown"
    echo "default to $type"
  else
    type=$1
    echo "use first argument $type"
fi
for f in *.ipynb
do
  echo "Processing $f file..."
  jupyter nbconvert --to $type $f
  cat $f
done