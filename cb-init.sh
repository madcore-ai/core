
#!/bin/bash -v
# Madcore Pre Configure
# Maintained by Peter Styk (humans@madcore.ai)

sudo echo ENV=AWS >> /etc/environment

# PRECONFIGURE madcore
sudo apt-get update
sudo apt-get install git -y
sudo mkdir -p /opt/madcore
sudo chown ubuntu:ubuntu /opt/madcore
git clone https://github.com/madcore-ai/core.git /opt/madcore
sudo chmod +x /opt/madcore/cb-install.sh
sudo "/opt/madcore/cb-install.sh"

