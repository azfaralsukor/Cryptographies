#!/bin/bash
clear
# WELCOME MESSAGE
echo "Welcome to Rail Fence Cipher Encryting/Decrypting Tool"
echo

##### ASKING INPUT FOR MESSAGE ###########
echo -n "Do you want to type the message or select a file? (t for type/s for select) "
read choice
choice=`echo $choice | tr '[:upper:]' '[:lower:]'`

while [[ "$choice" != "t" && "$choice" != "s" ]]; do
	echo -n "Wrong input, please re-enter. (t for type/s for select) "
	read choice
	choice=`echo $choice | tr '[:upper:]' '[:lower:]'`
done

if [ $choice = t ]; then
	echo -n "Please type your message: "
	IFS=''
	read message
elif [ $choice = s ]; then
	echo "Please enter your filename. (format: \"/home/<username>/...\") "
	echo -n "-> "
	IFS=''
	read filename
	while [ ! -f "$filename" ]; do
		echo "File not found, please re-enter filename. (format: \"/home/<username>/...\") "
		echo -n "-> "
		read filename
	done 
	message=`cat $filename`
fi
##### ASKING INPUT FOR MESSAGE END ###########

# REQUEST NUMBER OF ROWS
echo -n "Please input no of rows             : "
read row_no
output=""

##### ASKING FOR ENCRYPT OR DECRYPT ###########
echo
echo -n "Do you want to encrypt or decrypt? (e/d) "
read choice
choice=`echo $choice | tr '[:upper:]' '[:lower:]'`

while [[ "$choice" != "e" && "$choice" != "d" ]]; do
	echo -n "Wrong input, please re-enter. (e for encrypt/d for decrypt) "
	read choice
	choice=`echo $choice | tr '[:upper:]' '[:lower:]'`
done
##### ASKING FOR ENCRYPT OR DECRYPT END ###########

##### ENCRYPTION ###########
if [ $choice = e ]; then
	#DECLARING "index" FOR ROW'S INDEX NUMBER	
	index=0

	# DECLARING "direction" FOR LOOPING DIRECTION
	direction=1

	# INSERTING LETTERS TO THE ROWS ACCORDINGLY
	for (( i = 0; i < ${#message}; i++ )); do
	    row[index]=${row[index]}${message:(i):1}
	    
	    if [ $index -eq 0 ]; then
	    	direction=1
	    elif [ $index -eq  $(($row_no-1)) ]; then
	        direction=-1
	    fi

	    let index=$index+$direction
	done
	# INSERTING END
	# CREATING A STRING WITH ALL ROWS COMBINED
	for (( i = 0; i < row_no; i++ )); do
	    output=$output${row[i]}
	done

	# DISPLAY ENCRYPTED MESSAGE
	echo "Your encrypted message is ----------> "$output
##### ENCRYPTION END ###########
##### DECRYPTION ###########
elif [ $choice = d ]; then
	size=${#message} #size of message

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
		row[$i]=${row[$i]}${message:($taken):length[i]}
		let taken=$taken+${length[$i]}
	done

	cursor=0
	direction=1
	for (( i = 0; i < size; i++ ))
	do
	    output=$output${row[cursor]:0:1}
	    row[cursor]=${row[cursor]:1:${length[cursor]}}
	    
	    if [ $cursor -eq 0 ]; then
	    	direction=1
	    elif [ $cursor -eq $(($row_no-1)) ]; then
	        direction=-1
	    fi
	    let cursor=$cursor+$direction
	done

	echo "Your decrypted message is ----------> "$output
fi
##### DECRYPTION END ###########


##### ASKING FOR SAVING TO A FILE FILE ###########
echo -n "Do you want to save into a file? (y/n) "
read choice
choice=`echo $choice | tr '[:upper:]' '[:lower:]'`

while [[ "$choice" != "y" && "$choice" != "n" ]]; do
	echo -n "Wrong input, please re-enter. (y for yes/n for not) "
	read choice
	choice=`echo $choice | tr '[:upper:]' '[:lower:]'`
done
##### ASKING FOR SAVING TO A FILE END ###########

##### SAVING TO A FILE ###########
if [ $choice = y ]; then
	echo -n "Do you want to save into an existing file or create new file? (e for existing/n for new) "
	read choice
	choice=`echo $choice | tr '[:upper:]' '[:lower:]'`

	while [[ "$choice" != "e" && "$choice" != "n" ]]; do
		echo -n "Wrong input, please re-enter. (e for existing/n for new) "
		read choice
		choice=`echo $choice | tr '[:upper:]' '[:lower:]'`
	done

	if [ $choice = e ]; then
		echo "Please enter your exiting filename. (format: \"/home/<username>/...\") "
		echo -n "-> "
		IFS=''
		read filename
		while [ ! -f "$filename" ]; do
			echo "File not found, please re-enter filename. (format: \"/home/<username>/...\") "
			echo -n "-> "
			read filename
		done

		echo -n "Do you want to overwrite or append this file? (o/a) "

		read choice
		choice=`echo $choice | tr '[:upper:]' '[:lower:]'`

		while [[ "$choice" != "o" && "$choice" != "a" ]]; do
			echo -n "Wrong input, please re-enter. (o for overwrite/a for append) "
			read choice
			choice=`echo $choice | tr '[:upper:]' '[:lower:]'`
		done

		if [ $choice = o ]; then
			echo $output > $filename
		elif [ $choice = a ]; then
			echo $output >> $filename
		fi

	elif [ $choice = n ]; then
		echo "Please enter your new filename. (format: \"/home/<username>/...\") "
		echo -n "-> "
		IFS=''
		read filename
		echo $output > $filename
	fi
fi
##### SAVING TO A FILE END ###########


# GOODBYE MESSAGE
echo
echo "Thank you for using our tool!"
echo