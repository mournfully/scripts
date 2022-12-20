#!/usr/bin/env bash

# dmenu alias to powerthesaurus
input="$@" 
$BROWSER "https://www.powerthesaurus.org/$(echo $input | sed 's/ /+/g')/synonyms"
