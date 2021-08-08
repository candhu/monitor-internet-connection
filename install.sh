#!/bin/sh

# Check current service status
sudo systemctl is-active --quiet monitor_internet_connection.service
if [ $? -eq 0 ]
then
	echo Service is active.
	echo Stopping...
	sudo systemctl stop monitor_internet_connection.service
fi

# Copy service to systemd
sudo cp ./monitor_internet_connection.service /etc/systemd/system/ 
if [ $? -ne 0 ]
then
	echo "ERROR: Failed to copy monitor_internet_connection.service to /etc/systemd/system/"
	echo "Stop."
	exit 255
fi

# Inform systemd that a new sercice has been added
sudo systemctl daemon-reload

# Start the service
sudo systemctl start monitor_internet_connection.service
wait 5
sudo systemctl is-active --quiet monitor_internet_connection.service 
if [ $? -ne 0 ]
then
        echo "ERROR: Service failed to start"
	echo "Stop."
	exit 255
fi

# Enable service for auto start on reboot
sudo systemctl enable monitor_internet_connection.service
