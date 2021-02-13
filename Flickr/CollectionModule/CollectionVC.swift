//
//  CollectionVC.swift
//  Flickr
//
//  Created by matt_spb on 01.03.2020.
//  Copyright © 2020 matt_spb_dev. All rights reserved.


// надо как то сделать красиво, чтобы во время пул ту  рефреш поялвялся только верхний активити индикатор
// в общем нужно положить индикатор в хедер и футер таблицы и убрать с центра экрана

import UIKit

protocol CollectionVCDelegate: AnyObject {
    func updateCollectionView()
    func startLoaderView()
}


class CollectionVC: BaseVC {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var collectionViewModel = CollectionViewModel()
    
    let refreshControl: UIRefreshControl = {
        let refControl = UIRefreshControl()
        refControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        configureCollectionView()
        collectionViewModel.loadPhotos()
        setupActivityIndicatior()
        loaderView?.startAnimation()
        
        collectionViewModel.delegate = self
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        collectionViewModel.page = 1
        collectionViewModel.loadPhotos(refresh: true)
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
        return collectionViewModel.dataSource.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: PhotoCell.self) 
        let photo = collectionViewModel.dataSource[indexPath.row]
        cell.configure(with: photo)
        
        if indexPath.row == collectionViewModel.dataSource.count - 1 && collectionViewModel.hasMorePhotos {
            collectionViewModel.fetchNextPage()
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoModel = collectionViewModel.dataSource[indexPath.row]
        guard let destVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "DetailVC") as? DetailPhotoVC else { return }
        destVC.photoModel = photoModel
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY         = scrollView.contentOffset.y
        let contentHeight   = scrollView.contentSize.height
        let height          = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {  // до этого момента UI
            guard collectionViewModel.hasMorePhotos else { return }
            // здесь добавить нижний пул ту рефреш
            collectionViewModel.fetchNextPage()
        }
    }
}


extension CollectionVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 20) / 3 //здесь только последние 2 строчки можно вынести. Есть ли смысл?
        return CGSize(width: width, height: width)
    }
}

// MARK: - Networking

extension CollectionVC: CollectionVCDelegate {
    
    func startLoaderView() {
        loaderView?.startAnimation()
    }

    
    func updateCollectionView() {
        DispatchQueue.main.async {
            self.loaderView?.stopAnimation()
            self.collectionView.reloadData()
        }
    }
}


