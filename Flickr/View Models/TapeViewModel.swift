//
//  TapeViewModel.swift
//  Flickr
//
//  Created by matt_spb on 26.01.2021.
//  Copyright © 2021 matt_spb_dev. All rights reserved.
//

import Foundation
import CoreGraphics

// что делать с нетворкингом? Клоужер ругается на capturin mutating self, если сделать вьюмодель структурой

public class TapeViewModel { //90 процентов вьюмодель это структура
    
    weak var delegate: TapeVCDelegate?
    var dataSource: [Photo] = []
    var page = 1
    var shouldShowLoadingCell = false
    
    
    func numberOfRows() -> Int {
        let count = dataSource.count
        return shouldShowLoadingCell ? count + 1 : count
    }
    
    
    func heightForRowAt(indexPath: IndexPath, frameWidth: CGFloat) -> CGFloat {
        if isLoadingIndexPath(indexPath) {
            return 56
        } else {
            let imageHeight = dataSource[indexPath.row].height
            let imageWidth = dataSource[indexPath.row].width
            let ratio = imageWidth / imageHeight
            return frameWidth / ratio + 90
        }
    }
    
    
    func isLoadingIndexPath(_ indexPath: IndexPath) -> Bool {
        guard shouldShowLoadingCell else { return false }
        return indexPath.row == self.dataSource.count
    }
    
    
    func fetchNextPage() {
        page += 1
        loadPhotos()
    }
    
    
    // MARK: - Networking
    
    func loadPhotos(refresh: Bool = false) {
        print("Fetching page \(page), refresh: \(refresh)")
        
        self.delegate?.startLoaderView()
        
        APIWrapper.getFullInfoPhoto(page: page, per_page: Const.Screen.tape.per_page) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
                case .success(let photos):
                    
                    refresh ? self.refreshTapeWith(photos.photo) : self.addMorePhotosWith(photos.photo)
                    self.shouldShowLoadingCell = self.page < photos.pages
                    
                    self.delegate?.updateTableView()
                
                case .failure(let error):
                    print(error.rawValue)
            }
        }
    }
    
    
    private func addMorePhotosWith(_ photosArray: [Photo]) {
        addPhotoToDatasourceFrom(photosArray)
    }
    
    
    private func refreshTapeWith(_ photosArray: [Photo]) {
        dataSource = []
        addPhotoToDatasourceFrom(photosArray)
    }
    
    
    private func addPhotoToDatasourceFrom(_ photosArray: [Photo]) {
        for photo in photosArray {
            if !dataSource.contains(photo) {
                
                var photo = photo
                let user = Person(with: photo)
                configureUser(user: user) {
                    self.delegate?.reloadData()
                }
                photo.user = user
                dataSource.append(photo)
            }
        }
    }
    
    
    func configureUser(user: Person, completion: @escaping () -> Void) {
        guard user.iconServer > 0 else { return }
        
        APIWrapper.getUserInfo(for: user.id) { result in
            switch result {
                case .success(let person):
                    
                    guard let nsid = person.nsid else { return }
                    let userPicUrl = "http://farm\(person.iconfarm).staticflickr.com/\(person.iconserver)/buddyicons/\(nsid).jpg"
                    user.userPicUrl = userPicUrl
                    
                    completion()
                
                case .failure(let error):
                    print(error.rawValue)
            }
        }
    }
}
