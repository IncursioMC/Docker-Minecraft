#!/bin/bash
# Handles running Spigot Servers
sleep 3

cd /home/container
CHK_FILE="/home/container/${SERVER_JARFILE}"


# Download the file
MODIFIED_DL_PATH=`echo ${DL_PATH} | perl -pe 's@\{\{(.*?)\}\}@$ENV{$1}@g'`
echo "$ curl -sS -L -o ${SERVER_JARFILE} ${MODIFIED_DL_PATH}"
curl -sS -L -o ${SERVER_JARFILE} ${MODIFIED_DL_PATH}

cd /home/container

if [ -z "$STARTUP"  ]; then
    echo "error: no startup parameters have been set for this container"
else
    # Output java version to console for debugging purposes if needed.
    java -version

    # Pass in environment variables.
    MODIFIED_STARTUP=`echo ${STARTUP} | perl -pe 's@\{\{(.*?)\}\}@$ENV{$1}@g'`
    echo "$ java ${MODIFIED_STARTUP}"

    # Run the server.
    java ${MODIFIED_STARTUP}
fi
