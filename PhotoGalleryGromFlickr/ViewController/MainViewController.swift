//
//  MainViewController.swift
//  FlickrPhotoGallery
//
//  Created by Navi Vokavis on 4.11.22.
//

import UIKit
import SwiftUI

class MainViewController: UIViewController {
    
    public var completion: ((String) -> Void)?
    
    var imageCollectionView : UICollectionView! = nil
    var searchBar = UISearchBar()
    var searchController = UISearchController()
    var apiCaller = APICaller()
    private var photoInfo = [PhotoInfo]()
    var timer: Timer?
    var photoVC = FullScreenPhotoViewController()
    
    var arrowView = UIView()
    let arrowImageView = UIImageView()
    var scrollTop = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        fistresponse()
        
        arrowView.layer.cornerRadius = 25
        arrowView.backgroundColor = .gray
        
        arrowImageView.image = UIImage(systemName: "chevron.up.circle.fill")
        //        arrowImageView.image = arrowImageView.image!.withRenderingMode(.alwaysTemplate)
        arrowImageView.tintColor = UIColor.white
        let TapScrollDown = UITapGestureRecognizer(target: self, action: #selector(ScrollToTheTop(_:)))
        arrowImageView.isUserInteractionEnabled = true
        arrowImageView.addGestureRecognizer(TapScrollDown)
        
    }
    
    func setup() {
        configureSubviews()
        layoutSubviews()
    }
    
    func configureSubviews() {
        title = "Photos of the day"
                
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.setupNavigationController()
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.becomeFirstResponder()
        
        imageCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        imageCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageCollectionView.backgroundColor = .systemBackground
        imageCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        view.addSubview(imageCollectionView)
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.register(ImagesCollectionViewCell.self, forCellWithReuseIdentifier: ImagesCollectionViewCell.identifier)
        imageCollectionView.scrollsToTop = true
        
        view.addSubview(arrowView)
        arrowView.addSubview(arrowImageView)
        
    }
    
    func layoutSubviews() {
        
        arrowView.translatesAutoresizingMaskIntoConstraints = false
        arrowView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        arrowView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        arrowView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
        arrowView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 50).isActive = true
        
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.topAnchor.constraint(equalTo: arrowView.topAnchor, constant: -2).isActive = true
        arrowImageView.leadingAnchor.constraint(equalTo: arrowView.leadingAnchor, constant: -2).isActive = true
        arrowImageView.bottomAnchor.constraint(equalTo: arrowView.bottomAnchor, constant: 2).isActive = true
        arrowImageView.trailingAnchor.constraint(equalTo: arrowView.trailingAnchor, constant: 2).isActive = true
    }
    
    func fistresponse() {
        apiCaller.request { [weak self] (result) in
            switch result {
            case .success(let apiResponse):
                photoModels = apiResponse.photos.photo.compactMap({
                    PhotosCollectionViewModel(
                        id: $0.id,
                        secret: $0.secret,
                        server: $0.server
                    )
                })
                self?.imageCollectionView.reloadData()
                
                DispatchQueue.main.async {
                    print(photoModels.count)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 3)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.33))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 3)
        let section = NSCollectionLayoutSection(group: group)
        //            section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY > 400 {
            if scrollTop {
                    UIView.animate(withDuration: 0.3) {
                    self.arrowView.transform = CGAffineTransform(translationX: -80, y: 0)
                }
                scrollTop = false
            }
        } else {
            if !scrollTop {
                    UIView.animate(withDuration: 0.3) {
                    self.arrowView.transform = .identity
                }
                scrollTop = true
            }
        }
    }
    
    @objc func ScrollToTheTop(_ sender: UITapGestureRecognizer) {
        let topOffest = CGPoint(x: 0, y: (self.imageCollectionView.contentInset.top) - 200)
        self.imageCollectionView.setContentOffset(topOffest, animated: true)
    }
    
}

//MARK: - SearchBar Delegate

extension MainViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        
        if searchText == "" {
            fistresponse()
        } else { timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [self] _ in
                apiCaller.searchByWord(string: searchText) { [weak self] (result) in
                    switch result {
                    case .success(let apiResponse):
                        photoModels = apiResponse.photos.photo.compactMap({
                            PhotosCollectionViewModel(
                                id: $0.id,
                                secret: $0.secret,
                                server: $0.server
                            )
                        })
                        DispatchQueue.main.async {
                            self?.imageCollectionView.reloadData()
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            }
            )}
        
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        fistresponse()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        becomeFirstResponder()
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
}


//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoModels.count
    }
    
    //    func numberOfSections(in collectionView: UICollectionView) -> Int {
    //        3
    //    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: ImagesCollectionViewCell.identifier, for: indexPath) as! ImagesCollectionViewCell
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.4
        cell.layer.shadowRadius = 3
        cell.layer.cornerRadius = 5
        DispatchQueue.main.async { [self] in
            let photoInformation = photoModels[indexPath.row]
            cell.loadImage(urlString: "https://live.staticflickr.com/\(photoInformation.server)/\(photoInformation.id)_\(photoInformation.secret).jpg")
        }
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.main.async { [self] in
            navigationController?.pushViewController(photoVC, animated: true)
            photoVC.indexPath = indexPath
            
        }
    }

    
}






//MARK: - SWIFT UI live preview

//struct FlowProvider: PreviewProvider {
//
//    static var previews: some View {
//        ContainerView().edgesIgnoringSafeArea(.all)
//    }
//
//    struct ContainerView: UIViewControllerRepresentable {
//        let vc = MainViewController()
//        func makeUIViewController(
//            context: UIViewControllerRepresentableContext<FlowProvider.ContainerView>) ->
//        some MainViewController {
//            return vc
//        }
//
//        func updateUIViewController(
//            _ uiViewController: FlowProvider.ContainerView.UIViewControllerType,
//            context: UIViewControllerRepresentableContext<FlowProvider.ContainerView>) {
//        }
//    }
//
//}


//extension UIViewController {
//    private struct Preview: UIViewControllerRepresentable {
//        let viewController: UIViewController
//
//        func makeUIViewController(context: Context) -> some UIViewController {
//            viewController
//        }
//
//        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
//
//        }
//    }
//
//    func showPreview() -> some View {
//        Preview(viewController: self).edgesIgnoringSafeArea(.all)
//    }
//}
//
//struct ViewControllerProvider: PreviewProvider {
//    static var previews: some View {
//        MainViewController().showPreview()
//    }
//}
