#!/bin/bash
clear
echo "Welcome to Key Cipher Encryting/Decrypting Tool"
echo
echo -n "Please enter the key: "
read key
echo
##########DELETE REDUNDANT LETTER################
act_key=$key
for ((i=0;i<${#act_key};++i)); do
    c=${act_key:i:1}
    tailact_key=${act_key:i+1}
    act_key=${act_key::i+1}${tailact_key//"$c"/}
done
########DELETE REDUNDANT LETTER END##############

Ptext="${act_key}abcdefghijklmnopqrstuvwxyz" ###KEY + ABC...XYZ

########DELETE REDUNDANT LETTER (CIPHERTEXT) ############
C=$Ptext
for ((i=0;i<${#C};++i)); do
    c=${C:i:1}
    tailC=${C:i+1}
    C=${C::i+1}${tailC//"$c"/}
done
#####DELETE REDUNDANT LETTER (CIPHERTEXT) END ###########

P="abcdefghijklmnopqrstuvwxyz"

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
	read message
elif [ $choice = s ]; then
	echo -n "Please enter your filename: "
	IFS=''
	read filename
	while [ ! -f "$filename" ]; do
		echo -n "File not found, please re-enter filename: "
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
	echo $message | tr '[:upper:]' '[:lower:]' | tr $P $C
elif [ $choice = d ]; then
	echo -n "Your decrypted message is -> "
	echo $message | tr '[:upper:]' '[:lower:]' | tr $C $P
fi

echo
echo "Thank you for using our tool!"
echo
