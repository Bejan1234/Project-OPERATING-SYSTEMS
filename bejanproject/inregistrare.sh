#!/bin/bash

utilizatori_CSV="registru1.csv"


verifica_existenta_utilizator() {
    nume_utilizator=$1
    if grep -q "^$nume_utilizator," $utilizatori_CSV; then
        echo -e "\n\e[31mUtilizatorul $nume_utilizator există deja. \e[0m"
        sleep 0.5
        echo "Vă rugăm să introduceți alt nume de utilizator."
        sleep 0.5
        return 1
    else
        return 0
    fi
}

verifica_existenta_email() {
    email=$1
    if grep -q ",$email," $utilizatori_CSV; then
        echo -e -n "\n\e[31mAdresa de email $email a fost folosita. \e[0m"
        sleep 0.5
        echo "Vă rugăm să introduceți o altă adresă de email."
        sleep 0.5
        return 1
    else
        return 0
    fi
}

adauga_utilizator_csv() {
    nume_utilizator=$1
    varsta=$2
    email=$3
    parola=$4
    id=$5
    echo "$nume_utilizator,$varsta,$email,$parola,$id,"$(date '+%Y-%m-%d %H:%M:%S')"" >> $utilizatori_CSV
}

creaza_director_home() {
    nume_utilizator=$1
    cale_home="home/$nume_utilizator"
    mkdir -p "$cale_home"
}

creaza_idunic() {
    echo $(uuidgen)
}

preia_date_utilizator() {

    while true; do
      echo -e "\nIntrodu numele de utilizator: "
      read nume_utilizator

      if verifica_existenta_utilizator "$nume_utilizator"; then
         break
      fi
    done

    if verifica_existenta_utilizator "$nume_utilizator"; then
        while true; do
            echo -e "\nIntrodu adresa de email a utilizatorului:"
             read email
             if verifica_existenta_email "$email"; then
                if ! [[ "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
                        echo -e -n "\n\e[31mAdresa de email nu este validă.\e[0m"
                else
                        break
                 fi
             fi
        done

       while true; do
            echo -e "\nIntrodu parola utilizatorului. "
            sleep 0.5
            echo -e "\e[38;5;208mAceasta trebuie sa aiba minim 8 caractere: cel putin o litera, o cifra si un caracter special.\e[0m"
            sleep 0.5
            echo -n "Parola: "
            read -s parola

            # Verificare dacă parola îndeplinește cerințele
            if (( ${#parola} >= 8 )) && [[ "$parola" =~ [[:punct:]] ]] && [[ "$parola" =~ [0-9] ]]; then
                echo -e "\n\n-- У u вас сильный пароль."
                sleep 0.5
                echo -n "Nu intelegi ce scrie mai sus?"
                sleep 0.5
                echo -n " Pacat :(("
                sleep 0.5
                echo -e "\n\e[32mImportant e ca parola a fost inregistrata cu succes.\e[0m"
                sleep 0.5
                break
            else
                 echo -e "\n\e[31mParola trebuie să aibă cel puțin 8 caractere, un numar si un caracter special. Incearca din nou\e[0m"
            fi
        done
    fi
    while true; do
        echo -e "\nIntrodu anul nașterii (format YYYY):"
        read an_nastere


        if [[ "$an_nastere" =~ ^[0-9]{4}$ ]] && ((an_nastere >= 1900 && an_nastere <= $(date +%Y))); then
            varsta=$(( $(date +%Y) - an_nastere ))  # Calcul vârstă
            break
        else
            echo -e "\n\e[31mAnul nașterii trebuie să fie în format YYYY și să fie valid.\e[0m"
        fi
    done
}

preia_date_utilizator

if [ "$varsta" -gt 14 ]; then
        id=$(creaza_idunic)
        adauga_utilizator_csv "$nume_utilizator" "$varsta" "$email" "$parola" "$id"
        creaza_director_home "$nume_utilizator"
        echo -e "\n\e[32mUtilizatorul a fost înregistrat cu succes.\e[0m"
else
        echo -e "\n\e[31mTrebuie sa ai minim 15 ani pentru a-ti creea cont pe platforma noastra.\n\e[0m"
fi
