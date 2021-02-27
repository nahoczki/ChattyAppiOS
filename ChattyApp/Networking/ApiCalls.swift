//
//  ApiCalls.swift
//  ChattyApp
//
//  Created by Zoli Nahoczki on 10/13/20.
//

import Foundation
import Alamofire
import SwiftyJSON

//https://chatter-app-backend.herokuapp.com/api/users/login

struct Error {
    var statusCode: Int
    var message: String
}

class ApiCalls {

    let api = "https://chatter-app-backend.herokuapp.com/api"
    //let api = "http://localhost:3000/api"
    
    
    func login(email: String, pass: String, completion : @escaping (Error?)->()) {
        let endpoint = api + "/auth/login"
        
        let parameters: [String: String] = [
            "email" : email,
            "password" : pass
        ]
        
        AF.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            switch (response.result) {
                case .success(let data):
                    let json = JSON(data)
                    
                    //Error, not 200 status code
                    if response.response?.statusCode != 200 {
                        print("Error not 200 Code")
                        completion(Error(statusCode: json["status"].int!, message: json["message"].string!))
                        return
                    }
                    
                    guard let token = response.response?.headers["auth-token"] else {
                        completion(Error(statusCode: 400, message: "Error Authenticating Request"))
                        return
                    }
                    
                    //Create user object
                    let user = User()
                    
                    user.email = json["email"].string!
                    user.firstName = json["firstname"].string!
                    user.lastName = json["lastname"].string!
                    user.id = json["_id"].string!
                    
                    for chatroom in json["chatrooms"].array! {
                        print(chatroom.string!)
                        user.chatRooms.append(chatroom.string!)
                    }
                        
                    //Save user locally
                    user.writeToRealm()
                        
                    
                    print(user)
                    
                    UserDefaults.standard.setValue(token, forKey: "jwt-token")
                    
                case .failure(let err):
                    print("error")
                    print(err)
                    completion(Error(statusCode: 404, message: "Internal Error"))
                    return
                    
            }
            completion(nil)
        }
    }
    
    func register(firstname: String, lastname: String, email: String, pass: String, completion : @escaping (Error?)->()) {
        let endpoint = api + "/auth/register"
        
        let parameters: [String: String] = [
            "firstname" : firstname,
            "lastname" : lastname,
            "email" : email,
            "password" : pass
        ]
        
        AF.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            switch (response.result) {
                case .success(let data):
                    let json = JSON(data)
                    
                    //Error, not 200 status code
                    if response.response?.statusCode != 200 {
                        print("Error not 200 Code")
                        completion(Error(statusCode: json["status"].int!, message: json["message"].string!))
                        return
                    }
                    
                    completion(nil)
                    
                case .failure(let err):
                    print("error")
                    print(err)
                    completion(Error(statusCode: 404, message: "Internal Error"))
                    return
                    
            }
            completion(nil)
        }
    }
    
    func getUsers(completion : @escaping (Array<User>, Error?)->()) {
        let endpoint = api + "/users"
        
        let headers = HTTPHeaders([
            "auth-token" : UserDefaults.standard.string(forKey: "jwt-token") ?? ""
        ])
        
        AF.request(endpoint, method: .get, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            
            switch (response.result) {
            case .success(let data):
                let json = JSON(data)
                
                //Error, not 200 status code
                if response.response?.statusCode != 200 {
                    print("Error not 200 Code")
                    completion([], Error(statusCode: json["status"].int!, message: json["message"].string!))
                    return
                }
                
                var userArr : Array<User> = []
                
                for user in json["users"].array! {
                    let id = user["_id"].string!
                    let fName = user["firstname"].string!
                    let lName = user["lastname"].string!
                    
                    let user = User()
                    
                    user.firstName = fName
                    user.lastName = lName
                    user.id = id
                    
                    userArr.append(user)
                }
                
                completion(userArr, nil)
                return
                
                
            case .failure(let err):
                print("error")
                print(err)
                completion([], Error(statusCode: 404, message: "Internal Error"))
                return
            
            }
            
        }
    }
    
    func getRooms(completion : @escaping (Array<ChatRoom>, Error?)->()) {
        let endpoint = api + "/rooms"
        
        let headers = HTTPHeaders([
            "auth-token" : UserDefaults.standard.string(forKey: "jwt-token") ?? ""
        ])
        
        AF.request(endpoint, method: .get, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            
            switch (response.result) {
            case .success(let data):
                let json = JSON(data)
                
                //Error, not 200 status code
                if response.response?.statusCode != 200 {
                    print("Error not 200 Code")
                    completion([], Error(statusCode: json["status"].int!, message: json["message"].string!))
                    return
                }
                print(json)
                var roomArr : Array<ChatRoom> = []
                
                for room in json["chatrooms"].array! {
                    roomArr.append(ChatRoom(room))
                }
                
                completion(roomArr, nil)
                return
                
                
            case .failure(let err):
                print("error")
                print(err)
                completion([], Error(statusCode: 404, message: "Internal Error"))
                return
            
            }
            
        }
    }
    
    func createRoom(with: String, completion : @escaping (Error?)->()) {
        let endpoint = api + "/rooms"
        
        let headers = HTTPHeaders([
            "auth-token" : UserDefaults.standard.string(forKey: "jwt-token") ?? ""
        ])
        
        print(with)
        
        let parameters: [String : String] = [
            "recipient" : with
        ]
        
        AF.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch (response.result) {
            case .success(let data):
                let json = JSON(data)
                
                //Error, not 200 status code
                if response.response?.statusCode != 200 {
                    print("Error not 200 Code")
                    completion(Error(statusCode: json["status"].int!, message: json["message"].string!))
                    return
                }
                
                completion(nil)
                return
                
                
            case .failure(let err):
                print("error")
                print(err)
                completion(Error(statusCode: 404, message: "Internal Error"))
                return
            
            }
            
        }
    }
}
