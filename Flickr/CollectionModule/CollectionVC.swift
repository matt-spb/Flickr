//
//  CollectionVC.swift
//  Flickr
//
//  Created by matt_spb on 01.03.2020.
//  Copyright © 2020 matt_spb_dev. All rights reserved.
//

import UIKit
import SwiftyJSON

// надо как то сделать красиво, чтобы во время пул ту  рефреш поялвялся только верхний активити индикатор
// в общем нужно положить индикатор в хедер и футер таблицы и убрать с центра экрана

//сделать детайл вью контроллер в виде скрол вью. Есть особенности верстки

class CollectionVC: BaseVC {
    
    var dataSource = [PhotoModel]()
    var page = 1
    var hasMorePhotos = true
    
    let refreshControl: UIRefreshControl = {
        let refControl = UIRefreshControl()
        refControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refControl
    }()

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        configureCollectionView()
        loadPhotos()
        setupActivityIndicatior()
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        dataSource = []  //кажется это хуевая идея
        hasMorePhotos = true
        page = 1
        loadPhotos()
        sender.endRefreshing() //дернуть когда придут данные
    }
    
    private func configureCollectionView() {
        collectionView.register(cellType: PhotoCell.self)
        collectionView.refreshControl = refreshControl
        collectionView.delegate = self
        collectionView.dataSource = self
    } 
}

extension CollectionVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: PhotoCell.self) 
        let photo = dataSource[indexPath.row]
        cell.configure(with: photo)
        
        if indexPath.row == dataSource.count - 1 && hasMorePhotos {
            page += 1
            loadPhotos()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        let vc = DetailPhotoVC()
//        vc.model = dataSource[indexPath.row]
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY         = scrollView.contentOffset.y
        let contentHeight   = scrollView.contentSize.height
        let height          = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMorePhotos else { return }
            // здесь добавить нижний пул ту рефреш
            //page += 1
            //loadPhotos()
        }
    }
}

extension CollectionVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 20) / 3 
        return CGSize(width: width, height: width)
    }
}

extension CollectionVC {
    
    func loadPhotos() {
        loaderView?.startAnimation()
        
        APIWrapper.getFullInfoPhoto(page: page, per_page: Const.Screen.collection.per_page, success: { [weak self] response in
            
            guard let self = self else { return }
            
            let json = JSON(response)
            let photosArray = json["photos"]["photo"].arrayValue
            var photos: [PhotoModel] = []
            
            for jsonPhoto in photosArray {
                let photo = PhotoModel(json: jsonPhoto)
                photos.append(photo)
            }
            
            self.dataSource.append(contentsOf: photos)
                        
            let currentPage = json["photos"]["page"].intValue
            let pages = json["photos"]["pages"].intValue
            
            if currentPage == pages {
                self.hasMorePhotos = false
            }
            
            DispatchQueue.main.async {
                self.loaderView?.stopAnimation()
                self.collectionView.reloadData()
            }
   
        }) { (error) in
            print("error")
        }
    }    
}

