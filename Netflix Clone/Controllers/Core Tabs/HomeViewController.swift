//
//  HomeViewController.swift
//  Netflix Clone
//
//  Created by oeng hokleng on 16/3/23.
//

import UIKit

enum Sections: Int {
    case TrendingMoives = 0
    case TrendingTVs = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}


class HomeViewController: UIViewController {
    
    private var randomTrendingMovie: Title?
    private var headerView: HeroHeaderView?

    let sectionHeaderTitle: [String] = ["Treding Movies", "Trending Tv", "Popular" , "Upcoming Movie","Top Movies"]
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self , forCellReuseIdentifier: CollectionViewTableViewCell.cellIdentifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        
        setUpTableView()
        configureNavBar()
        configureHeroHeaderView()
        
        headerView = HeroHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width , height: view.bounds.height * 0.6))
        tableView.tableHeaderView = headerView
        
        
        addConstraint()
    }
    
    
    //MARK: - Private
    
    private func configureHeroHeaderView() {
        APICaller.shared.getTrendingMovies { [weak self] result in
            switch result {
            case .success(let movies):
                let randomMovie = movies.randomElement()
                self?.randomTrendingMovie = randomMovie
                self?.headerView?.configure(with: TitleViewModel(
                    titleName:randomMovie?.original_title ?? "Unknow" ,
                    poster_path: randomMovie?.poster_path ?? "")
                )
            case .failure(let error):
                print("error: \(error.localizedDescription)")
            }
        }
    }
    
    //MARK:  Configuration
    private func configureNavBar(){
        
        // Left Bar
        let label = UILabel()
        label.text = "For Your"
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .bold)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
        
        // Right Bar
        let beltIcon = UIImage(systemName: "bell.badge" , withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold))?.withTintColor(.white, renderingMode: .alwaysOriginal) ?? nil
        let searchIcon = UIImage(systemName: "magnifyingglass" , withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold))?.withTintColor(.white, renderingMode: .alwaysOriginal)
        
        let profileIcon = UIImage(systemName: "person" , withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold))?.withTintColor(.white, renderingMode: .alwaysOriginal)
        
        let beltBtn: UIButton = UIButton()
        beltBtn.setImage(beltIcon, for: .normal)
        beltBtn.addTarget(self, action: #selector(didTapNotification), for: .touchUpInside)
        beltBtn.frame = CGRectMake(0, 0, 30, 30)
        let beltBarBtn = UIBarButtonItem(customView: beltBtn)
        
        let searchBtn: UIButton = UIButton()
        searchBtn.setImage(searchIcon, for: .normal)
        searchBtn.addTarget(self, action: #selector(didTapSearch), for: .touchUpInside)
        searchBtn.frame = CGRectMake(0, 0, 30, 30)
        let searchBarBtn = UIBarButtonItem(customView: searchBtn)
        
        let profileBtn: UIButton = UIButton()
        profileBtn.setImage(profileIcon, for: .normal)
        profileBtn.addTarget(self, action: #selector(didTapSearch), for: .touchUpInside)
        profileBtn.frame = CGRectMake(0, 0, 30, 30)
        let profileBarBtn = UIBarButtonItem(customView: profileBtn)
        
        self.navigationItem.setRightBarButtonItems([profileBarBtn, searchBarBtn, beltBarBtn,], animated: false)
        
    }
    
    private func setUpTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    private func addConstraint() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
        ])
    }
    
    
    
    
    //MARK:  Actions
    
    @objc private func didTapProfile() {
        
    }
    
    @objc private func didTapSearch() {
        
    }
    @objc private func didTapNotification() {
        
    }


}


//MARK: - Table View Delegate and Data Source
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeaderTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.cellIdentifier, for: indexPath)
                as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        
        
        switch indexPath.section {
            case Sections.TrendingMoives.rawValue:
                APICaller.shared.getTopRateMovies { result in
                    switch result {
                    case .success(let movies):
                        cell.configure(with: movies)
                    case .failure(let error):
                        
                        // TODO: Handle Error laters...
                        print("\(error.localizedDescription)")
                    }
                }
                
            case Sections.TrendingTVs.rawValue:
                APICaller.shared.getTrendingMovies { result in
                    switch result {
                    case .success(let tvs):
                        cell.configure(with: tvs)
                    case .failure(let error):
                        
                        // TODO: Handle Error laters...
                        print("\(error.localizedDescription)")
                    }
                }
            case Sections.Popular.rawValue:
                APICaller.shared.getPopularMovies{ result in
                    switch result {
                    case .success(let movies):
                        cell.configure(with: movies)
                    case .failure(let error):
                        
                        // TODO: Handle Error laters...
                        print("\(error.localizedDescription)")
                    }
                }
            case Sections.Upcoming.rawValue:
                APICaller.shared.getUpComingMovies{ result in
                    switch result {
                    case .success(let movies):
                        cell.configure(with: movies)
                    case .failure(let error):
                        
                        // TODO: Handle Error laters...
                        print("\(error.localizedDescription)")
                    }
                }
                
            case Sections.TopRated.rawValue:
                APICaller.shared.getTopRateMovies { result in
                    switch result {
                    case .success(let movies):

                        cell.configure(with: movies)
                    case .failure(let error):
                        
                        // TODO: Handle Error laters...
                        print("\(error.localizedDescription)")
                    }
                }

            default:
                return UITableViewCell()
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {
            return
        }
        
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.capitalized
        
        
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaderTitle[section].capitalized
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        
        let offset = scrollView.contentOffset.y + defaultOffset
        
        
        
    }
}
extension HomeViewController: CollectionViewTableViewCellDelegate {
    
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel) {
        
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            vc.modalTransitionStyle = .coverVertical
            self?.navigationController?.pushViewController(vc, animated: true)
        }
       
    }
}
