for branch in `git branch -r`
do
	length=${#branch}
	if [ $length -gt 7 ]
	then
		br=${branch:7:$length}
		if [ $br != "HEAD" ]
		then
			echo $br
			git checkout $br
		fi
	fi
done