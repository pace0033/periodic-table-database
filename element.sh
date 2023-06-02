#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t -c"

if [[ $1 ]]
then
  # main logic here
  # determine if argument is atomic number, symbol, or name
  # if argument is a number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    CONDITION="atomic_number = $1"
  else
    # if argument is less than 2 chars
    CHAR_COUNT=$(echo -n $1 | wc -m)
    if [[ $CHAR_COUNT > 2 ]]
    then
      CONDITION="name = '$1'"
    else
      CONDITION="symbol = '$1'"
    fi
  fi
  ELEMENT_INFO=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE $CONDITION")
  # if no element was found for the parameter
  if [[ -z $ELEMENT_INFO ]]
  then
    echo "I could not find that element in the database."
  else
    # the database found the element
    echo "$ELEMENT_INFO" | while read TYPE_ID BAR ATOMIC_NUMBER BAR SYMBOL BAR ELEMENT_NAME BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT BAR TYPE
  do
    echo "The element with atomic number $ATOMIC_NUMBER is $ELEMENT_NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $ELEMENT_NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  done
  fi
else
  # no argument was passed into the script
  echo "Please provide an element as an argument."
fi
