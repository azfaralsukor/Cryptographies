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

if [ $choice = t ]; then
	echo -n "Please enter message: "
	read message
elif [ $choice = s ]; then
	echo -n "Please enter filename: "
	read filename
	message=`cat $filename`
fi

echo
echo -n "Do you want to encrypt or decrypt? (e/d) "
read choice

if [ $choice = e ]; then
	echo -n "Your encrypted message is -> "
	echo $message | tr '[:upper:]' '[:lower:]' | tr $P $C
elif [ $choice = d ]; then
	echo -n "Your decrypted message is -> "
	echo $message | tr '[:upper:]' '[:lower:]' | tr $C $P
else
	echo "Invalid input. Goodbye!"
fi

echo
echo "Thank you for using our tool!"
echo
