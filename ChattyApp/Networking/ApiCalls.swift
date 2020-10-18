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
                    
                    userArr.append(User(id: id, firstName: fName, lastName: lName))
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
}
