//
//  CreateGame.swift
//  upTheRiver
//
//  Created by Matthew Rinne on 6/3/20.
//  Copyright © 2020 Matthew Rinne. All rights reserved.
//

import UIKit

class CreateGame: NSObject {
    
    var inputStream: InputStream!
    var outputStream: OutputStream!
    
    let maxReadLength = 4096
    
    func setupNetworkCommunication() {
        
        // Setup two uninitialized socket streams without automatic memory management
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        // Bind read and write socket streams together and connect them to the socket of the host
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, "localhost" as CFString, 25000, &readStream, &writeStream)
        
        // Grab a retained reference and burn an unbalanced retain so the memory isn't leaked later
        inputStream = readStream!.takeRetainedValue()
        outputStream = writeStream!.takeRetainedValue()
        
        // Add the streams to a run loop
        inputStream.schedule(in: .current, forMode: .common)
        outputStream.schedule(in: .current, forMode: .common)
        
        // Open the streams
        inputStream.open()
        outputStream.open()
    }
    
    func createTable(tableName: String) {
    }
}
