//
//  ContentCell.swift
//  SimpleNews
//
//  Created by Raditya Kurnianto on 3/29/19.
//  Copyright © 2019 raditya. All rights reserved.
//

import UIKit

class ContentCell: UITableViewCell, RWGenericReusable {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var snippetLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setNewsContent(news: News) -> Void {
        titleLabel.text = news.title
        dateLabel.text = news.date
        snippetLabel.text = news.snippet
        
        if let imgUrl = news.imageUrl {
            thumbnailImageView.setImageWith(urlString: imgUrl, placeholder: UIImage(named: "placeholder")!)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
