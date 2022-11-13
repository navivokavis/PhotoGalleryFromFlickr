//
//  ImagesCollectionViewCell.swift
//  FlickrPhotoGallery
//
//  Created by Navi Vokavis on 6.11.22.
//

import UIKit

class ImagesCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ImagesCollectionViewCell"
    private var iconImageView = UIImageView()
    var customLoaderView = CustomLoaderView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(iconImageView)
        layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadImage(urlString: String) {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 64, height: 64)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        activityIndicator.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        self.addSubview(activityIndicator)
        contentMode = .scaleToFill
        self.iconImageView.image = nil
        
        DispatchQueue.global().async { [weak self] in
            guard let url = URL(string: urlString) else { return }
            guard let data = try? Data(contentsOf: url) else { return }
            DispatchQueue.main.async {
                self?.iconImageView.image = UIImage(data: data)
                activityIndicator.stopAnimating()
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconImageView.frame = contentView.bounds
        iconImageView.contentMode = .scaleAspectFit
        
    }
    
}

