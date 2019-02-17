#!/bin/bash
#Hackathon 2019
#GCC you don't know me
#Sam, John. Josh, and Scarlette

User="$(whoami)"
array=()
smallsubnet=("0" "10.0.0.65" "10.0.0.66" "10.0.0.67" "10.0.0.68" "10.0.0.69" "10.0.0.70" "10.0.0.71" "10.0.0.72" "10.0.0.73" "10.0.0.74" "10.0.0.75" "10.0.0.76" "10.0.0.77" "10.0.0.78")
result1=()
result=()
badip=()

SCANmore(){
	cd /$User/
	while read -r line; do
		ip="$line"
		badip=( "${badip[@]}" "$ip")
	done < badipset.txt

	nmap -sP -oG /$User/temp.txt 192.168.1.0/24 
	IPaddress=$(cat temp.txt | awk '{print $2}')
	echo $IPaddress >> /$User/temp2.txt
	while read -r line; do
			IP="$line" 
			IP2=$( echo "$IP" | cut -d ' ' -f2 )
			if [ "$IP2" != "Nmap" ]; then
				array=( "${array[@]}" "$IP2")

			fi
	done < temp.txt
	test2="${smallsubnet[*]}"
	for item in ${array[*]}; do
		if [[ ! $test2 =~ "$array" ]]; then
			result1=("${result1[@]}" "$item")
		fi
	done

	#test="${array[*]}"
	test="${result1[*]}"
	for item in ${badip[*]}; do
		if [[ $test =~ "$item" ]]; then
			result=("${result[@]}" "$item")
		fi
	done

	if [[ "${#result[@]}" -gt 0 ]]; then
		zenity --info --title "Intrusion Alert!" --text "Malicious IP: ${result[@]}"

	fi
	rm /$User/temp.txt
	rm /$User/temp2.txt

}

if [ "$User" == "root" ]; then
	SCANmore

elif [ "$User" != "root" ]; then
	echo You are not root, and therefore do not have permissions to run this script.
	exit 1
fi




