//
//  APIService.swift
//  BigCore
//
//  Created by Sukumar Anup Sukumaran on 03/06/18.
//  Copyright © 2018 TechTonic. All rights reserved.
//

import Foundation

enum Result <T>{
    case Success(T)
    case Error(String)
}

class APIService: NSObject {
    
    
    static var endPoint: String = {
        return "https://api.flickr.com/services/feeds/photos_public.gne?format=json&tags=dogs&nojsoncallback=1#"
        
    }()
    
  static  func getDataWith(completion: @escaping (Result<[[String: AnyObject]]>) -> Void) {
        
        guard let url = URL(string: endPoint) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {return}
            guard let data = data else {return}
            
            do{
                if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: AnyObject] {
                    
                    guard let itemArray = json["items"] as? [[String: AnyObject]] else {
                        return
                    }
                    
                    DispatchQueue.main.async {
                        completion(.Success(itemArray))
                    }
                    
                }
            }catch let error {
                return completion(.Error(error.localizedDescription))
            }
        }.resume()
        
    }
    
}
