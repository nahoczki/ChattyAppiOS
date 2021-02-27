//
//  ChatRoomViewController.swift
//  ChattyApp
//
//  Created by Zoli Nahoczki on 10/14/20.
//

import UIKit

class ChatRoomViewController: UITableViewController {
    
    var chatRoom : ChatRoom!
    var loggedUser : User?
    
    let recipientCellId = "recipient"
    let senderCellId = "sender"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loggedUser = realmHandler.objects(User.self)[0]
        
        tableView.register(RecipientCell.self, forCellReuseIdentifier: recipientCellId)
        tableView.register(SenderCell.self, forCellReuseIdentifier: senderCellId)
        
        NotificationCenter.default.addObserver(self, selector: #selector(newMessage(notification:)), name: NSNotification.Name("MESSAGE"), object: nil)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
    }
    
    @objc func newMessage(notification: NSNotification) {
        print("new message")
        
        if let message = notification.userInfo?["message"] as? Message {
            self.chatRoom.messages.append(message)
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return chatRoom.messages.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = chatRoom.messages[indexPath.row]
        
        //print(message.user.id)
        //print(user.id)
        
        if message.userId != loggedUser!.id {
            let cell = tableView.dequeueReusableCell(withIdentifier: recipientCellId, for: indexPath) as! RecipientCell
            print(recipientCellId)
            cell.messageLabel.text = message.content

            return cell
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: senderCellId, for: indexPath) as! SenderCell
        
        cell.messageLabel.text = message.content
        print("sender")
        // Configure the cell...

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
