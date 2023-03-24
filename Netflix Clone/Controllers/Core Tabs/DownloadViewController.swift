//
//  DownloadViewController.swift
//  Netflix Clone
//
//  Created by oeng hokleng on 16/3/23.
//

import UIKit

class DownloadViewController: UIViewController {

    private var titles: [TitleItem] = [] {
        didSet {
            self.downloadedTable.reloadData()
        }
    }
    
    //MARK: - Sub views
    private let downloadedTable: UITableView = {
       let tableView = UITableView()
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.cellIdentifier)
//        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Downloads"
        
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        downloadedTable.delegate = self
        downloadedTable.dataSource = self
        
        view.addSubview(downloadedTable)
        
        fetchLocalStorageForDownload()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil ) { _ in
            self.fetchLocalStorageForDownload()
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        downloadedTable.frame = view.bounds
    }
    
    private func fetchLocalStorageForDownload() {
        DataPersistanceManager.shared.fetchingMoviesFromDataBase { [weak self]result in
            switch result {
            case .success(let movies):
                DispatchQueue.main.async {
                    self?.titles = movies
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}


extension DownloadViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.cellIdentifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        let title =  titles[indexPath.row].original_title ?? "Unknow"
        let posterPath =  titles[indexPath.row].poster_path ?? ""
        
        let model = TitleViewModel(titleName: title, poster_path: posterPath)
        cell.configure(with: model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            
            DataPersistanceManager.shared.deleteTitleWith(model: titles[indexPath.row]) { [weak self] result in
                switch result {
                case .success():
                    print("Deleted \(self?.titles[indexPath.row].original_title ?? "Unknown")")
                    self?.titles.remove(at: indexPath.row)
//                    tableView.deleteRows(at: [indexPath], with: .left)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }
            
            
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let movie = titles[indexPath.row]
        guard let movieTitle = movie.original_title else {
            return
        }
        
        APICaller.shared.getMovie(with: movieTitle) { [weak self] result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    vc.configure(with: TitlePreviewViewModel(title: movieTitle, overview: movie.overview ?? "", youtubeView: videoElement))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription )
            }
        }
    }
    
}
