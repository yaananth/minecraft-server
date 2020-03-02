docker build -t minecraft-server --build-arg VARIANT=nanoserver .
docker run -it --rm -e EULA=TRUE minecraft-server
