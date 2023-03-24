//
//  TitlePreviewViewController.swift
//  Netflix Clone
//
//  Created by oeng hokleng on 21/3/23.
//

import UIKit
import WebKit

class TitlePreviewViewController: UIViewController {

    private let titleLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "Harry Potter"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.numberOfLines = 2
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let webView: WKWebView = {
        let webview = WKWebView()
        webview.translatesAutoresizingMaskIntoConstraints = false
        
        return webview
    }()
    
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubviews(titleLabel, overviewLabel, downloadButton, webView)
        
        
        addConstraint()
    }
    

    private func addConstraint() {
        NSLayoutConstraint.activate([
            
            // Preview Video
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leftAnchor.constraint(equalTo: view.leftAnchor),
            webView.rightAnchor.constraint(equalTo: view.rightAnchor),
            webView.heightAnchor.constraint(equalToConstant: 250),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            
            // Overview
            
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            overviewLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            overviewLabel.widthAnchor.constraint(equalToConstant: view.bounds.width - 40),
            
            // Download Button
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadButton.widthAnchor.constraint(equalToConstant: view.bounds.width - 40),
            downloadButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant:  25),
        ])
    }
    
    public func configure(with viewModel: TitlePreviewViewModel){
        titleLabel.text = viewModel.title
        overviewLabel.text = viewModel.overview
        
        
        guard let url = URL(string: "https://www.youtube.com/embed/\(viewModel.youtubeView.id.videoId)") else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.webView.load(URLRequest(url: url))
        }
        
    }
    
}
