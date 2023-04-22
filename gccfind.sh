#!/bin/bash
#Ariel Ashkenazy 208465096

# input check- should be more than 2 arguments
if [[ $# -lt 2 ]]
then
    echo "Not enough parameters"
    exit 1
fi

# EXAMPLE: ./projects/OS/gccfind.sh ./0 main -r
#   scriptPath="./projects/OS/gccfind.sh"
#   relativeDirPath="./0"
#   word="main"
#   recursionFlag="-r"
#   dirPath="./projects/OS/./0" (script+relative)
scriptPath=$0
# extracts the local path of the script
# remove occurences of \/[^/]*$  (removes all char until first "/" included, starting from the end of the word)
scriptDir="$(echo $0 | sed 's/\/[^/]*$//')"
relativeDirPath=$1
dirPath="$scriptDir/$relativeDirPath"
word=$2
recursionFlag=$3

pushd $dirPath > /dev/null
    rm -f *.out

    # removes ".c" endings of all c files
    for filename in $(ls | grep "\.c$" | sed 's/\.[^.]*$//')
    do
        # if file contains the exact input word (has 1 or more lines with that word) then compile it
        linesWithWord=$(cat "$filename.c" | grep -i "\b$word\b" | wc -l)
        if [[ $linesWithWord -gt 0 ]]
        then
            gcc -w "$filename.c" -o "$filename.out"
        fi
    done
popd > /dev/null

# handles recursion
if [[ "$recursionFlag" = "-r" ]]
then
    # filters only dircetories and extracts the dir name (9th column)
    for dir in $(ls -l $dirPath | grep "^d" | awk '{print $9}')
    do
        currPath="$relativeDirPath/$dir"
        # calls the script again but with the new path of the sub dir
        $0 $currPath $word $recursionFlag
    done
fi
