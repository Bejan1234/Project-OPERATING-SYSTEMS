#!/bin/bash

nume_fisier="registru1.csv"

# Verificam daca exista fisierul cu utilizatori
if [ ! -f "$nume_fisier" ]; then
    echo "Nu exista fisierul cu utilizatori."
    return 1
fi

(
    # Calculam numarul de fisiere, numarul de directoare si dimensiunea totala a fisierelor
    numar_fisiere=$(find "home/$nume" -type f | wc -l)
    numar_directoare=$(find "home/$nume" -type d | wc -l)
    dimensiune_totala=$(du -sh "home/$nume" | cut -f1)

    # Printam informatiile in fisierul de raport
    raport_fisier="home/$nume/raport.txt"
    echo "Raport pentru utilizatorul: $nume" > "$raport_fisier"
    echo "Numar de fisiere: $numar_fisiere" >> "$raport_fisier"
    echo "Numar de directoare: $numar_directoare" >> "$raport_fisier"
    echo "Dimensiune totala pe disc: $dimensiune_totala" >> "$raport_fisier"
)&
