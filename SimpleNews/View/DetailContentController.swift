//
//  DetailContentController.swift
//  SimpleNews
//
//  Created by Raditya Kurnianto on 3/27/19.
//  Copyright © 2019 raditya. All rights reserved.
//

import UIKit

class DetailContentController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var news: News?
    var pageIndex: Int?
    var viewModel = DetailContentViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cell: ContentCell.self)
        tableView.reloadData()
    }
    
    func bookmark() -> Void {
        if let item = news {
            viewModel.bookmark(news: item) { (msg) in
                let alert = UIAlertController(title: "Bookmark", message: msg, preferredStyle: .alert)
                let defaultAlert = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alert.addAction(defaultAlert)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension DetailContentController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(indexPath: indexPath) as ContentCell
        if let content = news {
            cell.setNewsContent(news: content)
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}

extension DetailContentController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
