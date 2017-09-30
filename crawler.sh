#!/bin/bash
if [ $1 == "" ] || [ $1 == "0" ];
then
    MAX_SITES=150
else
    MAX_SITES=$1
fi

mkdir -p temp
mkdir -p statistics
mkdir -p sites

echo "WMDD4950 - Security & Cloud & Server Admn"
echo "William Takashi Mimura - id:100284327"
echo
echo "Web crawler from https://en.wikipedia.org/wiki/Cloud_computing"
echo
echo "Max sites to crawl: $MAX_SITES"
echo
START_TIME=$(date +%s)
echo "Process started at $(date)"
echo
echo
echo "Step 1 - BFS Algorithm to crawl the web"
echo "Executing..."


# STEP 1 - BFS ALGORITHMS TO CRAWL THE WEB
MAIN_ARRAY=("/wiki/Cloud_computing")
ARRAY_LEN=${#MAIN_ARRAY[@]}
MAIN_IND=0
while [ $MAIN_IND -lt $ARRAY_LEN ] && [ $MAIN_IND -le $MAX_SITES ]
do
    # getting the name of the wiki page because it's stored as href="/wiki/page" so this command removes the href= and leaves only /wiki/page
    THIS_FILE=$(echo ${MAIN_ARRAY[$MAIN_IND]} | cut -d '"' -f 2)
    # removing the /wiki/
    THIS_FILE=${THIS_FILE:6}

    # download the page in queue
    echo "Downloading page from https://en.wikipedia.org/wiki/${THIS_FILE}"
    curl -s "https://en.wikipedia.org/wiki/${THIS_FILE}" > "sites/${THIS_FILE}.html"

    # verify if reached maximum sites, so we don't need to fetch and add more links
    if [ $ARRAY_LEN -lt $MAX_SITES ];
    then
        echo "Fetching links..."
        # search for href="/wiki/______" and store as array
        TEMP_ARRAY=($(grep -o "\(href=\"\/wiki\/\w*\"\)" "sites/${THIS_FILE}.html"))

        echo "Adding links to the queue..."
        # search in MAIN_ARRAY for each item of TEMP_ARRAY
        ADDED=0
        REPEATED=0
        for i in "${TEMP_ARRAY[@]}"
        do
            FOUND="n"
            for j in "${MAIN_ARRAY[@]}"
            do
                if [ ${i,,} == ${j,,} ];
                then
                    FOUND="y"
                    REPEATED=$((REPEATED + 1))
                    break
                fi
            done

            if [ "$FOUND" == "n" ];
            then
                MAIN_ARRAY+=($i)
                ARRAY_LEN=${#MAIN_ARRAY[@]}
                ADDED=$((ADDED + 1))

                if [ $ARRAY_LEN -ge $MAX_SITES ];
                then
                    echo "Queue limit reached. Downloading the rest of the pages from queue..."
                    break
                fi
            fi
        done
        echo "$ADDED links added | $REPEATED links repeated (discarted)"
    fi

    MAIN_IND=$((MAIN_IND + 1))
done
echo
END_TIME_1=$(date +%s)
echo "Step 1 completed at $(date) - $(($END_TIME_1 - $START_TIME)) seconds"
echo
echo

# STEP 2 - INDEXING WORDS
echo "Step 2 - Indexing words"
echo "Executing..."

ARRAY_LEN=${#MAIN_ARRAY[@]}
MAIN_IND=0
while [ $MAIN_IND -lt $ARRAY_LEN ] && [ $MAIN_IND -le $MAX_SITES ]
do

    # getting the name of the wiki page because it's stored as href="/wiki/page" so this command removes the href= and leaves only /wiki/page
    THIS_FILE=$(echo ${MAIN_ARRAY[$MAIN_IND]} | cut -d '"' -f 2)
    # removing the /wiki/
    THIS_FILE=${THIS_FILE:6}

    # separating each word in a new line
    echo "Treating file $THIS_FILE: getting words, treating and counting..."
    # for word in `cat sites/"$THIS_FILE".html`; do echo $word; done > "temp/$THIS_FILE.txt"
    # for w in `lynx -dump sites/"$THIS_FILE".html`;
    # do
    #     if [ "$w" != "*" ];
    #     then
    #         echo "${w,,}";
    #     fi
    # done > "temp/$THIS_FILE.txt"
    lynx -dump sites/"$THIS_FILE".html > temp/"$THIS_FILE".txt

    # treating the file, some words are ending with ,.:;
    cat "temp/$THIS_FILE.txt" | tr -dc "[:alpha:] \-\/\_\.\n\r" | tr "[:upper:]" "[:lower:]" > "temp/$THIS_FILE.treated.txt"
    #sed -i "s/,$//g; s/\.$//g; s/:$//g; s/\;$//g" "temp/$THIS_FILE.treated.txt"
    sed -i "s/^file\/\/.*//g; s/^https\/\/.*//g; s/^http\/\/.*//g; s/^android-app\/\/.*//g; s/^-//g; s/^-//g; s/^-//g; s/^-//g; s/-$//g; s/,$//g; s/\.$//g; s/\.$//g; s/\.$//g; s/\/$//g; s/\.$//g; s/\.$//g; s/\.$//g; s/:$//g; s/\;$//g; /^$/d" "temp/$THIS_FILE.treated.txt"

    for w in temp/"$THIS_FILE".treated.txt; do echo "$w"; done > temp/"$THIS_FILE".separated.txt

    # sorting the words for better counting algorithm
    #sort "temp/$THIS_FILE.treated.txt" -o "temp/$THIS_FILE.sorted.txt"
    sort "temp/$THIS_FILE.separated.txt" -o "temp/$THIS_FILE.sorted.txt"
    lw=""
    count=0
    first="y"
    # count algorithm, considering words are sorted and treated
    for w in `cat "temp/$THIS_FILE.sorted.txt"`;
    do
        if [ $first == "y" ];
        then
            first="n"
            lw=$w
        fi

        if [ $w == $lw ];
        then
            count=$((count + 1))
        else
            echo "$lw => $count"
            count=1
        fi

        lw=$w
    done > "temp/$THIS_FILE.counted.txt"
    # adding the last word because of the algorithm
    sed -i "\$a$lw => $count" "temp/$THIS_FILE.counted.txt"
    # moving the final file to the right directory "statistics"
    mv "temp/$THIS_FILE.counted.txt" "statistics/$THIS_FILE.txt"

    MAIN_IND=$((MAIN_IND + 1))
done
echo
END_TIME_2=$(date +%s)
echo "Step 2 completed at $(date) - $(($END_TIME_2 - $END_TIME_1)) seconds"
echo
echo "Process finished!!! $(($END_TIME_2 - $START_TIME)) seconds"
echo "Some temporary files were criated in the process, would you like to remove them? (y/n)"
read input
if [ $input == "y" ] || [ $input == "Y" ];
then
    rm -r temp/*
fi
echo "done :)"
