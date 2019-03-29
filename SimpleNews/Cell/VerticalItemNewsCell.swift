//
//  VerticalItemNewsCell.swift
//  SimpleNews
//
//  Created by Raditya Kurnianto on 3/27/19.
//  Copyright © 2019 raditya. All rights reserved.
//

import UIKit

class VerticalItemNewsCell: UICollectionViewCell, RWGenericReusable {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var snippetLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setContent(news: News) -> Void {
        if let imageUrl = news.imageUrl {
            thumbnailImageView.setImageWith(urlString: imageUrl, placeholder: UIImage(named: "placeholder")!)
        }
        
        if let title = news.title {
            titleLabel.text = title
        }
        
        if let snippet = news.snippet {
            snippetLabel.text = snippet
        }
        
        if let date = news.date {
            dateLabel.text = date
        }
    }
}
