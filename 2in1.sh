#!bin/bash
choice=0
while [[ "$choice" == 1 || "$choice" == 2|| "$choice" == 0 || "$choice" == "q" || "$choice" == "Q" ]]; do
	if [[ "$choice" == "q" || "$choice" == "Q" ]]; then
		echo
		echo
		echo "Thank you for using our tool! Goodbye!"
		echo
		break
	elif [ "$choice" = 0 ]; then
		clear
		echo "Welcome to Key Cipher and Rail Fence Cipher Encrypting/Decrypting Tool"
		echo
		echo "Choose Your Cipher:"
		echo "                    1. Key Cipher"
		echo "                    2. Rail Fence Cipher"
		echo "                    Q. Quit"
		echo -n "  Your Selection ~> "
		read choice

		while [[ "$choice" != 1 && "$choice" != 2 && "$choice" != "q" && "$choice" != "Q" ]]; do
			echo -n "Wrong input, please re-enter. (1 for Key Cipher/2 for Rail Fence Cipher) "
			read choice
		done
	elif [ "$choice" = 1 ]; then
		clear
		P="ABCDEFGHIJKLMNOPQRSTUVWXYZ\' '~!@#$%^&*()_+=[]\{}|;':,./<>?\"-abcdefghijklmnopqrstuvwxyz"
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
		echo -n "Back to main menu or quit? (0/q) "
		read choice
		while [[ "$choice" != 0 && "$choice" != "q" && "$choice" != "Q" ]]; do
			echo -n "Wrong input, please re-enter. (0 for back/q for quit) "
			read choice
		done
	elif [ "$choice" = 2 ]; then
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

		echo
		echo
		echo -n "Back to main menu or quit? (0/q) "
		read choice	
		while [[ "$choice" != 0 && "$choice" != "q" && "$choice" != "Q" ]]; do
			echo -n "Wrong input, please re-enter. (0 for back/q for quit) "
			read choice
		done
	fi				
done