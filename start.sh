#!/bin/ash
# Handles running Spigot Servers
if [ -z "$SERVER_JARFILE" ]; then
    SERVER_JARFILE="server.jar"
fi

cd /home/container
CHK_FILE="/home/container/${SERVER_JARFILE}"

if [ -f $CHK_FILE ]; then
   echo "A ${SERVER_JARFILE} file already exists in this location, not downloading a new one."
else
    if [ -z "$DL_PATH" ] || [ "$DL_PATH" == "build" ]; then
        echo "Building Spigot... This could take awhile."

        cd /tmp
        curl -sS -o BuildTools.jar https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
        git config --global --unset core.autocrlf
        java -jar BuildTools.jar --rev ${DL_VERSION}

        cp /tmp/spigot-*.jar /home/container/${SERVER_JARFILE}
        cd /home/container
    else
        # Download the file
        MODIFIED_DL_PATH=`echo ${DL_PATH} | perl -pe 's@\{\{(.*?)\}\}@$ENV{$1}@g'`
        echo "$ curl -sS -L -o ${SERVER_JARFILE} ${MODIFIED_DL_PATH}"
        curl -sS -L -o ${SERVER_JARFILE} ${MODIFIED_DL_PATH}
    fi
fi

cd /home/container

if [ -z "$STARTUP"  ]; then
    echo "error: no startup parameters have been set for this container"
else
    MODIFIED_STARTUP=`echo ${STARTUP} | perl -pe 's@\{\{(.*?)\}\}@$ENV{$1}@g'`
    echo "$ java ${MODIFIED_STARTUP}"
    java ${MODIFIED_STARTUP}
fi
