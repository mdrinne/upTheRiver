from Table import Table
from Player import Player
from time import sleep
import socket
from threading import Thread

HEADER = 16
FORMAT = 'utf-8'
SERVER = socket.gethostbyname(socket.gethostname())
PORT = None
GAME_OPEN = None

# Client Messages
DISCONNECT = 'disconnect'
ADD_PLAYER = 'addPlayer'

connections = []
table = None

def addPlayerHandler(msg, addr):
    new_player = Player(msg[1], msg[2], msg[3], addr)
    table.players.append(new_player)
    print('[PLAYER ADDED] %s' % (new_player.uid))

def clientHandler(conn, addr):
    print('%s: [NEW CONNECTION] %s' % (table.name, addr))
    
    connected = True
    while connected:
        msg_len = conn.recv(HEADER).decode(FORMAT)
        if msg_len:
            msg_len = int(msg_len)
            msg = conn.recv(msg_len).decode(FORMAT)
            msg = msg.split(';')

            if msg[0] == DISCONNECT:
                connected = False
            elif msg[0] == ADD_PLAYER:
                addPlayerHandler(msg, addr)
            print('%s: [%s] %s' % (table.name, addr, msg))

    conn.close()

def gameInstance(owner, name, port):
    # Create new Table object
    global table
    table = Table(owner,name,port)
    PORT = port
    print('%s: [STARTING]' % table.name)
    
    # Create a TCP/IP socket
    gameServer = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    # Bind the socket to the port
    server_address = (SERVER, PORT)
    print('%s: [STARTING UP] %s, port: %s' % (table.name, server_address[0], server_address[1]))
    try:
        gameServer.bind(server_address)
    except socket.error as e:
        print(str(e))

    # Listen for incoming connections
    gameServer.listen(10)

    GAME_OPEN = 1
    while GAME_OPEN:
        # Wait for connection
        print('%s: [WAITING FOR CONNECTION] port: %s' % (table.name, table.port))
        conn, client_address = gameServer.accept()
        # print('%s: [CONNECTION ACCEPTED]')
        connections.append(conn)
        clientThread = Thread(target=clientHandler, args=(conn,client_address))
        clientThread.start()

