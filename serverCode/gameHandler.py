from Table import Table
from Player import Player
from time import sleep
import socket
from threading import Thread

class GameHandler:
    def __init__(self, owner, name, port):
        self.connections = []
        self.table = Table(owner, name, port)
        self.game_open = 1
        self.SERVER = socket.gethostbyname(socket.gethostname())
        self.PORT = port
        self.HEADER = 16
        self.FORMAT = 'utf-8'

        # Client Messages
        self.DISCONNECT = 'disconnect'
        self.ADD_PLAYER = 'addPlayer'
        self.CLOSE_TABLE = 'closeTable'
        self.START_GAME = 'startGame'

    def sendAll(self, msg):
        message = msg.encode(self.FORMAT)
        msg_len = len(message)
        send_len = str(msg_len).encode(self.FORMAT)
        send_len += b' ' * (self.HEADER - len(send_len))
        for conn in self.connections:
            conn.send(send_len)
            conn.send(message)

    def addPlayerHandler(self, msg, addr):
        new_player = Player(msg[1], msg[2], msg[3], addr)

        # If game is not in progress or full, add player to the table, else add them to the queue
        if not self.table.inProgress and self.table.playerCount < 10:
            self.table.addPlayer(new_player)
            print('%s: [PLAYER ADDED] %s' % (self.table.name, new_player.uid))
            msg = 'playerAdded;' + new_player.uid + ';' + new_player.nickname + ';' + new_player.fullname
            self.sendAll(msg)
        else:
            table.addPlayerToQueue(new_player)
            print('%s: [PLAYER QUEUED] %s' % (self.table.name, new_player.uid))

    def notifyTurn(self):
        myTurn = self.table.whosTurn()
        gameRound = self.table.round
        myHand = myTurn.hand
        print('[PRINTING MY HAND] %s' % myHand)
        cards = ''
        for i in range(0,4):
            myCard = myHand[i]
            if type(myCard) is tuple:
                if i != 0:
                    cards += ','
                cards += myCard[0] + myCard[1]
        if cards == '':
            cards = 'noCards'         
        msg = 'notifyTurn;' + str(gameRound) + ';' + myTurn.uid + ';' + cards
        self.sendAll(msg)
        
    
    def startGameHandler(self):
        self.table.startGame()
        msg = "gameStarted"
        self.sendAll(msg)
        self.notifyTurn()


    # def closeTableHandler(self):
    #     # print('%s: [CLOSING TABLE]')
    #     # msg = 'tableClosed'
    #     # sendAll(msg)
    #     for conn in connections:
    #         conn.close()

    #     self.game_open = 0


    def clientHandler(self, conn, addr):
        print('%s: [NEW CONNECTION] %s' % (self.table.name, addr))
        
        connected = True
        while connected:
            msg_len = conn.recv(self.HEADER).decode(self.FORMAT)
            if msg_len:
                msg_len = int(msg_len)
                msg = conn.recv(msg_len).decode(self.FORMAT)
                msg = msg.split(';')

                # Handler for client messages
                if msg[0] == self.DISCONNECT:
                    connected = False
                elif msg[0] == self.ADD_PLAYER:
                    self.addPlayerHandler(msg, addr)
                elif msg[0] == self.START_GAME:
                    self.startGameHandler()
                # elif msg[0] == self.CLOSE_TABLE:
                #     self.closeTableHandler()
                else:
                    print('%s: [NO HANDLER] %s' % (self.table.name, msg[0]))

                print('%s: [%s] %s' % (self.table.name, addr, msg))

        conn.close()

    def gameInstance(self):
        # Create new Table object
        print('%s: [STARTING]' % self.table.name)
        
        # Create a TCP/IP socket
        gameServer = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

        # Bind the socket to the port
        server_address = (self.SERVER, self.PORT)
        print('%s: [STARTING UP] %s, port: %s' % (self.table.name, server_address[0], server_address[1]))
        try:
            gameServer.bind(server_address)
        except socket.error as e:
            print(str(e))

        # Listen for incoming connections
        gameServer.listen(10)

        game_open = 1
        while game_open:
            # Wait for connection
            print('%s: [WAITING FOR CONNECTION] port: %s' % (self.table.name, self.table.port))
            conn, client_address = gameServer.accept()
            self.connections.append(conn)
            clientThread = Thread(target=self.clientHandler, args=(conn,client_address))
            clientThread.start()

        print('[ENDING GAME INSTANCE]')
