# escape=`

ARG HOST_TAG=ltsc2019

ARG BUNDLE_IMAGE_NAME=bundle
ARG BUNDLE_TAG=ltsc2019
FROM ${BUNDLE_IMAGE_NAME}:pwsh-${BUNDLE_TAG} AS pwsh
FROM ${BUNDLE_IMAGE_NAME}:java-${BUNDLE_TAG} AS java

FROM mcr.microsoft.com/windows/servercore:${HOST_TAG}

ENV JAVA_HOME C:\java
RUN echo Updating PATH: %JAVA_HOME%\bin;C:\pwsh;%PATH% `
    && setx /M PATH "%JAVA_HOME%\bin;C:\pwsh;%PATH%"

ARG PWSH_BUNDLE_DIRECTORY=C:\pwsh
ARG JAVA_BUNDLE_DIRECTORY=C:\java
COPY --from=pwsh $PWSH_BUNDLE_DIRECTORY C:\pwsh
COPY --from=java $JAVA_BUNDLE_DIRECTORY $JAVA_HOME

SHELL [ "pwsh", "-c", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';" ]

# TODO: Add mc-monitor
# Note: 'localhost' can bizarrely resolve to external addresses on some networks
#HEALTHCHECK --start-period=1m CMD mc-monitor status --host 127.0.0.1 --port $SERVER_PORT

# TODO: Create minecraft user

EXPOSE 25565 25575

VOLUME ["C:\\data","C:\\mods","C:\\config"]
COPY minecraft C:\minecraft
WORKDIR C:\data

CMD [ "pwsh", "-File", "C:\\minecraft\\start.ps1" ]

ENV UID=1000 `
    GID=1000 `
    MOTD="A Minecraft Server Powered by Docker" `
    JVM_XX_OPTS="-XX:+UseG1GC" `
    MEMORY="1G" `
    TYPE=VANILLA `
    VERSION=LATEST `
    FORGEVERSION=RECOMMENDED `
    LEVEL=world `
    PVP=true `
    DIFFICULTY=easy `
    ENABLE_RCON=true `
    RCON_PORT=25575 `
    RCON_PASSWORD=minecraft `
    LEVEL_TYPE=DEFAULT `
    GENERATOR_SETTINGS= `
    WORLD= `
    MODPACK= `
    ONLINE_MODE=TRUE `
    CONSOLE=true
