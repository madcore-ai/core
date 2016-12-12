
#!/bin/bash -v
#  2016 Madcore Ltd (c)
# Maintained by Peter Styk (devopsfactory@styk.tv)

sudo echo ENV=AWS >> /etc/environment

# PRECONFIGURE madcore
sudo apt-get update
sudo apt-get install git -y
sudo mkdir -p /opt/madcore
sudo chown ubuntu:ubuntu /opt/madcore
git clone https://github.com/madcore-ai/core.git /opt/madcore
sudo chmod +x /opt/madcore/core-install.sh
sudo "/opt/madcore/core-install.sh"
