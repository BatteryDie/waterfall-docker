#!/bin/bash

# Enter server folder
cd waterfall

# Get version/build information and download URL and jar name
URL=https://papermc.io/api/v2/projects/waterfall
if [ ${MC_VERSION} = latest ]
then
  # Get the latest Minecraft version
  MC_VERSION=$(wget -qO - $URL | jq -r '.versions[-1]') # "-r" is needed because the output has quotes otherwise
fi
URL=${URL}/versions/${MC_VERSION}
if [ ${WATERFALL_BUILD} = latest ]
then
  # Get the latest Waterfall build
  WATERFALL_BUILD=$(wget -qO - $URL | jq '.builds[-1]')
fi
JAR_NAME=paper-${MC_VERSION}-${WATERFALL_BUILD}.jar
URL=${URL}/builds/${WATERFALL_BUILD}/downloads/${JAR_NAME}

# Update waterfall if necessary
if [ ! -e ${JAR_NAME} ]
then
  # Remove old server jar(s)
  rm -f *.jar
  # Download new server jar
  wget ${URL} -O ${JAR_NAME}
  
  # If this is the first run, accept the EULA
  if [ ! -e eula.txt ]
  then
    # Run the server first time to generate eula.txt
    java -jar ${JAR_NAME}
    # Change false to true in eula.txt to accept the EULA
    sed -i 's/false/true/g' eula.txt
  fi
fi

# Add RAM options to Java options if necessary
if [ ! -z "${MC_RAM}" ]
then
  JAVA_OPTS="-Xms${MC_RAM} -Xmx${MC_RAM} ${JAVA_OPTS}"
fi

# Add port options to Minecraft server option if necessary
if [ ! -z "${MC_PORT}" ]
then
  MC_OPTS="-p=${MC_PORT}"
fi

# Start server
exec java -server ${JAVA_OPTS} -jar ${JAR_NAME} nogui ${MC_OPTS}
