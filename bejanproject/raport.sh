#!/bin/bash

nume_fisier="/home/ionutb/bejanproject/registru1.csv"

# Verificam daca exista fisierul cu utilizatori
if [ ! -f "$nume_fisier" ]; then
    echo "Nu exista fisierul cu utilizatori."
    return 1
fi

(
    # Calculam numarul de fisiere, numarul de directoare si dimensiunea totala a fisierelor
    numar_fisiere=$(find "/home/$nume" -type f | wc -l)
    numar_directoare=$(find "/home/$nume" -type d | wc -l)
    dimensiune_totala=$(du -sh "/home/$nume" | cut -f1) # sh -pțiune care afișează dimensiunile într-un format ușor de citit
#cut: este o comandă Unix/Linux folosită pentru a extrage secțiuni de text din fișiere sau din ieșirea altor comenzi.
#-f1: opțiune care specifică faptul că se extrage doar primul câmp (coloană) din ieșire. 
#În acest caz, primul câmp este dimensiunea totală a directorului.

    # Printam informatiile in fisierul de raport
    raport_fisier="home/ionutb/bejanproject/raport.txt"
    echo "Raport pentru utilizatorul: $nume" > "$raport_fisier"
    echo "Numar de fisiere: $numar_fisiere" >> "$raport_fisier"
    echo "Numar de directoare: $numar_directoare" >> "$raport_fisier"
    echo "Dimensiune totala pe disc: $dimensiune_totala" >> "$raport_fisier"
)&





