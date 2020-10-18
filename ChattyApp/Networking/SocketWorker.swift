//
//  SocketManager.swift
//  ChattyApp
//
//  Created by Zoli Nahoczki on 10/16/20.
//

import Foundation
import SocketIO
import SwiftyJSON


class SocketWorker {

    static let shared = SocketWorker()
    var socket: SocketIOClient!

    let manager = SocketManager(socketURL: URL(string: "https://chatter-app-backend.herokuapp.com")!, config: [.log(true), .compress])

    private init() {
        socket = manager.defaultSocket
    }

    func connectSocket(completion: @escaping(Bool) -> () ) {
        disconnectSocket()
        setSocketEvents()
        socket.connect()
        
        
    }
    
    private func setSocketEvents() {

        self.socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
            self.socket.emit("joinRoom", "{ \"roomId\" : \"1223344\", \"userId\" : \"1234\" }")
            //self.socket.emit("newMessage")
            
        }

        self.socket.on("newMessage") {data, ack in
            
            let parsedData = JSON(data[0])
            
            print("received data: \(parsedData["message"])")
            //Do something with data
        }
    }

    func disconnectSocket() {
        socket.removeAllHandlers()
        socket.disconnect()
        print("socket Disconnected")
    }

    func checkConnection() -> Bool {
        if socket.manager?.status == .connected {
            return true
        }
        return false

    }
}


