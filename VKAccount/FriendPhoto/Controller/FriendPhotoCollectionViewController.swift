//
//  FriendPhotoCollectionViewController.swift
//  VKAccount
//
//  Created by Заруцков Павел on 06.08.2020.
//  Copyright © 2020 Павел. All rights reserved.
//

import UIKit

class FriendPhotoCollectionViewController: UICollectionViewController {
    
    // MARK: - Properties
    
    var userID = ""
    var collectionPhotos: [String] = []
    var photoService: PhotoService?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GetPhotosFriend().loadData(owner_id: userID) { [weak self] (complition) in
            DispatchQueue.main.async {
                self?.collectionPhotos = complition
                self?.collectionView.reloadData()
            }
        }
    }

    // MARK: - CollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionPhotos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! FriendPhotoCollectionViewCell
        if let imgUrl = URL(string: collectionPhotos[indexPath.row]) {
            cell.photosFriend.load(url: imgUrl)
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goPhoto" {
            guard let photosFriend = segue.destination as? SinglePhotoViewController else { return }
            
            if let indexPath = collectionView.indexPathsForSelectedItems?.first {
                photosFriend.allPhotos = collectionPhotos
                photosFriend.currentCountPhoto = indexPath.row
            }
        }
    }
}
