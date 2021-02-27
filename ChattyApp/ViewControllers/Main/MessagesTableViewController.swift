//
//  MessagesTableViewController.swift
//  ChattyApp
//
//  Created by Zoli Nahoczki on 10/13/20.
//

import UIKit

class ChatRoomCell : UITableViewCell {
    
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var recipientName: UILabel!
    @IBOutlet weak var recentMessageLabel: UILabel!
    
    var chatRoom : ChatRoom?
    
}

class MessagesTableViewController: UITableViewController {
    
    var loggedUser : User?

    var chatRooms : Array<ChatRoom> = []
    let api = ApiCalls()
    //let socket = SocketWorker.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        loggedUser = realmHandler.objects(User.self)[0]
//        socket.connectSocket { [self] (b) in
//            print(b)
//            
//        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.api.getRooms { (rooms, err) in
            if let err = err {
                print(err)
            }
            
            self.chatRooms = rooms
            self.tableView.reloadData()
            
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return chatRooms.count
    }
    
    @IBAction func logoutPress(_ sender: Any) {
        
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel,handler: {action in}))
        alert.addAction(UIAlertAction(title: "Yes", style: .default,handler: { action in
            
            UserDefaults.standard.removeObject(forKey: "jwt-token")
            self.loggedUser!.deleteFromRealm()
            let rootController = UIStoryboard(name: "Authentication", bundle: Bundle.main).instantiateInitialViewController()
            rootController!.modalPresentationStyle = .fullScreen
            self.present(rootController!, animated: false, completion: nil)
            
        }))
        self.present(alert, animated: true)
        
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "room", for: indexPath) as! ChatRoomCell
        
        let room = chatRooms[indexPath.row]
        let recipient = room.getRecipient(loggedUser: loggedUser!)
        
        cell.chatRoom = room
        
        cell.recipientName.text = "\(recipient!.firstName) \(recipient!.lastName)"
        
        //Array might be empty, handle
        let recentMessage = room.messages.last
        if let recentMessage = recentMessage {
            let recentMessageUser = room.getUser(recentMessage.userId)
            
            cell.recentMessageLabel.text = "\(recentMessageUser!.firstName): \(recentMessage.content)"
        }

        let url = URL(string: "https://ui-avatars.com/api/?name=\(recipient!.firstName)+\(recipient!.lastName)")!
        
        cell.avatarView.load(url: url)
        cell.avatarView.layer.cornerRadius = cell.avatarView.frame.height / 2

        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "chatRoom", sender: self)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let dest = segue.destination as? SendBarViewController {
            dest.chatRoom = chatRooms[self.tableView.indexPathForSelectedRow!.row]
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
