//
//  User.swift
//  ChattyApp
//
//  Created by Zoli Nahoczki on 10/18/20.
//

import Foundation
import RealmSwift

let realmHandler = try! Realm()

class User: Object {
    @objc dynamic var id = ""
    @objc dynamic var firstName = ""
    @objc dynamic var lastName = ""
    @objc dynamic var email = ""
    var chatRooms = List<String>()
    
    
    
    func writeToRealm() {
        try! realmHandler.write {
            realmHandler.add(self)
        }
    }
    
    func deleteFromRealm() {
        try! realmHandler.write {
            realmHandler.delete(self)
        }
    }
}



