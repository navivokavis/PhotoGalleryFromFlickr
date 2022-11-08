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
    
    func loadImage(urlString: String) {
        DispatchQueue.global().async { [weak self] in
            guard let url = URL(string: urlString) else { return }
            
            guard let data = try? Data(contentsOf: url) else { return }
            DispatchQueue.main.async {
                self?.fullScreenImageView.image = UIImage(data: data)
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
