//
//  UpcomingViewController.swift
//  Netflix Clone
//
//  Created by oeng hokleng on 16/3/23.
//

import UIKit

class UpcomingViewController: UIViewController {

    
    
    //MARK: - Sub views
    private let tableView: UITableView = {
       let tableView = UITableView()
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.cellIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    
    private var upcomingMovies: [Title] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Up Coming"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
    
        
        addConstraint()
            
        fetchUpcoming()
    }
    
    
    private func addConstraint() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func fetchUpcoming() {
        APICaller.shared.getUpComingMovies { result in
            switch result {
            case .success(let movies):
                DispatchQueue.main.async {
                    self.upcomingMovies = movies
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }

}

extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcomingMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.cellIdentifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        let title =  upcomingMovies[indexPath.row].original_title ?? "Unknow"
        let posterPath =  upcomingMovies[indexPath.row].poster_path ?? ""
        
        let model = TitleViewModel(titleName: title, poster_path: posterPath)
        cell.configure(with: model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let movie = upcomingMovies[indexPath.row]
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
