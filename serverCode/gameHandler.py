from Table import Table
from time import sleep

def gameInstance(owner, name, port):
    table = Table(owner,name,port)
    
    while True:
        print(table.getOwner())
        sleep(5)