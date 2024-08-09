#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"
# main menu

MAIN_MENU () {
  echo -e "\n~~~~~ Salon ~~~~~\n"
  SERVICE_SELECTION
  APPOINTMENTS_MENU
  EXIT
}
# appointments menu
SERVICE_SELECTION(){
  echo "How may I help you?"
  # display the services

  DISPLAY_SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
  echo "$DISPLAY_SERVICES" | sed 's/ |/ /' | while read SERVICE_ID NAME
  do
    echo -e "$SERVICE_ID) $NAME "
  done
  
  # select service
  echo -e "\nWich service would you like?"
  read SERVICE_ID_SELECTED
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  if [[ -z $SERVICE_NAME ]]
  then
    SERVICE_SELECTION
  fi
}
APPOINTMENTS_MENU() {
  # get customers phone number
  echo -e "\nWhat is your phone number?"
  read CUSTOMER_PHONE
  # get customers name
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  # if name not found
  if [[ -z $CUSTOMER_NAME ]]
  then
    echo -e "What is your name?"
    read CUSTOMER_NAME
    echo -e "Hello $CUSTOMER_NAME"
    echo "No name found"
  else
    echo -e "Hello $CUSTOMER_NAME"
    echo "Name found"
  fi
  # add customer
  ADD_CUSTOMER=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  echo "Your customer id is: $CUSTOMER_ID"
  # get time
  echo -e "\nAt what time would you like your appointment?"
  read SERVICE_TIME
  # add appointment
  ADD_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED,'$SERVICE_TIME')")
  #get service name
  echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}
EXIT() {
  echo -e "\nThank you for stopping in.\n"
}

MAIN_MENU