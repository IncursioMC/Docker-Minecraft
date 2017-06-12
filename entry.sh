#!/bin/ash
sleep 5

C_RED="tput setaf 1"
C_GREEN="tput setaf 2"
C_RESET="tput sgr0"

# Determine the latest version, or set the version to download.
if [ -z "${BUNGEE_VERSION}" ] || [ "${BUNGEE_VERSION}" == "latest" ]; then
    DL_VERSION="lastStableBuild"
else
    DL_VERSION=${BUNGEE_VERSION}
fi

# Determine what is being considered as the start file.
if [ "${SERVER_JARFILE}" == "waterfall.jar" ]; then
    SERVER_JARFILE="waterfall.jar"
    if [ -f "/home/container/${SERVER_JARFILE}" ]; then
        echo "${C_GREEN}Found ${SERVER_JARFILE} in container, not downloading a new jar.${C_RESET}"
    else 
        echo ":/home/container$ curl -sS https://ci.incursio.net/job/Travertine/${DL_VERSION}/artifact/Travertine-Proxy/bootstrap/target/Travertine.jar -o ${SERVER_JARFILE}"      
        curl -sS https://ci.incursio.net/job/Travertine/${DL_VERSION}/artifact/Travertine-Proxy/bootstrap/target/Travertine.jar -o ${SERVER_JARFILE}
        if [ $? -ne 0 ]; then
            echo "${C_RED}PTDL_CONTAINER_ERR: There was an error while attempting to download a new jarfile for this server.${C_RESET}"
            exit 1
        fi
    fi
    
elif [ -z "${SERVER_JARFILE}" ] || [ "${SERVER_JARFILE}" == "bungeecord.jar" ]; then
    SERVER_JARFILE="bungeecord.jar"
# Download the correct version, or skip if it already exists.
    if [ -f "/home/container/${SERVER_JARFILE}" ]; then
        echo "${C_GREEN}Found ${SERVER_JARFILE} in container, not downloading a new jar.${C_RESET}"
    else
        echo ":/home/container$ curl -sS https://ci.incursio.net/job/Bungeecord-Alpine/${DL_VERSION}/artifact/bootstrap/target/BungeeCord.jar -o ${SERVER_JARFILE}"
        curl -sS https://ci.incursio.net/job/Bungeecord-Alpine/${DL_VERSION}/artifact/bootstrap/target/BungeeCord.jar -o ${SERVER_JARFILE}
        if [ $? -ne 0 ]; then
            echo "${C_RED}PTDL_CONTAINER_ERR: There was an error while attempting to download a new jarfile for this server.${C_RESET}"
            exit 1
        fi
    fi
fi

# Output Current Java Version
java -version

# Replace Startup Variables
MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
echo ":/home/container$ java ${MODIFIED_STARTUP}"

# Run the Server
java ${MODIFIED_STARTUP}

if [ $? -ne 0 ]; then
    echo "${C_RED}PTDL_CONTAINER_ERR: There was an error while attempting to run the start command.${C_RESET}"
    exit 1
fi