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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(iconImageView)
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
                self?.iconImageView.image = UIImage(data: data)
            }
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconImageView.frame = contentView.bounds
        iconImageView.contentMode = .scaleAspectFit
        
    }
    
}
