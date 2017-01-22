#!/bin/bash
key=`date +%Y-%m-%d-%H-%M-%S`

getReview(){
	tpl=`wget -qO- $1`

	# whole html
	strTpl=`echo $tpl |
	perl -l -0777 -ne 'print $4 if /<div class=(.*?)wporg-ratings(.*?)\s*(.*?)>\s*(.*?)\s*<\/div>/si'`
	
	# count num of stars by the stargazer
	stars=`echo $strTpl | grep -o 'dashicons-star-filled' | wc -l`

	# topic content template
	topicTpl=`echo $tpl |
	perl -l -0777 -ne 'print $6 if /<ul id=(.*?)bbp-topic-(.*?)-lead(.*?) class=(.*?)bbp-lead-topic(.*?)>\s*(.*?)\s*<\/ul>/si'`

	# get review text
	text=`echo $topicTpl |
	perl -l -0777 -ne 'print $3 if /<div class=(.*?)bbp-topic-content(.*?)>\s*(.*?)\s*<\/div>/si'`

	# get reviewer avatar
	avatar=`echo $topicTpl |
	perl -l -0777 -ne 'print $2 if /<img\s*(.*?)\s*src='"'"'(.*?)'"'"'\s*(.*?)\s*>/si'`

	# get reviewer name
	author=`echo $topicTpl |
	perl -l -0777 -ne 'print $3 if /<a\s*(.*?)\s*class="bbp-author-name"\s*(.*?)\s*>\s*(.*?)\s*<\/a>/si'`

	# get reviewer nicename
	nicename=`echo $topicTpl |
	perl -l -0777 -ne 'print $3 if /<p\s*(.*?)\s*class="bbp-user-nicename"\s*(.*?)\s*>\s*(.*?)\s*<\/p>/si' |
	tr '@' ' ' | tr '(' ' ' | tr ')' ' ' | awk '{$1=$1};1'
	`

	# troubleshooting: this response might be malformed for a json output, as long as $text is not properly encoded
	json='{"author": {"name": "'$author'", "avatar": "'$avatar'", "nicename": "'$nicename'"}, "stars": "'$stars'", "text": "'$text'"}'
	
	# print json
	echo $json
}

putData(){
	if [ ! -f "$2_$key.json" ]; then
		echo "[$1]" >> "$2_$key.json"
	else
		contents=`cat $2_$key.json | sed '$ s/.$//' "$2_$key.json"`
		echo "$contents, $1]" > "$2_$key.json"
	fi
}

grabReviewsData(){
	while read rvwlnk; do
		res=`getReview $rvwlnk`

		if ! [ -z "$res" ]; then
			echo "Parsing new review to the reviews JSON file. ($rvwlnk)"
			putData "$res" "$1_reviews"
			echo -e "Napping for another 2 seconds.\n"
			sleep 2
		fi

	done <"$1_links_$key.txt"
}

getReviewLinks(){
	links=`
	wget -qO- "https://wordpress.org/support/plugin/$1/reviews/page/$2/" |
	perl -l -0777 -ne 'print $1 if /<li class="bbp-body">\s*(.*?)\s*<li class="bbp-footer">/si' |
	grep -o '<a .*href=.*>' |
	sed -e 's/<a /\n<a /g' |
	sed -e 's/<a .*href=['"'"'"]//' -e 's/["'"'"'].*$//' -e '/^$/ d' |
	sed -e "/\b\(wordpress.org\/support\/users\/\)\b/d" |
	cut -d'#' -f1 |
	awk '!seen[$0]++'
	`
	count=`echo $links | tr ' ' $'\n' | sed '/^\s*$/d' | wc -l`

	if [ "$count" -lt "1" ]; then
		echo -e "stopping at page $2.\n"
		echo -e "Reviews links fetched, now let's grab their data.\n"
		grabReviewsData $1
		break
	fi

	echo $links | tr ' ' $'\n' >> "$1_links_$key.txt"
	echo "Page $2 links appended to the links file. Taking a nap.. (chill, just 2 seconds man!)"
	sleep 2
}

getLinks(){
	for i in {1..9999..1}
		do
		getReviewLinks $1 $i
	done
}

if ! [ -z "$1" ]; then
	plugin="$1"
else
	echo -e "Hello, can you give me the plugin slug please?\n"
	read plugin
fi

if [ -z "$plugin" ]; then
	echo "Uhm, forget it!"
	exit
else
	echo -e "\n"
	echo "Alright, $plugin it is!"
	echo -e "\n"

	getLinks "$plugin"
	echo ""
	echo "Coolest! And we're done. [see ""$plugin""_reviews_""$key.json]"
	echo $key > "$plugin.last"
fi