//
//  Placeholders.swift
//  ChattyApp
//
//  Created by Zoli Nahoczki on 10/14/20.
//

import Foundation

struct ChatUser {
    var id : String
    var firstName : String
    var lastName : String
}

struct Message {
    var id : String
    var user : ChatUser
    var content : String
    var date : Date
}

struct ChatRoom {
    var id : String
    var recipient : ChatUser
    var messages : Array<Message>
}

struct User {
    var id : String
    var firstName : String
    var lastName : String
}

let user = User(id: "1", firstName: "zoli", lastName: "ye")

let zoli = ChatUser(id: "1", firstName: "Zoli", lastName: "Nahoczki")
let john = ChatUser(id: "2", firstName: "John", lastName: "Doe")

let chatRooms : Array<ChatRoom> = [
    ChatRoom(id: "1", recipient: john, messages: [
        Message(id: "1", user: zoli, content: "Hi", date: Date()),
        Message(id: "2", user: john, content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", date: Date())
    ])

]
