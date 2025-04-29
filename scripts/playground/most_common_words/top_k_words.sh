#!/bin/bash

# Given a text file and an integer k, print the k most common words in the file (and the number of their occurrences) in decreasing frequency

# Translate non-letters into newlines -> Convert uppercase to lowercase -> sort words -> Count unique words -> Sort by frequency (reverse numeric order) -> Print top k lines

cat moby_dick.txt | tr -cs A-Za-z '\n' | tr A-Z a-z | sort | uniq -c | sort -rn | sed ${1}q
