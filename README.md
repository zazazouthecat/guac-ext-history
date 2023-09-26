# 🗂️ guac-ext-history
Script basé sur les sources [https://github.com/MysticRyuujin/guac-install](https://github.com/itiligent/Guacamole-Install/blob/main/guac-optional-features/add-xtra-histrecstor.sh)

## 😺 Modifications
 - Vérification de la compatibilité de version 🥑 Apache Guacamole (min 1.5.0) avant installation
 - Vérification si l'extension n'est pas déjà présente avant installation


## 🐧 Linux distribution 
✅ Debian 10  ❌ Debian 11  ✅ Ubuntu 20

#

# 🏁 Installation 🏁

### Télécharger directement depuis :

`wget https://github.com/zazazouthecat/guac-ext-history/blob/main/guac-ext-history-install.sh -O guac-ext-history-install.sh`

### Rendre le script executable:

`chmod +x guac-ext-history-install.sh`

### Exéctuer le script en root:

`./guac-ext-history-install.sh`


# 🛑 Enregistrement (Video & Keylogger)
## Variables exploitables
```
${HISTORY_PATH} --- Chemin d'enregistrement définit
${HISTORY_UUID} --- ID lié à l'historique
${GUAC_USERNAME}   --- Nom de l'utilisateur connecté
${GUAC_DATE}   --- Date actuelle
${GUAC_TIME}   --- Heure actuelle
${GUAC_CLIENT_ADDRESS}   --- L'adresse IPv4 ou IPv6 de l'utilisateur actue
${GUAC_CLIENT_HOSTNAME}   --- Le nom d'hôte de l'utilisateur actuel
```


il faudra exploiter la commande `guaclog` pour encoder les frappes clavier

### 🔹 Exemple d'enregistrement


### 🔹 Exemple d'encodage frappes clavier

Encodage des frappes au clavier **/log/bastion/MON_SRV/MON_SRV_RECORD_johndoe_20210827_105342**

`guaclog -f /log/bastion/MON_SRV/MON_SRV_RECORD_johndoe_20210827_105342`

#

```


