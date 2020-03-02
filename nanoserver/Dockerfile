# escape=`

# variants are [nanoserver, sac2016]
ARG VARIANT=nanoserver

#================================================

FROM openjdk:8-jre-${VARIANT}
# We'll also symlink pwsh.exe -> powershell.exe so we can use pwsh throughout
RUN New-Item -ItemType SymbolicLink -Path C:\windows\system32\pwsh.exe -Value (get-command powershell.exe).Source
SHELL ["pwsh", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# TODO: Add Python for mcstatus
# TODO: pip install mcstatus

# Note: 'localhost' can bizarrely resolve to external addresses on some networks
# HEALTHCHECK CMD mcstatus 127.0.0.1 ping

# TODO: Create minecraft user

EXPOSE 25565 25575

ADD https://github.com/itzg/rcon-cli/releases/download/1.3/rcon-cli_windows_amd64.exe /tools/rcon-cli.exe
RUN cmd /c 'setx /M PATH \"C:\tools;%PATH%\"'

COPY minecraft /minecraft

VOLUME ["C:\\data","C:\\mods","C:\\config","C:\\plugins","C:\\users\\minecraft"]

WORKDIR C:\data

ENTRYPOINT [ "pwsh", "-File", "C:\\minecraft\\start.ps1" ]

ENV UID=1000 `
    GID=1000 `
    MOTD="A Minecraft Server Powered by Docker" `
    JVM_XX_OPTS="-XX:+UseG1GC" `
    MEMORY="1G" `
    TYPE=VANILLA`
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

USER ContainerUser