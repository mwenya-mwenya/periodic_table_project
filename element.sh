PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c " #PSQL DB connection
if [[ -z $1 ]];then #checks if arguemnt is present
echo "Please provide an element as an argument."
else
if [[ $1 =~ ^[0-9]+$ ]];then  #checks if argument is an integer
ELEMENT_QUERY_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = '$1'") #if argument is a integer, returns atomic number
else
ELEMENT_QUERY_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1' OR name = '$1'") #if argument is either element symbol or element name, return atomic number
fi
if [[ -z $ELEMENT_QUERY_NUMBER ]];then #checks if element db query returns null,  
echo "I could not find that element in the database."
else
ELEMENT_QUERY(){
ATOMIC_NUMBER_QUERY=$($PSQL "SELECT * FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE atomic_number = $ELEMENT_QUERY_NUMBER ") #joins tables to get correct fields
echo "$ATOMIC_NUMBER_QUERY" | while IFS="|" read TYPE_ID ATOMIC_NUMBER ATOMIC_SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE; #assigns variables to fields
do
echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($ATOMIC_SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
done
}
ELEMENT_QUERY
fi
fi