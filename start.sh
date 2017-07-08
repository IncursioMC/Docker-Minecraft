#!/bin/bash
# Handles running Spigot Servers
sleep 1

cd /home/container
# Download the file
MODIFIED_DL_PATH=`echo ${DL_PATH} | perl -pe 's@\{\{(.*?)\}\}@$ENV{$1}@g'`
echo "$ curl -sS -L -o ${SERVER_JARFILE} ${MODIFIED_DL_PATH}"
curl -sS -L -o ${SERVER_JARFILE} ${MODIFIED_DL_PATH}

if [ ! -z "$PLUGIN_SCRIPT" ]; then
    mkdir -p /home/container/plugins
    cd /home/container/plugins
	echo "Downloading plugins..."
    curl -sL ${PLUGIN_SCRIPT} | bash
	echo "Finished Downloading plugins!"
	sleep 1
fi

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
