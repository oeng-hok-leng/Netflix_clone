//
//  HeroHeaderView.swift
//  Netflix Clone
//
//  Created by oeng hokleng on 16/3/23.
//

import UIKit
import SDWebImage

class HeroHeaderView: UIView {

    
    //MARK: - Sub View
    private let heroImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.image = UIImage(named: "demon-slayer")
        
        return imageView
    }()
    
    private let playButton: UIButton = {
        
        let button = UIButton()
       
        let image = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18))
        
        button.setAttributedTitle(
            NSAttributedString(
                string: "Play",
                attributes: [
                    .font : UIFont.systemFont(ofSize: 18,weight: .medium),
                    .foregroundColor: UIColor.black,
                    
                ]
            ),
            for: .normal
)
        button.backgroundColor = .white
        button.setImage(image, for: .normal)
        button.tintColor = .black
        
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)

        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        
        return button
    }()
    
    private let addtoListButton: UIButton = {
        
        let button = UIButton()
       
        let image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold))
        
            button.setAttributedTitle(
                NSAttributedString(
                    string: "Download",
                    attributes: [
                        .font : UIFont.systemFont(ofSize: 18,weight: .medium),
                        .foregroundColor: UIColor.white,
                        
                    ]
                ),
                for: .normal
    )
        button.backgroundColor = .systemGray
        button.setImage(image, for: .normal)
        button.tintColor = .white
        
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)

        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        
        return button
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(heroImageView)
       
        addGradient()
        
        addSubviews(playButton, addtoListButton)
        
        addConstraint()
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupport")
    }
    
    
    //MARK: - Private
    private func addConstraint() {
        let width = bounds.width - 40
        let buttonWidth:CGFloat =  ((width - 30 ) / 2)
        
        NSLayoutConstraint.activate([
            
            // Hero Image View
            heroImageView.widthAnchor.constraint(equalToConstant: width),
            heroImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            heroImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            heroImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Play Button
            playButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            playButton.heightAnchor.constraint(equalToConstant: 36),
            playButton.leftAnchor.constraint(equalTo: heroImageView.leftAnchor , constant: 10),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            
            // AddToList Button
            addtoListButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            addtoListButton.heightAnchor.constraint(equalToConstant: 36),
            addtoListButton.rightAnchor.constraint(equalTo: heroImageView.rightAnchor , constant: -10),
            addtoListButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            
        ])
    }
    
    private func addGradient() {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.withAlphaComponent(0.7).cgColor
        ]
        
        gradient.frame = bounds
        
        layer.addSublayer(gradient)
    }
    
    public func configure(with model: TitleViewModel) {
        guard let url = URL(string: model.poster_urlString) else { return }
        heroImageView.sd_setImage(with: url)
    }

}
