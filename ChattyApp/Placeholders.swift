//
//  Placeholders.swift
//  ChattyApp
//
//  Created by Zoli Nahoczki on 10/14/20.
//

import Foundation
import SwiftyJSON

struct ChatUser {
    var id : String
    var firstName : String
    var lastName : String
    
    init(_ chatUser : JSON) {
        self.id = chatUser["_id"].string!
        self.firstName = chatUser["firstname"].string!
        self.lastName = chatUser["lastname"].string!
    }

}

struct Message {
    var userId : String
    var content : String
    
    init(_ message : JSON) {
        self.userId = message["userId"].string!
        self.content = message["content"].string!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
    }
    
    init(userId : String, contents: String) {
        self.userId = userId
        self.content = contents
    }
}

struct ChatRoom {
    var id : String
    var users : Array<ChatUser>
    var messages : Array<Message>
    
    init(_ chatRoom : JSON) {
        self.id = chatRoom["_id"].string!
        self.users = []
        self.messages = []
        
        let givenUsers = chatRoom["users"].array!
        let givenMessages = chatRoom["messages"].array!
        
        for (user) in givenUsers {
            self.users.append(ChatUser(user))
        }
        
        for (message) in givenMessages {
            self.messages.append(Message(message))
        }
    }
    
    func getRecipient(loggedUser : User) -> ChatUser? {
        for user in self.users {
            if user.id != loggedUser.id {
                return user
            }
        }
        
        return nil
    }
    
    func getUser(_ id: String) -> ChatUser? {
        for user in self.users {
            if id != user.id {
                return user
            }
        }
        
        return nil
    }
}
