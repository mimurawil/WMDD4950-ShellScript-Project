# WMDD4950-ShellScript-Project
Repository for a web crawler (up to 10k sites) by using BFS algorithm. Made in shell script.

Starting from https://en.wikipedia.org/wiki/Cloud_computing the script will crawl the first 10k non-repetitive wiki pages, using BFS algorithm, and will save the pages on disk, process the files and extract the words inside each file and save them in form of an indexer in which each file has an alphabetically sorted list of words in which each line has the world and the number of times that word has shown up in that file.

After creating the indexer file, there's another script which takes a word as input and outputs the total count of appearance of that word in your files plus the number of times that it appears on each file that has the word.
