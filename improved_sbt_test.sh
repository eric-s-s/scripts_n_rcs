#! /bin/bash
sbt test | tee temp_tst.txt
grep -e '\[31m' temp_tst.txt
rm temp_tst.txt

