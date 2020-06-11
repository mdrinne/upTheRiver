# Matt Rinne 6/3/2020
# Player class

class Player:
    def __init__(self, uid, nickname, fullName, address):
        self.uid = uid
        self.nickname = nickname
        self.fullname = fullName
        self.hand = ['none', 'none', 'none', 'none']
        self.address = address
    
    def getUid(self):
        return self.uid
    
    def clearHand(self):
        self.hand = ['none', 'none', 'none', 'none']
    
    def addToHand(self, card):
        self.hand.append(card)