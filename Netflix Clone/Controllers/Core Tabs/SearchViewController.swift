//
//  SearchViewController.swift
//  Netflix Clone
//
//  Created by oeng hokleng on 16/3/23.
//

import UIKit

class SearchViewController: UIViewController {

    private var discoverMovies: [Title] = [] {
        didSet {
            DispatchQueue.main.async {
                self.discoverTable.reloadData()
            }
        }
    }
    
    private let discoverTable: UITableView = {
        let tableView = UITableView()
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.cellIdentifier)
        
        return tableView
    }()

    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultViewController())
        controller.searchBar.placeholder = "Search for a Movie or a Tv show"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Search"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(discoverTable)
        
        discoverTable.delegate = self
        discoverTable.dataSource = self
        
        
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .white
        fetchDiscoverMovies()
        
        searchController.searchResultsUpdater = self

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        discoverTable.frame = view.bounds
    }
    
    private func fetchDiscoverMovies() {
        APICaller.shared.getDiscoverMovies { result in
            switch result {
            case .success(let movies):
                self.discoverMovies = movies
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}


// MARK: - Data Manipulations
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discoverMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.cellIdentifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        let title =  discoverMovies[indexPath.row].original_title ?? "Unknow"
        let posterPath =  discoverMovies[indexPath.row].poster_path ?? ""
        
        let model = TitleViewModel(titleName: title, poster_path: posterPath)
        cell.configure(with: model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let movie = discoverMovies[indexPath.row]
        guard let movieTitle = movie.original_title else {
            return
        }
        
        APICaller.shared.getMovie(with: movieTitle) { [weak self] result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    vc.configure(with: TitlePreviewViewModel(title: movieTitle, overview: movie.overview, youtubeView: videoElement))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription )
            }
        }
    }
    
}

//MARK: - UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchBar = searchController.searchBar
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultViewController else {
            return
        }
        
        resultsController.delegate = self
        
        APICaller.shared.search(with: query) { result in
            switch result {
            case .success(let titles):
                resultsController.titles = titles
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
}

//MARK: - SearchResultViewControllerDelegate
extension SearchViewController: SearchResultViewControllerDelegate {
    func searchResultViewControllerDidTapItem(_ view: SearchResultViewController, viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
