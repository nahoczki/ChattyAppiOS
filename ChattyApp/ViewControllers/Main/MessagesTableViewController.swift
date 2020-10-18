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
    
    let socket = SocketWorker.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        socket.connectSocket { [self] (b) in
            print(b)
            
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return chatRooms.count
    }
    
    @IBAction func logoutPress(_ sender: Any) {
        
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel,handler: {action in}))
        alert.addAction(UIAlertAction(title: "Yes", style: .default,handler: { action in
            
            UserDefaults.standard.removeObject(forKey: "jwt-token")
            
            let rootController = UIStoryboard(name: "Authentication", bundle: Bundle.main).instantiateInitialViewController()
            rootController!.modalPresentationStyle = .fullScreen
            self.present(rootController!, animated: false, completion: nil)
            
        }))
        self.present(alert, animated: true)
        
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "room", for: indexPath) as! ChatRoomCell
        
        let room = chatRooms[indexPath.row]
        
        cell.chatRoom = room
        cell.recipientName.text = "\(room.recipient.firstName) \(room.recipient.lastName)"
        
        //Array might be empty, handle
        cell.recentMessageLabel.text = "\(room.messages.last?.user.firstName ?? ""): \(room.messages.last?.content ?? "")"

        let url = URL(string: "https://ui-avatars.com/api/?name=\(room.recipient.firstName)+\(room.recipient.lastName)")!
        
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
        
        if let dest = segue.destination as? ChatRoomViewController {
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
