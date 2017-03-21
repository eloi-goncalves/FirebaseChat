//
//  Extensions.swift
//  Chat
//
//  Created by Eloi Andre Goncalves on 19/03/17.
//  Copyright © 2017 Eloi Andre Goncalves. All rights reserved.
//

import UIKit

let imageCache  = NSCache<AnyObject, AnyObject>()

extension UIImageView {

    func loadImageUsingCacheWithUrlString(urlString : String){

        //check chache for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        let url = URL(string: urlString)
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if  error != nil {
                print(error)
                return
            }
        
            if let downloadedImage = UIImage(data: data!) {
                imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
            }
            
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
            
            
        }).resume()
    }
}
