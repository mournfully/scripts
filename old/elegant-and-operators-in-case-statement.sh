#!/usr/bin/env bash
# https://unix.stackexchange.com/questions/549165/and-operator-in-case-statement
printf "Enter a word: "; read word

A=0 B=0 C=0

[[ $word ==   [aeiouAEIOU]* ]] && A=1 || A=0
[[ $word ==   *[0-9]        ]] && B=1 || B=0
[[ $word ==   ????          ]] && C=1 || C=0

case $A$B$C in
  111)     echo "Four letters that start with a vowel and end with a digit" ;;
  11*)     echo "The word begins with a vowel AND ends with a digit."       ;;
  1* )     echo "The word begins with a vowel."                             ;;
  *1?)     echo "The word ends with a digit."                               ;;
   *1)     echo "The word is four letters long"                             ;;
    *)     echo "I don't understand what you've entered,"                   ;;
esac
