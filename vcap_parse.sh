#!/bin/bash

services="";

# regex for determining if var is numeric
isNumber="^[0-9]+$"

# for loop creates regex (from args) to grep the desired VCAP service
for var in "$@"
do
	if [ "$1" = $var ]
	then
    	services=$var
    else
    	if ! [[ $var =~ $isNumber ]] 
    	then
   			services+=",\\\"$var\\\""
   		else
   			services+="\\\",$var"
		fi
	fi
done

# JSON.sh parses json ->  grep specfic VCAP -> sed removes JSON.sh header -> tr remove quotes
echo $VCAP_SERVICES | JSON.sh -l | grep $services | sed "s/^\[.*\].//" | tr -d '"'
