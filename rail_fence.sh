#!/bin/bash
clear
# WELCOME MESSAGE
echo "Welcome to Rail Fence Cipher Encryting/Decrypting Tool"
echo

echo -n "Do you want to encrypt or decrypt? (e/d) "
read choice
choice=`echo $choice | tr '[:upper:]' '[:lower:]'`

while [[ "$choice" != "e" && "$choice" != "d" ]]; do
	echo -n "Wrong input, please re-enter. (e for encrypt/d for decrypt) "
	read choice
	choice=`echo $choice | tr '[:upper:]' '[:lower:]'`
done

if [ $choice = e ]; then
	# REQUEST STRING
	echo -n "Please input string to be encrypted : "
	read string

	# DELETE SPACES AND SPECIAL CHARACTERS
	string=`echo $string | tr -d [:space:] | tr -d [:punct:]`

	# REQUEST NUMBER OF ROWS
	echo -n "Please input no of rows             : "
	read row_no

	#DECLARING "index" FOR ROW'S INDEX NUMBER	
	index=0

	# DECLARING "direction" FOR LOOPING DIRECTION
	direction=1

	# INSERTING LETTERS TO THE ROWS ACCORDINGLY
	for (( i = 0; i < ${#string}; i++ )); do
	    row[index]=${row[index]}${string:(i):1}
	    
	    if [ $index -eq 0 ]; then
	    	direction=1
	    elif [ $index -eq  $(($row_no-1)) ]; then
	        direction=-1
	    fi

	    let index=$index+$direction
	done
	# INSERTING END

	# DISPLAY ENCRYPTED MESSAGE
	echo -n "Your encrypted message is ----------> "
	for (( i = 0; i < row_no; i++ )); do
	    echo -n ${row[i]}
	done
elif [ $choice = d ]; then
	echo -n "Please input string to be decrypted : "
	read string
	echo -n "Please input no of rows             : "
	read row_no

	size=${#string}

	let wavelength=$(($row_no-1))*2
	let cycle=$size/$wavelength
	let bal=$size-$wavelength*$cycle

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

	taken=0
	for (( i = 0; i < $row_no; i++ )); do
		row[$i]=${row[$i]}${string:($taken):length[i]}
		let taken=$taken+${length[$i]}
	done

	cursor=0
	direction=1
	for (( i = 0; i < size; i++ ))
	do
	    ptext=$ptext${row[cursor]:0:1}
	    row[cursor]=${row[cursor]:1:${length[cursor]}}
	    
	    if [ $cursor -eq 0 ]; then
	    	direction=1
	    elif [ $cursor -eq $(($row_no-1)) ]; then
	        direction=-1
	    fi
	    let cursor=$cursor+$direction
	done

	echo -n "Your decrypted message is ----------> "$ptext
fi

# GOODBYE MESSAGE
echo
echo "Thank you for using our tool!"
echo
