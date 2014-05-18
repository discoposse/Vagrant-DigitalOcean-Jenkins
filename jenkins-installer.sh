sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y vim git default-jdk puppet screen 

sudo mkdir /srv/minecraft-server
cd /srv/minecraft-server

wget -O minecraft_server.jar https://s3.amazonaws.com/Minecraft.Download/versions/1.7.9/minecraft_server.1.7.9.jar

# Add the user to run the minecraft as a service
sudo adduser --system --no-create-home --home /srv/minecraft-server minecraft
sudo chown -R minecraft /srv/minecraft-server

echo "
# description "start and stop the minecraft-server"

console log

exec start-stop-daemon --stop "stop" --start --chdir /srv/minecraft-server --chuid minecraft \
    --exec /usr/bin/java -- -Xms1536M -Xmx2048M -jar minecraft_server.jar nogui 2>&1

start on runlevel [2345]
stop on runlevel [^2345]

respawn
respawn limit 20 5" | sudo tee /etc/init/minecraft-server.conf

