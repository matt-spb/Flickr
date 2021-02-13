//
//  CollectionViewModel.swift
//  Flickr
//
//  Created by matt_spb on 09.02.2021.
//  Copyright © 2021 matt_spb_dev. All rights reserved.
//

import Foundation
import CoreGraphics

public class CollectionViewModel {
    
    weak var delegate: CollectionVCDelegate?

    var dataSource = [Photo]()
    var page = 1
    var hasMorePhotos = true
    
    func fetchNextPage() {
        page += 1
        loadPhotos()
    }
    
    
    func loadPhotos(refresh: Bool = false) {
        print("Fetching page \(page), refresh: \(refresh)")
        
        self.delegate?.startLoaderView()
        
        APIWrapper.getFullInfoPhoto(page: page, per_page: Const.Screen.collection.per_page) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
                case .success(let photos):
                    
                    refresh ? self.refreshCollectionWith(photos.photo) : self.addMorePhotosWith(photos.photo)
                    self.hasMorePhotos = self.page < photos.pages
                
                    self.delegate?.updateCollectionView()
                
                case .failure(let error):
                    print(error.rawValue)
            }
        }
    }
    
    
    private func addMorePhotosWith(_ photosArray: [Photo]) {
        addPhotoToDatasourceFrom(photosArray)
    }
    
    
    private func refreshCollectionWith(_ photosArray: [Photo]) {
        self.dataSource = []
        addPhotoToDatasourceFrom(photosArray)
    }
    
    
    private func addPhotoToDatasourceFrom(_ photosArray: [Photo]) {
        for photo in photosArray {
            if !dataSource.contains(photo) {
                
                var photo = photo
                let user = Person(with: photo)
                configureUser(user: user)
                photo.user = user
                dataSource.append(photo)
            }
        }
    }
    
    
    private func configureUser(user: Person) {
        guard user.iconServer > 0 else { return }
        
        APIWrapper.getUserInfo(for: user.id) { result in
            switch result {
                case .success(let person):
                    guard let nsid = person.nsid else { return }
                    let userPicUrl = "http://farm\(person.iconfarm).staticflickr.com/\(person.iconserver)/buddyicons/\(nsid).jpg"
                        
                    user.userPicUrl = userPicUrl
                
                case .failure(let error):
                    print(error.rawValue)
            }
        }
    }
}
