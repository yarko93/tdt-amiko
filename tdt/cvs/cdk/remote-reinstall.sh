#!/bin/bash
# Usage: ./remote-reinstall <package_name>

ipkdir=../../tufsbox/ipkbox
for x in $ipkdir/$1*; do
  echo indexing $x
  python ipkg-utils-050831/ipkg-update-index $ipkdir $x
done
cat $ipkdir/Packages | gzip > $ipkdir/Packages.gz
./pkg.py $1
