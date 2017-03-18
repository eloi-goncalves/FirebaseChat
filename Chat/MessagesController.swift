//
//  ViewController.swift
//  Chat
//
//  Created by Eloi Andre Goncalves on 13/03/17.
//  Copyright © 2017 Eloi Andre Goncalves. All rights reserved.
//

import UIKit
import Firebase

class MessagesController: UITableViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(self.handleLogout))
        
        let imageButton = UIImage(named: "ic_border_color")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: imageButton , style: .plain, target: self, action: #selector(handleNewMessage))
    
        checkIfUserIsLogged()
    }
    
    func handleNewMessage(){
        let newMessageController = NewMessages()
        
        let navMessageController = UINavigationController(rootViewController: newMessageController)
        present(navMessageController, animated: true, completion: nil)
    }
    
    
    func checkIfUserIsLogged(){
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            let uid = FIRAuth.auth()?.currentUser?.uid
            
            FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dic = snapshot.value as? [String:AnyObject] {
                    self.navigationItem.title = dic["name"] as? String
                }
                
            }, withCancel: nil)
            
            FIRDatabase.database().reference().child("users").observeSingleEvent(of: .value, with: { (snapshots) in
                print(snapshots)
            }, withCancel: nil)
            
            
        }
    }
    
    
    func handleLogout(){
        
        do {
            try FIRAuth.auth()?.signOut()
        } catch  let logoutError{
                print(logoutError)
        }
        
        let loginController = Login()
        
        present(loginController, animated: true, completion: nil)
    }

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
        
    }
    
}

extension UIColor {

    convenience init(r : CGFloat, g : CGFloat, b : CGFloat){
        self.init(red : r/255, green : g/255,  blue: b/255 , alpha: 1)
    }
}

