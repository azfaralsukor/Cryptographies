#!/bin/bash
P="ABCDEFGHIJKLMNOPQRSTUVWXYZ\' '~!@#$%^&*()_+=[]\{}|;':,./<>?\"-abcdefghijklmnopqrstuvwxyz"
clear
echo "Welcome to Key Cipher Encryting/Decrypting Tool"
echo
echo -n "Please enter the key: "
IFS=''
read key
echo

##########DELETING REDUNDANT LETTER FOR KEY################
act_key=$key
for ((i=0;i<${#act_key};++i)); do
    c=${act_key:i:1}
    tailact_key=${act_key:i+1}
    act_key=${act_key::i+1}${tailact_key//"$c"/}
done
########DDELETING REDUNDANT LETTER FOR KEY END##############

Ptext="${act_key}ABCDEFGHIJKLMNOPQRSTUVWXYZ\' '~!@#$%^&*()_+=[]\{}|;':,./<>?\"-abcdefghijklmnopqrstuvwxyz" ###KEY + ABC...XYZ

########DELETING REDUNDANT LETTER FOR CIPHERTEXT ############
C=$Ptext
for ((i=0;i<${#C};++i)); do
    c=${C:i:1}
    tailC=${C:i+1}
    C=${C::i+1}${tailC//"$c"/}
done
#####DELETING REDUNDANT LETTER FOR CIPHERTEXT END ###########


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
	echo -n "Your encrypted message is -> "
	echo $message | tr $P $C
	message=`echo $message | tr $P $C`
elif [ $choice = d ]; then
	echo -n "Your decrypted message is -> "
	echo $message | tr $C $P
	message=`echo $message | tr $C $P`
fi

echo -n "Do you want to save into a file? (y/n) "
read choice
choice=`echo $choice | tr '[:upper:]' '[:lower:]'`

while [[ "$choice" != "y" && "$choice" != "n" ]]; do
	echo -n "Wrong input, please re-enter. (y for yes/n for not) "
	read choice
	choice=`echo $choice | tr '[:upper:]' '[:lower:]'`
done

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
			echo > $filename
		fi

	elif [ $choice = n ]; then
		echo "Please enter your new filename. (format: \"/home/<username>/...\") "
		echo -n "-> "
		IFS=''
		read filename
	fi

	echo $message > $filename
fi

echo
echo "Thank you for using our tool!"
echo
