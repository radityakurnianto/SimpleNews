//
//  ViewController.swift
//  SimpleNews
//
//  Created by Raditya Kurnianto on 3/27/19.
//  Copyright © 2019 raditya. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var isPotrait = UIDevice.current.orientation.isPortrait
    var flowLayout = UICollectionViewFlowLayout()
    var numberOfContent = 0
    var viewModel = NewsfeedViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func deviceRotated(){
        isPotrait = !UIDevice.current.orientation.isLandscape
        adjustContent()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(cell: VerticalItemNewsCell.self)
        collectionView.register(cell: HorizontalItemNewsCell.self)
        collectionView.register(cell: LoadingCell.self)
        
        adjustContent()
        
        loadNews()
    }
    
    func loadNews() -> Void {
        viewModel.getNews { [weak self] in
            if let count = self?.viewModel.newsArray?.count { self?.numberOfContent = count }
            self?.collectionView.reloadData()
        }
    }
    
    
    func adjustContent() -> Void {
        print("orientation \(isPotrait)")
        
        if isPotrait {
            flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 100)
        } else {
            flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width / 5, height: 178)
        }
        
        collectionView.collectionViewLayout = flowLayout
        
        collectionView.reloadData()
    }

    
    func potraitCell(collectionView: UICollectionView, indexpath: IndexPath) -> VerticalItemNewsCell {
        let cell = collectionView.dequeueCell(indexPath: indexpath) as VerticalItemNewsCell
        if let content = viewModel.newsArray {
            cell.setContent(news: content[indexpath.row])
        }
        
        return cell
    }
    
    func landscapeCell(collectionView: UICollectionView, indexpath: IndexPath) -> HorizontalItemNewsCell {
        let cell = collectionView.dequeueCell(indexPath: indexpath) as HorizontalItemNewsCell
        
        if let content = viewModel.newsArray {
            cell.setContent(news: content[indexpath.row])
        }
        
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in collectionView.visibleCells {
            if cell.isKind(of: LoadingCell.self) {
                print("load_news")
                loadNews()
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        for cell in collectionView.visibleCells {
            if cell.isKind(of: LoadingCell.self) {
                print("load_news")
                loadNews()
            }
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? numberOfContent : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            return isPotrait ? potraitCell(collectionView: collectionView, indexpath: indexPath) : landscapeCell(collectionView: collectionView, indexpath: indexPath)
        }
        
        let cell = collectionView.dequeueCell(indexPath: indexPath) as LoadingCell
        cell.activityIndicator.startAnimating()
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "DetailParentController") as? DetailParentController else { return }
            controller.pageCount = numberOfContent
            controller.selectedIndex = indexPath.row
            controller.news = viewModel.newsArray
            
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
