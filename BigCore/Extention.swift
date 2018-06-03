//
//  Extention.swift
//  BigCore
//
//  Created by Sukumar Anup Sukumaran on 03/06/18.
//  Copyright © 2018 TechTonic. All rights reserved.
//

import Foundation
import UIKit


let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func loadImage(_ URLString: String, placeHolder: UIImage?) {
        
        self.image = nil
        
        if let cacheImage = imageCache.object(forKey: NSString(string: URLString)){
            
            self.image = cacheImage
            return
        }
        
        if let url = URL(string: URLString) {
            
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard error == nil else {
                    DispatchQueue.main.async {
                        self.image = placeHolder
                    }
                    return print("ERROR LOADING IMAGES FROM URL: \(error!.localizedDescription)")}
                
                
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadImage = UIImage(data: data) {
                            imageCache.setObject(downloadImage, forKey: NSString(string: URLString))
                            self.image = downloadImage
                        }
                    }
                }
                
                
        
            }.resume()
            
        }
        
    }
    
}

