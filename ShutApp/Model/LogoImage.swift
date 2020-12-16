//
//  LogoImage.swift
//  ShutApp
//
//  Created by Alexander Jansson on 2020-12-15.
//  Copyright © 2020 ShutAppOrg. All rights reserved.
//

import Foundation
import UIKit

class LogoIMage {
    
    
    static func downloadImage(withURL url:URL, completion: @escaping(_ image:UIImage?)->()){
        let dataTask = URLSession.shared.dataTask(with: url) { data, url, error in
            var downloadImage: UIImage?
            
            if let data = data {
                downloadImage = UIImage(data: data)
            }
            DispatchQueue.main.async{
                completion(downloadImage)
            }
        }
        dataTask.resume()
    }
}
