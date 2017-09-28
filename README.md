# WMDD4950 - Shell Script Project
Repository for a web crawler (up to 10k sites) by using BFS algorithm. Made in shell script (v4.0+).

Starting from https://en.wikipedia.org/wiki/Cloud_computing the script will crawl the first 10k non-repetitive wiki pages, using BFS algorithm, and will save the pages on disk, process the files and extract the words inside each file and save them in form of an indexer in which each file has an alphabetically sorted list of words in which each line has the world and the number of times that word has shown up in that file.

After creating the indexer file, there's another script which takes a word as input and outputs the total count of appearance of that word in your files plus the number of times that it appears on each file that has the word.

## How to Use
1. Download the two bash files `crawler.sh` and `count.sh`
2. Execute the crawler file `./crawler.sh nnn` _(nnn is the limit of number of sites to crawl, 1000 is a good number)_
3. Wait for the end of execution. It may take some time depending on how many sites you chose.
4. Crawler.sh will ask you if you want to delete temporary files. Choose your answer.
5. Execute the count file `./cound.sh www` _(www is the word you want to search and count)_
6. Count.sh will generate a `result.txt` file, and will ask you if you want to display its contents. Choose your answer.
