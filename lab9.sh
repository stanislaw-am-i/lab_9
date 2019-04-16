#!/bin/bash
echo -e "Check permissions an user has on a file\n"
cond=""
currentDir=$(pwd)
echo -e "The current directory is '$currentDir'\n"
while true; do
read -p "Enter a filename: " FILENAME
   if [ -f $FILENAME ]; then
      echo -e "The file '$FILENAME' exists\n"
   else
      echo -e "The file '$FILENAME' does not exist\n"
      continue
   fi   
read -p "Enter an username: " USERNAME
   if grep $USERNAME /etc/passwd > /dev/null; then
      OWNER=$(stat -c %U $FILENAME)
      GROUP=$(stat -c %G $FILENAME)
      USERGROUP=$(groups $USERNAME)
      echo -e "\nThe user rights are: "
      if [ $USERNAME == $OWNER ]; then
         stat -c %A $FILENAME | cut -c 2-4
      elif grep -w $GROUP <<< $USERGROUP > /dev/null; then
         stat -c %A $FILENAME | cut -c 5-7
      else
         stat -c %A $FILENAME | cut -c 8-10
      fi   
   else
      echo -e "Error: The user '$USERNAME' does not exist\n" >&2
   fi
echo   
read -p "Continue? (y/n): " cond
   if [ $cond == "n" ]; then
      echo -e "Operation is over"
      exit
   else
      echo 
   fi
done