#!/bin/bash
echo -n "Enter a letter: "
read input
input=`echo $input | tr '[:lower:]' '[:upper:]'`
letter=`echo ${input}|od -t d1|awk '{printf "%s",$2}';`
echo $(($letter-65))
