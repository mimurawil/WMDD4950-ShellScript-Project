#!/bin/bash

echo "SEARCH PROCEDURE"
echo "Counting occurrences for the word $1"
echo

TOTAL_COUNT=0

for file in statistics/*.txt
do
    FIND_ARRAY=(`grep "^$1 => .*" $file`)
    if [ "${FIND_ARRAY[2]}" != "" ];
    then
        echo "$file : ${FIND_ARRAY[@]}"
    fi
    TOTAL_COUNT=$((TOTAL_COUNT + FIND_ARRAY[2]))
done > "result.txt"
#sed -i "TOTAL = $((TOTAL_COUNT))" "result.txt"
echo "$TOTAL_COUNT occurrences found in all files"
echo
echo "result.txt generated. Would you like to display the detail? (y/n)"
read input
if [ $input == "y" ] || [ $input == "Y" ];
then
    cat result.txt
else
    echo "okay"
fi
echo
