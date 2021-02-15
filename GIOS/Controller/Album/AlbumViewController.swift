//
//  AlbumViewController.swift
//  GIOS
//
//  Created by 정종문 on 2021/02/14.
//

import UIKit
import Photos

class AlbumViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var largeImageView: UIImageView!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var returnButton: UIButton!
    
    var imageArray = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.returnButton.setTitle("돌아가기", for: .normal)
        self.returnButton.addTarget(self, action: #selector(returnButtonAction), for: .touchUpInside)
        
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        setCollectionViewLayout()
        getPhotos()
    }
    
    @objc func returnButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoLibraryCell", for: indexPath)
        let imageView = cell.viewWithTag(1) as! UIImageView
        
        imageView.image = imageArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("IndexPath : \(indexPath.row)")
        largeImageView.setImage(imageArray[indexPath.row])
    }
    
    func setCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 5
        
        let width = photoCollectionView.frame.width / 3.5
        layout.itemSize = CGSize(width: width, height: width)
        
        photoCollectionView.collectionViewLayout = layout
    }

    func getPhotos() {
        let manager = PHImageManager.default()
        
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        options.deliveryMode = .opportunistic
                
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: nil)
        
        if fetchResult.count > 0 {
            for i in 0..<fetchResult.count {
                manager.requestImage(for: fetchResult.object(at: i), targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: options) {
                    (image, error) in
                    self.imageArray.append(image!)
                }
            }
            imageArray.reverse()
            
            DispatchQueue.main.async {
                self.photoCollectionView.reloadData()
            }
        } else {
            print("You got no photos!")
        }
    }
}
