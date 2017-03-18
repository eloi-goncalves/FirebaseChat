//
//  NewMessages.swift
//  Chat
//
//  Created by Eloi Andre Goncalves on 16/03/17.
//  Copyright © 2017 Eloi Andre Goncalves. All rights reserved.
//

import UIKit
import Firebase

class NewMessages: UITableViewController {

    var users = [Users]()
    var usersImages = ["sandy", "gregory", "renato"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))

        tableView.register(UsersCell.self, forCellReuseIdentifier: "userCell")
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.headerView(forSection: 1)
        tableView.backgroundColor = UIColor.white
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        fetchUser()
    }
    
    func fetchUser() {
        
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            OperationQueue.main.addOperation {
                
                if let dictionary = snapshot.value as? [String:AnyObject] {
                    let user = Users(parameters: dictionary)
                    self.users.append(user)
                }
                self.tableView.reloadData()
            }
        }, withCancel: nil)
    }
    
    
    func handleCancel(){
        dismiss(animated: true, completion: nil)
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : UsersCell =  tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath as IndexPath) as! UsersCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        if   users.count > 0{
            cell.imageView?.image = UIImage(named: usersImages[indexPath.row])
            cell.textLabel?.text = users[indexPath.row].name
            cell.detailTextLabel?.text = users[indexPath.row].email
        }
        
        return cell
    }
    
    
}

class UsersCell : UITableViewCell {
    
    var username : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightRegular)
        label.textColor = UIColor(r: 33, g: 33, b: 33)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var email : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightRegular)
        label.textColor = UIColor(r: 158, g: 158, b: 158)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
   
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: "userCell")
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupCell(){
        
       self.backgroundColor = UIColor.white
       self.imageView?.layer.masksToBounds = true
       self.imageView?.layer.borderWidth = 1
       self.imageView?.layer.borderColor = UIColor(r: 232, g: 232, b: 232).cgColor
       self.imageView?.layer.cornerRadius = self.frame.height/2
        
    }

}

