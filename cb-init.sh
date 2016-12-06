
#!/bin/bash -v
# Madcore Pre Configure
# Maintained by Peter Styk (humans@madcore.ai)

sudo echo ENV=AWS >> /etc/environment

# PRECONFIGURE CONTROLBOX
sudo apt-get update
sudo apt-get install git -y
sudo mkdir -p /opt/controlbox
sudo chown ubuntu:ubuntu /opt/controlbox
git clone https://bitbucket.org/ronaanimation/controlbox.git /opt/controlbox
sudo chmod +x /opt/controlbox/cb-install.sh
sudo "/opt/controlbox/cb-install.sh"

