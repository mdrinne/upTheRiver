# Matt Rinne 6/3/2020
# Table class
import datetime
import random

newDeck = [('1','H'),('1','D'),('1','S'),('1','C'),('2','H'),('2','D'),('2','S'),('2','C'),('3','H'),('3','D'),('3','S'),('3','C'),('4','H'),('4','D'),('4','S'),('4','C'),('5','H'),('5','D'),('5','S'),('5','C'),('6','H'),('6','D'),('6','S'),('6','C'),('7','H'),('7','D'),('7','S'),('7','C'),('8','H'),('8','D'),('8','S'),('8','C'),('9','H'),('9','D'),('9','S'),('9','C'),('10','H'),('10','D'),('10','S'),('10','C'),('11','H'),('11','D'),('11','S'),('11','C'),('12','H'),('12','D'),('12','S'),('12','C'),('13','H'),('13','D'),('13','S'),('13','C')]

class Table:
    def __init__(self, owner, name, port):
        self.owner = owner
        self.name = name
        self.deck = []
        self.deckCount = 0
        self.players = []
        self.playerCount = 0
        self.port = port
        self.round = 1
        self.playerIndex = 0
        self.playerQueue = []
        self.playerQueueCount = 0
        self.cardTracker = {}
        self.inProgress = False
        self.lastUpdate = datetime.datetime.now()

    def getRandomCard(self):
        return deck.pop(random.randint(0, self.deckCount))

    def setNewDeck(self):
        self.deck = newDeck
        self.deckCount = 52
        self.lastUpdate = datetime.datetime.now()

    def addPlayer(self, new_player):
        self.players.append(new_player)
        self.playerCount += 1
        self.lastUpdate = datetime.datetime.now()

    def addPlayerToQueue(self, new_player):
        self.playerQueue.append(new_player)
        self.playerQueueCount += 1
        self.lastUpdate = datetime.datetime.now()

    def newTracker(self):
        self.cardTracker = {'1': [], '2': [], '3': [], '4': [], '5': [], '6': [], '7': [], '8': [], '9': [], '10': [], '11': [], '12': [], '13': []}
    
    def startGame(self):
        self.setNewDeck()
        self.inProgress = True
        self.round = 1
        self.newTracker()
        self.lastUpdate = datetime.datetime.now()
    
    def whoseTurn(self):
        return self.players[self.playerIndex]
