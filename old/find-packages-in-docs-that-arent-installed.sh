#!/bin/sh

# assumes script is running after "find_installed_packages_that_arent_in_docs" and in the same directory 

comm -23 9-delete-blank-lines 2-sorted-and-explicitly-installed > 11-missing-explained-packages

cat 11-missing-explained-packages
