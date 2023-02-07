#!/bin/bash

# Dans un premier temps déclaration de toutes les fonctions dans l'ordre logique.

# Cette fonction a pour but d'afficher le menu en utilisant quelques commandes "tput"
function menu () {
    clear #Effectue un clear pour une meilleure visibilité
    tput rev #Met un fond blanc sur le texte suivant
    echo "Menu du restaurant"
    tput sgr0 #Annule le dernier tput sinon tout le menu serait sur fond blanc
    
cat ./menu.txt #affiche le fichier ./menu.txt
}
# Cette fonction a pour but de saisir les entrees et leur quantités, avec la recup des variables prix et nb_entree pour le calcul du total
function entree() {
    echo "Les entrées"
    read -p " Numéro de l'entrée: " prix; 
    read -p " Combien ? " nb_entree; 
    read -p " Voulez vous une autre entrée? (o/n) " suite;
    #retour au debut de la fontion si il faut rajouter des entrees en cas de choix multiple
    if [ $suite = o ] ; then
        entree;
    fi
}
# Cette fonction a pour but de saisir les plats et leur quantités, avec la recup des variables prix et nb_entree pour le calcul du total - utilisation de read -p pour pouvoir alimenter la variable
function plat() {
    echo "Les plats"
    read -p " Numéro du plat: " prix; 
    read -p " Combien ? " nb_plat; 
    read -p " Voulez vous un autre plat? (o/n) " suite;  
    #retour au debut de la fontion si il faut rajouter des entrees en cas de choix multiple
    if [ $suite = o ] ; then
        plat
    fi
}
# Cette fonction a pour but de saisir les desserts et leur quantités, avec la recup des variables prix et nb_entree pour le calcul du total - utilisation de read -p pour pouvoir alimenter la variable
function dessert() {
    echo "Les desserts"
    read -p " Numéro du dessert: " prix; 
    read -p " Combien ? " nb_dessert; 
    read -p " Voulez vous un autre dessert? (o/n) " suite;   
    #retour au debut de la fontion si il faut rajouter des entrees en cas de choix multiple
    if [ $suite = o ] ; then
        dessert
    fi
}
# Cette fonction a pour but de saisir les boissons et leur quantités, avec la recup des variables prix et nb_entree pour le calcul du total - utilisation de read -p pour pouvoir alimenter la variable
function boisson() {
    echo "Les boissons"
    read -p " Numéro de la boisson: " prix; 
    read -p " Combien ? " nb_boisson; 
    read -p " Voulez vous une autre boisson? (o/n) " suite; 
    #retour au debut de la fontion si il faut rajouter des entrees en cas de choix multiple  
    if [ $suite = o ] ; then
        boisson
    #sinon fin de commande car de toute facon apres le choix boisson il n'y a plus aucun choix possible
    elif [ $suite = n ] ; then
        echo "COMMANDE TERMINEE"
    fi
}

#Cette fonction va calculer le montant ht en fonction des variables recuperer lors des fonctions precedentes, en utilisant la variable prix et la quantité nb_....
function calcul () {
    echo "Montant HT de la commande: "
    total_ht="$(($prix*$nb_entree+$prix*$nb_plat+$prix*$nb_dessert+$prix*$nb_boisson))";
}

# avec l'aide des collegues on a trouvé la commande bc pour permettre le calcul et l'affichage de nombre flottant, mais je n'arrive pas à installer bc sur mon terminal, dans un fichier joint capture d'ecran du probleme, c'est pourquoi j'ai laissé la fonction en commentaire

# function tva() {
#     montant_TTC=$(echo "$total_ht*1.1167" | bc) ;
#     printf "\nLe prix est de %.2f €\n" $montant_TTC ;
# }

# Cette fonction va permettre de prendre la commande en passant par les differentes fonctions selon le besoin sinon on passe à la fonction suivante. 
function take_order () {
    tput cup 30 #execute un saut de ligne pour afficher le texte apres le menu
    tput rev #met un fond
    prix=$(grep -w [-]$i menu.txt | grep -o '\([0-9]\{1,2\}\)[€]' | sed 's/€//g') ; #on definit la variable prix pour que lorsque l'on effectue le choix du plat, le script aille chercher dans le fichier .txt pour recuperer le prix afin de pouvoir ensuite effectuer le calcul de l'addition. pour cela il faut utiliser la commande grep et pipe pour qu'il lise ligne par ligne et selon les criteres que l'on a definit. la commande sed vient enlever le signe € qui poserait probleme pour le calcul. 
    echo "Passez la commande"
    #ici plusieurs conditions pour que si le client ne veut pas d'une entree ou plat etc etc on passe les fonctions qui ne nous serviront pas en fonction du choix client
    #si le serveur repond oui alors il lance la fonction correspondante, sinon la condition se ferme et passe a l'autre question.
    read -p "Souhaitez vous des entrées? (o/n) " suite_entree;
    if [ $suite_entree = o ] ; then
        entree;
    fi
        read -p "Souhaitez vous des plats? (o/n) " suite_plat;
    if [ $suite_plat = o ] ; then
        plat;
    fi
        read -p "Souhaitez vous des desserts? (o/n) " suite_dessert; 
    if [ $suite_dessert = o ] ; then
        dessert;
    fi 
        read -p "Souhaitez vous des boissons? (o/n) " suite_boisson;
    if [ $suite_boisson = o ] ; then
        boisson; 
    fi
    calcul #appel de la fonction calcul
    # tva
}
menu #appel de la fonction 
take_order #appel de la fonction