#!/bin/bash

decizie=1
while [ "$decizie" -eq 1 ]
do

echo -e -n "Va rugam sa va autentificati.\nIntroduceti numele de utilizator: "
read nume_introdus

#declaram delimitatorul ca fiind: ,  apoi citim datele din fisier si vedem daca exista un nume de utilizator identic cu cel citit de la tastatura
IFS=','
gasit=0
while read -r nume varsta email parola id last_login
do
        if [ "$nume_introdus" = "$nume" ]; then
                gasit=1
                break
        fi
done < <(tail -n +2 registru1.csv)

decizie=-1
while [[ ("$decizie" -gt 2 || "$decizie" -eq -1) && "$gasit" -eq 0 ]]
do
        if [ "$decizie" -eq -1 ]; then
                        echo -e "\n\e[31mNumele de uitlizator introdus nu este corect.\n\e[0m"
                        sleep 1
        fi
        echo -e "Daca vrei sa mai incerci o data, apasa tasta 1.\nDaca doresti sa-ti creezi un cont, apasa tasta 2.\nDaca vrei sa inchei procesul de autentificare, apasa tasta 0.\n"
        read decizie
        echo -e -n "\n"
        if [ "$decizie" -eq 1 ]; then
                echo -e "\e[32mSe reincearca autentificarea.\n\e[0m"
        elif [ "$decizie" -eq 2 ]; then
                echo -e "\n\e[32mSe incepe procesul de inregistrare.\e[0m"
                source inregistrare.sh
        elif [ "$decizie" -eq 0 ]; then
                echo "Te-ai intors pe pagina principala"
                return 0
        else
                echo -e "\e[38;5;208mNumarul introdus nu se regaseste in optiunile noastre.\e[0m"
        fi
done
done

autentificat=0
if [ "$gasit" -eq 1 ]; then
        while [ "$autentificat" -eq 0 ]
        do
                echo -e "\nVa rugam sa introduceti parola.\e[38;5;208m Daca nu mai doriti sa continuati cu procesul de autentificare, apasati tasta 0.\e[0m"
                echo -e -n "\nParola: "
                read -s parola_introdusa
                if [ "$parola_introdusa" = "0" ]; then
                        echo -e "\nTe-ai intors pe pagina principala"
                        return 0
                elif [ "$parola_introdusa" = "$parola" ]; then
                        autentificat=1
                else
                        echo -e -n "\n\n\e[31mParola introdusă nu este corectă.\e[0m"
                        #scris cu rosu
                        echo -n " Sfat: Incearca una dintre celelalte parole pe care le folosesti deobicei."
                fi
        done
fi
if [ "$autentificat" -eq 1 ]; then
        echo -e "\n\e[32mAutentificare reusita.\e[0m"
        data_curenta=$(date '+%Y-%m-%d %H:%M:%S')
        sed -i "/^$nume,/s|[^,]*$|$data_curenta|" registru1.csv
        cd "home/$nume"
        echo -e "\nAcesta este directorul tau home."
        numar_fisiere=$(find . -type f | wc -l)
        if [ "$numar_fisiere" -eq 0 ]; then
                echo -e "\nDirectorul tau home este gol."
        elif [ "$numar_fisiere" -eq 1 ]; then
                echo -e "\nFisierul din director este:"
                find . -type f | sed 's|^\./||'
        else
                echo -e "\nFișierele din director sunt:"
                find . -type f | sed 's|^\./||'
        fi
fi

