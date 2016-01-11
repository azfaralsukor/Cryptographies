#!/bin/bash

# DECLARING PLAINTEXT LETTERS
P="ABCDEFGHIJKLMNOPQRSTUVWXYZ ~!@#$%^&*()_+=[]\{}|;':,./<>?\"-abcdefghijklmnopqrstuvwxyz"

clear
# WELCOME MESSAGE
echo "Welcome to Key Cipher Encryting Tool"
echo

# REQUEST FOR KEY
echo -n "Please enter the key: "
IFS=''
read key
echo

# DELETING REDUNDANT LETTER FOR KEY
act_key=$key
for ((i=0;i<${#act_key};++i)); do
    c=${act_key:i:1}
    tailact_key=${act_key:i+1}
    act_key=${act_key::i+1}${tailact_key//"$c"/}
done
# DELETING REDUNDANT LETTER FOR KEY END

# DECLARING INITIAL CIPHERTEXT WITH REDUNDANT LETTERS
Ptext="${act_key}ABCDEFGHIJKLMNOPQRSTUVWXYZ ~!@#$%^&*()_+=[]\{}|;':,./<>?\"-abcdefghijklmnopqrstuvwxyz" 

# DELETING REDUNDANT LETTER FOR CIPHERTEXT
C=$Ptext
for ((i=0;i<${#C};++i)); do
    c=${C:i:1}
    tailC=${C:i+1}
    C=${C::i+1}${tailC//"$c"/}
done
# DELETING REDUNDANT LETTER FOR CIPHERTEXT END

# REQUEST FOR FILENAME
echo "Please enter your filename. (format: \"/home/<username>/...\") "
echo -n "-> "
IFS=''
read filename

# FILENAME ERROR HANDLER
while [ ! -f "$filename" ]; do
	echo "File not found, please re-enter filename. (format: \"/home/<username>/...\") "
	echo -n "-> "
	read filename
done 
# FILENAME ERROR HANDLER END

# STORE FILE CONTENT INTO VARIABLE "message"
message=`cat $filename`

# TRANSLATE USING tr
echo -n "Your encrypted message is -> "
echo $message | tr $P $C

# GOODBYE MESSAGE
echo
echo "Thank you for using our tool!"
echo
