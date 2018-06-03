//
//  CoreTableViewCell.swift
//  BigCore
//
//  Created by Sukumar Anup Sukumaran on 03/06/18.
//  Copyright © 2018 TechTonic. All rights reserved.
//

import UIKit

class CoreTableViewCell: UITableViewCell {

    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var taglabel: UILabel!
    
    @IBOutlet weak var imgView: UIImageView!
    
    
    @IBOutlet weak var textViewCon: UITextView!
    
    
    func configure(apiData: APIData) {
        
        DispatchQueue.main.async {
            
            self.authorLabel.text = apiData.author
            self.taglabel.text = apiData.tags
            self.textViewCon.text = apiData.tags
            
            if let url = apiData.media {
                self.imgView.loadImage(url,placeHolder:UIImage(named: "placeholder"))
            }
            
        }
        
    }
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
