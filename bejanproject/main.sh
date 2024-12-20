#!/bin/bash

utilizatori_CSV="registru1.csv"
numar_utilizatori() {
        nr_utilizatori=$(tail -n +2 "$utilizatori_CSV" | wc -l)
        if [ "$nr_utilizatori" -gt 0 ]; then
                echo "Numărul de utilizatori înregistrați este: $nr_utilizatori"
        else
                echo "Nu există încă utilizatori înregistrați."
    fi
}

autentificat=0
logout()
{
        autentificat=0
        for ((i=0; i<${#logged_in_users[@]}; i++))
        do
                if [ "${logged_in_users[i]}" = "$nume_introdus" ]; then
                 unset 'logged_in_users[i]'
                 break
                fi
        done
        cd ..
        cd ..
}
logged_in_users=()
alegere=100

while [ "$alegere" -ne 0 ]
do
echo -e "\n\e[36mMeniu\n\e[0m"
echo -e "\e[36mApasati tasta corespunzatoare actiunii pe care o doriti:\e[0m"
echo "1.Inregistrare"
echo "2.Autentificare"
echo "3.Deconectare"
echo "4.Verificare numar total de conturi create"
echo "5.Verificare utilizatori logati"
echo "6.Generare raport"
echo -e "\e[31m0.Inchidere sesiune\n\e[0m"

read alegere

case $alegere in
        1) if [ "$autentificat" -eq 1 ]; then
                echo -e "\n\e[38;5;208mSunteti autentificat. Pentru a va inregistra, va rugam sa va delogati.\n\e[0m"
           else
                echo -e "\nIncepe procesul de inregistrare."
                source inregistrare.sh
           fi ;;
        2) if [ "$autentificat" -eq 1 ]; then
                echo -e "\n\e[38;5;208mSunteti deja autentificat. Pentru a realiza o alta autentificare va rugam sa va delogati.\n\e[0m"
           else
                echo -e "\nIncepe procesul de autentificare.\n"
                source autentificare.sh
                if [ "$autentificat" -eq 1 ]; then
                        logged_in_users+=("$nume_introdus")
                fi
           fi ;;
        3) if [ "$autentificat" -eq 0 ]; then
                echo -e "\n\e[38;5;208mNu se poate efectua delogarea deoarece nu sunteti logat.\n\e[0m"
           else
                echo -e "\nIncepe procesul de delogare"
                logout
                echo -e "\n\e[32mDelogarea s-a realizat cu succes.\e[0m"
           fi ;;
        4) if [ "$autentificat" -eq 0 ]; then
                numar_utilizatori
           else
                cd ..
                cd ..
                numar_utilizatori
                cd "home/$nume"
           fi ;;
        5) if [ "${#logged_in_users[@]}" -ne 0 ]; then
                echo -e "\n\e[38;5;82mLista utilizatorilor conectati este: ${logged_in_users[@]}\e[0m"
           else
                echo -e "\n\e[38;5;208mNu sunt utilizatori conectati momentan.\e[0m"
           fi ;;
        6) if [ "$autentificat" -eq 0 ]; then
                echo -e "\nTrebuie sa fii autentificat pentru a-ti genera raportul."
           else
                echo -e "\nSe genereaza raportul."
                cd ..
                cd ..
                source raport.sh
                echo -e "\nRaportul a fost generat."
                cd "home/$nume"
          fi ;;
        0) echo -e "\n\e[31mSe inchide sesiunea\n\e[0m"
           exit 0 ;;
        *) echo -e "\n\e[38;5;208mAi ales alt numar fata de cele care fac ceva cu adevarat. Mai incearca o data.\e[0m" ;;
esac
done