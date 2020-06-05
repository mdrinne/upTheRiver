# Matt Rinne 6/3/2020
# Player class

class Player:
    def __init__(self, address, nickname, uid):
        self.address = address
        self.nickname = nickname
        self.uid = uid
        self.hand = []