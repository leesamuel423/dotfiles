# Context

* In mid 1980s, Donald Kuth (renown computer scientist) and Doug Mcllroy (one of the creators of Unix and inventor of Unix pipes) were challenged to do the following:
    * Given a text file and an integer k, print the k most common words in the file (and the number of their occurrences) in decreasing frequency
* Kruth approached the challenge with a literate programming approach. Wrote program in WEB (programming system he created) that was about 10-12 pages long. Solution was carefully crafted, efficient, and came with detailed explanations of the algorithm and data structures used.
    - Read entire input -> Use custom-built data structure (modified trie) to count word frequencies -> Priority queue to identify k most frequent words -> Print results
* Mcllroy proposed an laternative solution using Unix pipes
    - Translate non-letters into newlines -> Convert uppercase to lowercase -> sort words -> Count unique words -> Sort by frequency (reverse numeric order) -> Print top k lines
    - Solution is not only shorter, but more flexible, as it can be modified to handle different requirements
