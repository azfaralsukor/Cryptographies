#!/bin/bash
echo "Welcome to Rail Fence Cipher"
echo -n "Please input string to be encrypted : "
read string
echo -n "Please input no of rows : "
read row_no

size=${#string}

cursor=0
direction=1
let b4=$row_no-1
for ((i=0 ; i<size ;i++))
do
    row[cursor]=${row[cursor]}${string:(i):1}
    
    if [ $cursor -eq 0 ] ; then
    	direction=1
    elif [ $cursor -eq $b4 ] ; then
        direction=-1
    fi
    let cursor=$cursor+$direction
done

for ((i=0 ; i<row_no ;i++))
do
    enc=$enc${row[i]}
done

echo $enc
