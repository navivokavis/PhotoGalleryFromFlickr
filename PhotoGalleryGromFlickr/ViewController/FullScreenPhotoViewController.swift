//
//  FullScreenPhotoViewController.swift
//  FlickrPhotoGallery
//
//  Created by Navi Vokavis on 7.11.22.
//

import UIKit

class FullScreenPhotoViewController: UIViewController {
    
    var photoImageView = UIImageView()
    var imageScrollView = UIScrollView()
    var collectionView : UICollectionView!
    
    var indexPath: IndexPath!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setup()
    }
    
    
    func setup() {
        buildHierarchy()
        configureSubviews()
        layoutSubviews()
    }
    
    func buildHierarchy() {
        view.addSubview(imageScrollView)
    }
    
    func configureSubviews() {
        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        imageScrollView.delegate = self
        imageScrollView.minimumZoomScale = 1.0
        imageScrollView.maximumZoomScale = 3.0
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FullScreenCollectionViewCell.self,
                                forCellWithReuseIdentifier: FullScreenCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        imageScrollView.addSubview(collectionView)
        collectionView.isPagingEnabled = true
        layout.minimumLineSpacing = 0
        
        collectionView.performBatchUpdates(nil) { (result) in
            self.collectionView.scrollToItem(at: self.indexPath, at: .centeredHorizontally, animated: false)
        }
        
    }
    
    func layoutSubviews() {
        
        imageScrollView.frame = view.bounds
        collectionView.frame = imageScrollView.bounds
        collectionView.center.x = imageScrollView.center.x
        collectionView.center.y = imageScrollView.center.y - 60
        
    }
    
}


//MARK: - UIScrollViewDelegate

extension FullScreenPhotoViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return collectionView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        scrollView.setZoomScale(1.0, animated: true)
    }
    
}



//MARK: - Collerction View Delegate and DataSource

extension FullScreenPhotoViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FullScreenCollectionViewCell.identifier, for: indexPath) as! FullScreenCollectionViewCell
        
        var photoInformation = photoModels[indexPath.row]
        cell.loadImage(urlString: "https://live.staticflickr.com/\(photoInformation.server)/\(photoInformation.id)_\(photoInformation.secret).jpg")
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.6
        cell.layer.shadowRadius = 7
        cell.layer.cornerRadius = 5
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let height = view.frame.height
        return CGSize(width: width, height: height)
    }
        
    
}
