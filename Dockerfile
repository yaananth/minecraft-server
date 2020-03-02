# escape=`

# variants are [nanoserver, sac2016]
ARG VARIANT=nanoserver

#================================================

FROM mcr.microsoft.com/powershell:${VARIANT}

USER ContainerAdministrator

ENV JAVA_HOME C:\openjdk-8
RUN echo Updating PATH: %JAVA_HOME%\bin;%PATH% `
    && setx /M PATH "%JAVA_HOME%\\bin;%PATH%"

USER ContainerUser

# $ProgressPreference: https://github.com/PowerShell/PowerShell/issues/2138#issuecomment-251261324
SHELL [ "pwsh", "-c", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';" ]

# https://adoptopenjdk.net/upstream.html
# >
# > What are these binaries?
# >
# > These binaries are built by Red Hat on their infrastructure on behalf of the OpenJDK jdk8u and jdk11u projects. The binaries are created from the unmodified source code at OpenJDK. Although no formal support agreement is provided, please report any bugs you may find to https://bugs.java.com/.
# >
ENV JAVA_VERSION 8u242
ENV JAVA_BASE_URL https://github.com/AdoptOpenJDK/openjdk8-upstream-binaries/releases/download/jdk8u242-b08/OpenJDK8U-jre_
ENV JAVA_URL_VERSION 8u242b08
# https://github.com/docker-library/openjdk/issues/320#issuecomment-494050246
# >
# > I am the OpenJDK 8 and 11 Updates OpenJDK project lead.
# > ...
# > While it is true that the OpenJDK Governing Board has not sanctioned those releases, they (or rather we, since I am a member) didn't sanction Oracle's OpenJDK releases either. As far as I am aware, the lead of an OpenJDK project is entitled to release binary builds, and there is clearly a need for them.
# >

RUN $url = ('{0}x64_windows_{1}.zip' -f $Env:JAVA_BASE_URL, $Env:JAVA_URL_VERSION); `
    Write-Host ('Downloading {0} ...' -f $url); `
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; `
    Invoke-WebRequest -Uri $url -OutFile 'openjdk.zip'; `
    `
    Write-Host 'Expanding ...'; `
    New-Item -ItemType Directory -Path C:\temp | Out-Null; `
    Expand-Archive openjdk.zip -DestinationPath C:\temp; `
    Move-Item -Path C:\temp\* -Destination $Env:JAVA_HOME; `
    Remove-Item C:\temp; `
    `
    Write-Host 'Removing ...'; `
    Remove-Item openjdk.zip -Force; `
    `
    Write-Host 'Verifying install ...'; `
    Write-Host '  java -version'; java -version; `
    `
    Write-Host 'Complete.'

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
