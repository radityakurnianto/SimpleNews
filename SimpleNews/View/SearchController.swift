//
//  SearchController.swift
//  SimpleNews
//
//  Created by Raditya Kurnianto on 3/28/19.
//  Copyright © 2019 raditya. All rights reserved.
//

import UIKit

class SearchController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    var isPotrait = UIDevice.current.orientation.isPortrait
    var flowLayout = UICollectionViewFlowLayout()
    var numberOfContent = 0
    var viewModel = SearchViewModel()
    
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
        searchBar.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(cell: VerticalItemNewsCell.self)
        collectionView.register(cell: HorizontalItemNewsCell.self)
        collectionView.register(cell: LoadingCell.self)
        
        adjustContent()
        
        viewModel.purgeOldSearchResult()
    }
    
    func adjustContent() -> Void {
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
}

extension SearchController: UICollectionViewDataSource {
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
        return 1
    }
}

extension SearchController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "DetailParentController") as? DetailParentController else { return }
            controller.pageCount = numberOfContent
            controller.selectedIndex = indexPath.row
            
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

extension SearchController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text else { return }
        
        viewModel.purgeOldSearchResult()
        viewModel.searchNews(keyword: keyword) { [weak self] in
            if let count = self?.viewModel.newsArray?.count { self?.numberOfContent = count }
            self?.collectionView.reloadData()
        }
    }
}
