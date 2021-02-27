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

    func connectSocket(userId: String, roomId: String, completion: @escaping(Bool) -> () ) {
        disconnectSocket()
        setSocketEvents(userId: userId, roomId: roomId)
        socket.connect()
        
        completion(true)
    }
    
    private func setSocketEvents(userId: String, roomId: String) {

        self.socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
            //self.socket.emit("newMessage")
            self.joinRoom(userId: userId, roomId: roomId)
        }

        self.socket.on("newMessage") {data, ack in
            
            let parsedData = JSON(data[0])
            
            print("received data: \(parsedData["message"])")
            
            let msgObj : [String: Message] = [
                "message": Message(userId: parsedData["userId"].string!, contents: parsedData["message"].string!)
            ]
            
            NotificationCenter.default.post(name: NSNotification.Name("MESSAGE"), object: nil, userInfo: msgObj)
            //Do something with data
        }
    }
    
    func joinRoom(userId: String, roomId: String) {
        
        let obj = "{ \"roomId\" : \"\(roomId)\", \"userId\" : \"\(userId)\"}"
        
        self.socket.emit("joinRoom", obj)
        
    }
    
    func sendMessage(roomId: String, userId: String, message: String) {
        
        let obj = "{  \"roomId\" : \"\(roomId)\", \"userId\" : \"\(userId)\", \"message\" : \"\(message)\"}"
        
        self.socket.emit("sendMessage", obj)
        
        
        let msgObj : [String: Message] = [
            "message": Message(userId: userId, contents: message)
        ]
        
        NotificationCenter.default.post(name: NSNotification.Name("MESSAGE"), object: nil, userInfo: msgObj)
        
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


