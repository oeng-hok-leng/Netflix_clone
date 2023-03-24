//
//  TitleTableViewCell.swift
//  Netflix Clone
//
//  Created by oeng hokleng on 20/3/23.
//

import UIKit

class TitleTableViewCell: UITableViewCell {

    static let cellIdentifier = "TitleTableViewCell"
    
    private let playTitleButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30)), for: .normal)
        
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
    }()
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
        
    }()
    
    private let titlePosterImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubviews(titleLabel, titlePosterImageView, playTitleButton)
        
        addConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        titlePosterImageView.image = nil
    }
    
    private func addConstraint() {
        NSLayoutConstraint.activate([
            // Poster
            titlePosterImageView.widthAnchor.constraint(equalToConstant: 100),
            titlePosterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titlePosterImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
            titlePosterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
           
            // Title
            titleLabel.leftAnchor.constraint(equalTo: titlePosterImageView.rightAnchor, constant: 20),
            titleLabel.widthAnchor.constraint(equalToConstant: 200),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        
            // Button
            playTitleButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            playTitleButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
        ])
    }
    
    public func configure(with viewModel: TitleViewModel){
        guard let url = URL(string: viewModel.poster_urlString) else {
            return
        }
        titlePosterImageView.sd_setImage(with: url)
        titleLabel.text = viewModel.titleName
    }
}
