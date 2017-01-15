#!/bin/bash
# Encrypt C = XK mod 26
# Decrypt K = X'C mod 26
temp=(0 0)
enc=()
dec=()
splitted_string=()
key=()
inverseKey=()
mod=26
debug=false
choice=""
multiply=false

# maps A=0, B=1, C=2... Z=25 
mapChar2Int(){
	# capitalize all letters
	input=`echo $1 | tr '[:lower:]' '[:upper:]'`
	# od -t d1 --- converts letter to 1.octal bytes and 2.ASCII value
	# awk '{printf "%s",$2}'; --- takes the $2(second) parameter only
	# $((`...`))-65 --- converts string to int and maps it accordingly (see line no.5) 
	letter=`echo ${input}|od -t d1|awk '{printf "%s",$2}';`
	if [[ $letter -gt 64 ]]; then
		letter=$(($letter-65))
	else
		letter=$(($letter-22))
	fi
	return $letter
}

normalizeInverseKey(){
	for (( i = 0; i < ${#inverseKey[@]}; i++ )); do
		if [[ ${inverseKey[$i]} -lt 0 ]]; then
			moduloNeg ${inverseKey[$i]}
			inverseKey[$i]=$?
		fi
		if [[ ${inverseKey[$i]} -ge $mod ]]; then
			let inverseKey[$i]=${inverseKey[$i]}%$mod
		fi
	done
}

moduloNeg(){
	number=$1
	while [[ $number -lt 0 ]]; do
		let number=$number+$mod
	done
	return $number
}

specialCase(){
	det=$1
	moduloNeg $det
	det=$?

	i=2
	multplier=$det
	while [[ $(($det%$mod)) -ne 1 ]]; do
		let det=$multplier*$i
		let i=$i+1
	done

	return $(($i-1))
}

multiplyMatrix(){
	key_matrix=("$@")
	string_in_pair[0]=$5
	string_in_pair[1]=$6
	let enc_1=$(((${matrix[0]}*$5+${matrix[1]}*$6)%$mod))
	let enc_2=$(((${matrix[2]}*$5+${matrix[3]}*$6)%$mod))
	temp=($enc_1 $enc_2)
}

print2x2Matrix(){
	matrix=("$@")
	echo "[" ${matrix[0]} ${matrix[1]}  "]"
	echo "[" ${matrix[2]} ${matrix[3]}  "]"
}

hillCipher(){
	process_type=$1
	if [[ $process_type == "e" ]]; then
		matrixKey=("${key[@]}") 
		original=("${splitted_string[@]}") 
	else
		matrixKey=("${inverseKey[@]}") 
		original=("${enc[@]}") 
	fi

	# map character into integer
	for (( i = 0; i < ${#original[@]}; i++ )); do
		mapChar2Int ${original[$i]}
		mapped=$?
		original[$i]=$mapped
	done

	# multiplying matrices
	for (( i = 0; i < ${#original[@]}; i+=2 )); do
		multiplyMatrix ${matrixKey[*]} ${original[$i]} ${original[$(($i+1))]}
		result[$i]=${temp[0]}
		result[$(($i+1))]=${temp[1]}
	done

	# for debugging purposes
	if [[ $debug == true ]]; then
		echo "process_type: " $process_type
		echo "matrixKey: " ${matrixKey[*]}
		echo "original: " ${original[*]}
		echo "After matrices multiplication value -> " ${result[*]}
	fi

	# map integer into character
	for (( i = 0; i < ${#result[@]}; i++ )); do
		if [[ ${result[$i]} -gt 25 ]]; then
			mapped=`printf "\x$(printf %x $((${result[$i]}+22)))"`
		else
			mapped=`printf "\x$(printf %x $((${result[$i]}+65)))"`
		fi
		result[$i]=$mapped
	done

	if [[ $process_type == "e" ]]; then
		enc=("${result[@]}") 
	else
		dec=("${result[@]}") 
	fi
}

if [[ $1 == "-d" ]]; then
	debug=true;
fi

clear
echo "Welcome to Hill Cipher Encryting & Decrypting Tool"
echo
echo "Please enter the key 2 x 2 matrix: [00  10]"
echo "                                   [01  11]"
IFS=''

echo -n "00 = "
read key_00
echo -n "10 = "
read key_10
echo -n "01 = "
read key_01
echo -n "11 = "
read key_11
echo

key=($key_00 $key_10 $key_01 $key_11)
echo "Key Matrix:" 
print2x2Matrix ${key[*]}

# get string
echo -n "Enter string: "
read string

# get mod value
echo -n "Mod 26 or Mod 36? (26/36): "
read mod
while [[ "$mod" != 26 && "$mod" != 36 ]]; do
	echo -n "Wrong! Mod 26 or Mod 36!? (26/36): "
	read mod
done 

# ##### ASKING FOR ENCRYPT OR DECRYPT ###########
# echo
# echo -n "Do you want to encrypt or decrypt? (e/d) "
# read choice
# choice=`echo $choice | tr '[:upper:]' '[:lower:]'`

# while [[ "$choice" != "e" && "$choice" != "d" ]]; do
# 	echo -n "Wrong input, please re-enter. (e for encrypt/d for decrypt) "
# 	read choice
# 	choice=`echo $choice | tr '[:upper:]' '[:lower:]'`
# done
# ##### ASKING FOR ENCRYPT OR DECRYPT END ###########

# split letters into arrays
for ((i=0; i<${#string}; i++)); 
	do splitted_string[$i]="${string:$i:1}"; 
done

# check if string length if it is odd number, if yes add character 'X' at the end of the string 
if [[ $((${#splitted_string[@]} % 2)) == 1 ]]; then
	splitted_string[${#splitted_string[@]}]="X"
fi

hillCipher "e"

echo "Encrypted message                   -> " ${enc[*]}

echo

let determinant=${key[0]}*${key[3]}-${key[1]}*${key[2]}

specialCase $determinant
determinant=$?

inverseKey=(${key[3]} -${key[1]} -${key[2]} ${key[0]})

# for debugging purposes
if [[ $debug == true ]]; then
	echo "Determinant: " $determinant
	echo "Swapped places:" 
	print2x2Matrix ${inverseKey[*]}
fi

normalizeInverseKey

# for debugging purposes
if [[ $debug == true ]]; then
	echo "Nomalized:" 
	print2x2Matrix ${inverseKey[*]}
fi

for (( i = 0; i < ${#inverseKey[@]}; i++ )); do
	let inverseKey[$i]=${inverseKey[$i]}*$determinant
done

# for debugging purposes
if [[ $debug == true ]]; then
	echo "Multiplied with determinant:" 
	print2x2Matrix ${inverseKey[*]}
fi

normalizeInverseKey

echo "Inverse Key Matrix:" 
print2x2Matrix ${inverseKey[*]}

echo

hillCipher "d" 

echo "Decrypted message                   -> " ${dec[*]}

# GOODBYE MESSAGE
echo
echo "Thank you for using our tool!"
echo
