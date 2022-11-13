//
//  FullScreenCollectionViewCell.swift
//  FlickrPhotoGallery
//
//  Created by Navi Vokavis on 7.11.22.
//

import UIKit

class FullScreenCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "FullScreenCollectionViewCell"
    private var fullScreenImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(fullScreenImageView)
        layoutSubviews()
    }
      
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - func to load image with activity indicator
    func loadImage(urlString: String) {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 64, height: 64)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        activityIndicator.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        self.addSubview(activityIndicator)
        contentMode = .scaleToFill
        self.fullScreenImageView.image = nil
        
        DispatchQueue.global().async { [weak self] in
            guard let url = URL(string: urlString) else { return }
            
            guard let data = try? Data(contentsOf: url) else { return }
            DispatchQueue.main.async {
                
                self?.fullScreenImageView.image = UIImage(data: data)
                activityIndicator.stopAnimating()
                print(data)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        fullScreenImageView.frame = contentView.bounds
        fullScreenImageView.center = contentView.center
        fullScreenImageView.contentMode = .scaleAspectFit
    }
    
}
