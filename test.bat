docker build -t minecraft-server --no-cache --build-arg VARIANT=nanoserver .
IF %ERRORLEVEL% EQU 0 (
    docker run -it --rm -e EULA=TRUE minecraft-server pwsh
)
