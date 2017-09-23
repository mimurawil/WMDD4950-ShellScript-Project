#! /bin/bash

arrayvar=('a' 'b' 'c' 'd')
echo 'value of arrayvar[1]' ${arrayvar[1]}
echo ''
echo 'displaying all elements in arrayVar - it has '${#arrayvar[@]}' elements'
for element in ${arrayvar[@]}
do
	echo $element
done

arrayvar+=(' e')
for element in ${arrayvar[@]}
do
	echo $element
done

allFiles=`ls`
echo ''
for element in ${allFiles[@]}
do
	echo $element
done

