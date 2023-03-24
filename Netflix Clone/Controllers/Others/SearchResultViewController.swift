//
//  SearchResultViewController.swift
//  Netflix Clone
//
//  Created by oeng hokleng on 21/3/23.
//

import UIKit

protocol SearchResultViewControllerDelegate: AnyObject {
    func searchResultViewControllerDidTapItem(_ view: SearchResultViewController, viewModel: TitlePreviewViewModel)
}

class SearchResultViewController: UIViewController {

    weak var delegate: SearchResultViewControllerDelegate?
    
    public var titles: [Title] = [] {
        didSet {
            DispatchQueue.main.async {
                self.searchResultsCollectionView.reloadData()
            }
        }
    }
    
    private let searchResultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10 , height: 200)
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.cellIdentifier)
        
        return collectionView
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGreen
        view.addSubview(searchResultsCollectionView)
        
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultsCollectionView.frame = view.bounds
    }
    
    
    

}

extension SearchResultViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.cellIdentifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: titles[indexPath.row].poster_path ?? "")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let movie = titles[indexPath.row]
        guard let movieTitle = movie.original_title else {
            return
        }
        
        APICaller.shared.getMovie(with: movieTitle) { [weak self] result in
            switch result {
            case .success(let videoElement):
                
                guard let strongSelf = self else {return}
                self?.delegate?.searchResultViewControllerDidTapItem(strongSelf, viewModel: TitlePreviewViewModel(title: movieTitle, overview: movie.overview, youtubeView: videoElement))
                
            case .failure(let error):
                print(error.localizedDescription )
            }
        }
        
    }
    
    
    
}
