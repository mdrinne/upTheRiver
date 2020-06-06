# Matt Rinne 6/3/2020
# server.py

import socket
import sys
from threading import Thread
from gameHandler import gameInstance
from Table import Table


availablePorts = [25001,25002,25003,25004,25005,25006,25007,25008,25009,25010,25011,25012,25013,25014,25015]
availablePortsCount = 15

# Create a TCP/IP socket
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# Bind the socket to the port
server_address = ('localhost', 25000)
print('starting up on %s port %s' % (server_address[0], server_address[1]))
try:
    sock.bind(server_address)
except socket.error as e:
    str(e)

# Listen for incoming connections
sock.listen(10)

while True:

    # Wait for a connection
    print('waiting for a connection')
    connection, client_address = sock.accept()

    try:
        print('connection from ', client_address)

        # Receive the data in small chunks and retransmit it
        while True:
            data = connection.recv(1024).decode('utf-8')
            print('received %s' % data)
            if data:
                data_split = data.split(';')
                if data_split[0] == 'createTable':
                    print('sending new port for created table back to user')
                    if availablePortsCount > 0:
                        gamePort = availablePorts.pop()
                        availablePortsCount -= 1
                        msg = "newTablePort;" + str(gamePort)
                        thread = Thread(target=gameInstance, name=data_split[1] + ": " + str(gamePort), kwargs=dict(owner=data_split[2], name=data_split[1], port=gamePort))
                        thread.start()
                        connection.sendto(str.encode(msg),client_address)

                    else:
                        msg = "noOpenPort"
                        connection.sendto(str.encode(msg), client_address)
            else:
                print('no more data from ', client_address)
                break

    finally:
        # Clean up the connection
        connection.close()
