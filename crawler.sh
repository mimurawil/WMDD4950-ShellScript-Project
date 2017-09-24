#!/bin/bash
MAX_SITES=15

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
        if [ $i == $j ];
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
  echo "Getting all words from file $THIS_FILE"
  # for word in `cat sites/"$THIS_FILE".html`; do echo $word; done > "temp/$THIS_FILE.txt"
  for w in `lynx -dump sites/"$THIS_FILE".html`; do echo ${w,,}; done > "temp/$THIS_FILE.txt"
  
  echo "Removing final characters , . : ;  Sorting the file and counting words..."
  sed -i "s/,$//g; s/\.$//g; s/:$//g; s/\;$//g" "temp/$THIS_FILE.txt"
  sort "temp/$THIS_FILE.txt" -o "temp/$THIS_FILE.sorted.txt"
  lw=""
  count=0
  first="y"
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
  sed -i "\$a$lw => $count" "temp/$THIS_FILE.counted.txt"
  
  MAIN_IND=$((MAIN_IND + 1))
done
echo "done"
