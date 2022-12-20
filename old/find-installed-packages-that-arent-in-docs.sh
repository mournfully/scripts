#!/bin/sh

# i was trying to make this as readable and easy to debug as possible, but I may have just made a mess instead >.<

# list out explicitly isntalled package names and not version
xpkg -m > 1-unsorted-and-explicitly-installed

# sort alphabetically
sort 1-unsorted-and-explicitly-installed > 2-sorted-and-explicitly-installed

# ================================================================================================

# symlink working file to project directory
path_dir=$(pwd)
sudo ln -snf '/data/precursor/wiki/!inbox/void linux + dwm/!main/installed packages.md' '/data/projects/shell.compare-package-lists/3-unprocessed-explained-files'

# start processing but make sure not to touch 3*
cat 3-unprocessed-explained-files | grep -v '# installed packages\|```shell\|sudo xbps-install -S\|```' > 4-removed-some-bits

# https://stackoverflow.com/questions/2609552/how-can-i-use-as-an-awk-field-separator
# remove everything after "#" to end of line
cat 4-removed-some-bits | awk -F '#' '{print $1}' > 5-remove-everything-after-hashtag

# https://stackoverflow.com/questions/36291088/using-awk-to-place-each-word-in-a-text-file-on-a-new-line
# place each word on a new line
cat 5-remove-everything-after-hashtag | awk -v OFS="\n" '{$1=$1}1' > 6-each-word-on-newline

# https://geek-university.com/sort-lines-of-a-text-file/
# sort alphabetically
cat 6-each-word-on-newline | sort > 7-sort-alphabetically

# https://unix.stackexchange.com/questions/102008/how-do-i-trim-leading-and-trailing-whitespace-from-each-line-of-some-output
# trim leading and trailing whitespace for each line
cat 7-sort-alphabetically | awk '{$1=$1};1' > 8-remove-whitespace

# https://serverfault.com/questions/252921/how-to-remove-empty-blank-lines-from-a-file-in-unix-including-spaces
# delete blank lines
cat 8-remove-whitespace | sed '/^$/d' > 9-delete-blank-lines

# https://stackoverflow.com/questions/4544709/compare-two-files-line-by-line-and-generate-the-difference-in-another-file
# compare file-2* with file-9* and output file-10* which contains lines in file-2* not present in file-9*
comm -23 2-sorted-and-explicitly-installed 9-delete-blank-lines > 10-compare-for-missing-lines

# output to stdout
cat 10-compare-for-missing-lines
