# Setup systemd to run syncthing at system startup

Rename syncthing@user.service to a username on the syncthing server
Copy the file to the /etc/systemd/system/multi-user.target.wants directory
Run sudo systemctl enable --now syncthing@<user>.service
