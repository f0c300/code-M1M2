#!/bin/sh

dialog --menu "Choix du client:" 10 30 3 1 "modbus" 2 "LED" 3 "temp�rature" 2>t 

#ok is pressed
if [ "$?" = "0" ]
then
          _return=$(cat t)

  if [ "$_return" = "1" ]
        then
          clear
          echo "lecture/�criture de registres"
         ./modbustest       #clientmodbustest
  fi

  if [ "$_return" = "2" ]
        then
          clear
          echo "allumage led"
        ./serverled
  fi

  if [ "$_return" = "3" ]
        then
          clear
          echo "Acquisition de temp�rature"
        ./tempserver
  fi

  else
          echo "Cancel is pressed"
  fi

