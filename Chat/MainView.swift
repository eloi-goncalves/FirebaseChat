//
//  ViewController.swift
//  Chat
//
//  Created by Eloi Andre Goncalves on 13/03/17.
//  Copyright © 2017 Eloi Andre Goncalves. All rights reserved.
//

import UIKit
import Firebase

class MainView: UITableViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(self.handleLogout))
        
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
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

