Registry Habitat

Files:

controlbox.toml

  TOML File generated by the setup script. This script adds IP address to TOML file.

hab.director-controlbox.toml.template

  TOML File Template used to prepare hab.director-controlbox.toml file.

setup.sh

  Main script that Extracts the IP address.
  Passes it to template (sed) and generates TOML file.
  Copies the Files to its desired location.
  Innitialises systemd service and runs it.

habitat-depot.service

  It the service script that needs to be placed in systemd dir.

habitat ports:
redis-server - 6379
hab-depot - 9632

child1 http api - 8000
child2 http api - 8001
child1 http gossip - 9000
child2 http gossip - 9001