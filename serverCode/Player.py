# Matt Rinne 6/3/2020
# Player class

class Player:
    def __init__(self, uid, nickname, fullName, address):
        self.uid = uid
        self.nickname = nickname
        self.fullname = fullName
        self.hand = []
        self.address = address