#!/bin/bash
translator(){
	input=`echo $1 | tr '[:lower:]' '[:upper:]'`
	letter=$((`echo ${input}|od -t d1|awk '{printf "%s",$2}';`-65))	
	return $letter
}
echo -n "Enter a letter: "
read input
translator $input
letter=$?
echo $letter
