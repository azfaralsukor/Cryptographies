#!/bin/bash
echo "Welcome to Rail Fence Cipher"
echo -n "Please input string to be decrypted : "
read string
echo -n "Please input no of rows : "
read row_no

size=${#string}

let wavelength=$(($row_no-1))*2
let cycle=$size/$wavelength
let bal=$size-$wavelength*$cycle

# echo "wavelength : "$wavelength
# echo "cycle : "$cycle
# echo "bal : "$bal

for(( i = 0; i < $row_no; i++ )); do
	if [ $i -eq 0 ] || [ $i -eq $(($row_no-1)) ]; then
		length[$i]=$cycle
	else
		let length[$i]=2*$cycle
	fi

	if [ $bal -gt $i ]; then
		let length[$i]=${length[$i]}+1
	fi
	if [ $bal -gt $(($wavelength-$i)) ] && [ $i -ne $(($row_no-1)) ]; then
		let length[$i]=${length[$i]}+1
	fi
done

# for(( i = 0; i < $row_no; i++ )); do
# 	echo ${length[$i]}
# done

taken=0
for (( i = 0; i < $row_no; i++ )); do
	row[$i]=${row[$i]}${string:($taken):length[i]}
	let taken=$taken+${length[$i]}
done

# for(( i = 0; i < $row_no; i++ )); do
# 	echo ${row[$i]}
# done

cursor=0
direction=1
let b4=$row_no-1
for (( i = 0; i < size; i++ ))
do
    ptext=$ptext${row[cursor]:0:1}
    row[cursor]=${row[cursor]:1:${length[cursor]}}
    
    if [ $cursor -eq 0 ]; then
    	direction=1
    elif [ $cursor -eq $b4 ]; then
        direction=-1
    fi
    let cursor=$cursor+$direction
done

echo "Plaintext : "$ptext