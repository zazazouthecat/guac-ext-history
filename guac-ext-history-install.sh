#Script SBER v1.0 - 26/09/2023
#Script basé sur les sources https://github.com/itiligent/Guacamole-Install/blob/main/guac-optional-features/add-xtra-histrecstor.sh
# 
# - Script d'installation de l'extension de stockage d'historique enregistré pour guacamole

# Check if user is root or sudo
if ! [ $( id -u ) = 0 ]; then
    echo "Merci de lancer ce script en root ou sudo" 1>&2
    exit 1
else
	apt install sudo
	echo -e "Ajout de Root au sudoers"
	sudo usermod -aG sudo root
	echo
fi

# Colors to use for output
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Log Location
LOG="/tmp/guacamole_${GUACVERSION}_build.log"

clear

#Prez !
clear
echo
echo
echo -e "${YELLOW} |'-._/\_.-'| ***************************************** |'-._/\_.-'| "
echo -e "${YELLOW} |    ||    | ***************************************** |    ||    | "
echo -e "${YELLOW} |___o()o___| ***************************************** |___o()o___| "
echo -e "${YELLOW} |__((<>))__| ********** BASTION DE SECURITE ********** |__((<>))__| "
echo -e "${YELLOW} \   o\/o   / **********   Apache Guacamole  ********** \   o\/o   /"
echo -e "${YELLOW}  \   ||   /  ******** Extention Enregistement ********  \   ||   /"
echo -e "${YELLOW}   \  ||  /   *****************************************   \  ||  /"
echo -e "${YELLOW}    '.||.'    **********************************SBER***    '.||.'"
echo -e "${YELLOW}      ''      *****************************************      ''"
echo
echo
# Fin de Prez !

#Variable auto
TOMCAT_VERSION=$(ls /etc/ | grep tomcat)
GUAC_VERSION=$(grep -oP 'Guacamole.API_VERSION = "\K[0-9\.]+' /var/lib/${TOMCAT_VERSION}/webapps/guacamole/guacamole-common-js/modules/Version.js)
GUAC_SOURCE_LINK="http://apache.org/dyn/closer.cgi?action=download&filename=guacamole/${GUAC_VERSION}"
HISTREC_PATH_DEFAULT=/var/lib/guacamole/recordings # Apache default

echo -e "Version Tomcat détectée : ${TOMCAT_VERSION}"
echo -e "Version Guacamole détectée : ${GUAC_VERSION}"

#Check si le version de guacamole installée est compatible avec l'extention
#Extention d'enregistement disponible que depuis la version 1.5.0
if dpkg --compare-versions ${GUAC_VERSION} lt 1.5.0
then
	echo -e "${RED}La version actuellement installée de Guacamole n'est pas compatible avec l'extention (Min Ver : 1.5.0)${NC}" 1>&2
	exit 1
else
	echo -e "${GREEN}La version actuellement installée de Guacamole est compatible avec l'extention${NC}"
fi


#Check si l'extention est déjà installée...
if [ -f /etc/guacamole/extensions/guacamole-history-recording-storage-*.jar ]
then
	echo -e "${RED}!!! Extention déja installée !!!${NC}" 1>&2
	exit 1
else
	echo -e "${GREEN}Debut installation extention${NC}"
fi

while true; do
    echo
    read -p "Entrer le chemin de stockage des enregistrements [Par défaut : ${HISTREC_PATH_DEFAULT}]: " HISTREC_PATH
    [[ "${HISTREC_PATH}" = "" ]] || [[ "${HISTREC_PATH}" != "" ]] && break
done
# If no custom path is given, lets assume the default path on hitting enter
if [[ -z "${HISTREC_PATH}" ]]; then
    HISTREC_PATH="${HISTREC_PATH_DEFAULT}"
fi
echo

# Download Guacamole history recording storage extension
echo -e "${CYAN}Téléchargement des fichiers...${NC}"
wget --no-check-certificate -q -q --show-progress -O guacamole-history-recording-storage-${GUAC_VERSION}.tar.gz ${GUAC_SOURCE_LINK}/binary/guacamole-history-recording-storage-${GUAC_VERSION}.tar.gz
if [ $? -ne 0 ]; then
    echo -e "${RED}Echec de téléchargement de guacamole-history-recording-storage-${GUACVERSION}.tar.gz" 1>&2
    echo -e "${SERVER}/source/guacamole-history-recording-storage-${GUACVERSION}.tar.gz${NC}"
    exit 1
else
    # Extract Guacamole Files
    tar -xzf guacamole-history-recording-storage-${GUAC_VERSION}.tar.gz
fi
echo -e "${GREEN}guacamole-history-recording-storage-${GUACVERSION}.tar.gz Téléchargé${NC}"


# Move history recording storage extension files
mv -f guacamole-history-recording-storage-${GUAC_VERSION}/guacamole-history-recording-storage-${GUAC_VERSION}.jar /etc/guacamole/extensions/
chmod 664 /etc/guacamole/extensions/guacamole-history-recording-storage-${GUAC_VERSION}.jar
#Setup the default recording path
echo -e "${CYAN}Création du répertoire de stockage ${HISTREC_PATH} ${NC}"
mkdir -p ${HISTREC_PATH}
echo -e "${CYAN}Droit sur ${HISTREC_PATH} deamon:tomcat + chmod 2750 ${NC}"
chown daemon:tomcat ${HISTREC_PATH}
chmod 2750 ${HISTREC_PATH}
echo "recording-search-path: ${HISTREC_PATH}" >>/etc/guacamole/guacamole.properties
echo -e "${GREEN}guacamole-history-recording-storage-${GUAC_VERSION} Installé${NC}"

systemctl restart ${TOMCAT_VERSION}
systemctl restart guacd

rm -rf guacamole-*

echo
echo "${CYAN}Terminé !"
echo -e ${NC}





