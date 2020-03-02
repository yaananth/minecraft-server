docker build -t minecraft-server --build-arg VARIANT=windowsservercore . \
    && docker run -it --rm -e EULA=TRUE minecraft-server