//
//  SendBarViewController.swift
//  ChattyApp
//
//  Created by Zoli Nahoczki on 10/22/20.
//

import UIKit

class SendBarViewController: UIViewController {
    
    @IBOutlet weak var messageBoxField: UITextField!
    
    
    var chatRoom : ChatRoom!
    var loggedUser : User?
    
    let socket = SocketWorker.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        loggedUser = realmHandler.objects(User.self)[0]
        
        let messagesView = self.children.last as! ChatRoomViewController
        messagesView.chatRoom = self.chatRoom
        messagesView.tableView.reloadData()
        
        for user in chatRoom.users {
            if user.id != loggedUser!.id {
                self.title = user.firstName + " " + user.lastName
            }
        }
        
        socket.connectSocket(userId: loggedUser!.id, roomId: chatRoom.id) { (b) in }
        
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendButton(_ sender: Any) {
        
        socket.sendMessage(roomId: chatRoom.id, userId: loggedUser!.id, message: messageBoxField.text!)
        
        messageBoxField.text = ""
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        socket.disconnectSocket()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
