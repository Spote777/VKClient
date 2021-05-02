//
//  FriendPhotoCollectionViewController.swift
//  VKAccount
//
//  Created by Заруцков Павел on 06.08.2020.
//  Copyright © 2020 Павел. All rights reserved.
//

import UIKit
import RealmSwift

class FriendPhotoCollectionViewController: UICollectionViewController {
    
    //MARK: - Property
    
    private var photoService: PhotoService!
    let vkService = VKService()
    var friendsPhotos: FriendPhotos?
    var ownerId: Int = 0
    var titleItem: String?
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoService = PhotoService(container: collectionView)
    }
    
    func fetchRequestPhotosUser(for id: Int) {
        self.vkService.getPhoto(ownerId: ownerId) { [weak self] in
            do {
                let realm = try Realm()
                let photo = realm.objects(FriendPhotos.self).filter{ $0.ownerId == self?.ownerId}
                self?.friendsPhotos = Array(photo).first
                self?.collectionView.reloadData()
            } catch {
                print(error)
            }
        }
    }
  
    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! FriendPhotoCollectionViewCell
        
        guard let friendsImage = friendsPhotos?.sizes.last else { return cell }
        guard let images = friendsImage.url,
              let photosFriend = photoService.photo(atIndexpath: indexPath, byUrl: images) else { return cell }
        cell.configure(for: friendsImage, photoFriend: photosFriend)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goPhoto" {
            guard let photosFriend = segue.destination as? SinglePhotoViewController else { return }
            if let indexPath = collectionView.indexPathsForSelectedItems?.first {
                photosFriend.currentCountPhoto = indexPath.row
             }
        }
    }
}
