//
//  CollectionVC.swift
//  Flickr
//
//  Created by matt_spb on 01.03.2020.
//  Copyright © 2020 matt_spb_dev. All rights reserved.
//

import UIKit

// надо как то сделать красиво, чтобы во время пул ту  рефреш поялвялся только верхний активити индикатор
// в общем нужно положить индикатор в хедер и футер таблицы и убрать с центра экрана

class CollectionVC: BaseVC {
    
    var dataSource = [Photo]()
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
        loaderView?.startAnimation()
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        page = 1
        loadPhotos(refresh: true)
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
            fetchNextPage()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoModel = dataSource[indexPath.row]
        guard let destVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "DetailVC") as? DetailPhotoVC else { return }
        destVC.photoModel = photoModel
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY         = scrollView.contentOffset.y
        let contentHeight   = scrollView.contentSize.height
        let height          = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMorePhotos else { return }
            // здесь добавить нижний пул ту рефреш
            fetchNextPage()
        }
    }
    
    private func fetchNextPage() {
        page += 1
        loadPhotos()
    }
}


extension CollectionVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 20) / 3 
        return CGSize(width: width, height: width)
    }
}

// MARK: - Networking

extension CollectionVC {
    
    private func loadPhotos(refresh: Bool = false) {
        print("Fetching page \(page), refresh: \(refresh)")
        loaderView?.startAnimation()
        
        APIWrapper.getFullInfoPhoto(page: page, per_page: Const.Screen.collection.per_page) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
                case .success(let photos):
                    
                    refresh ? self.refreshCollectionWith(photos.photo) : self.addMorePhotosWith(photos.photo)
                    self.hasMorePhotos = self.page < photos.pages
                    
                    DispatchQueue.main.async {
                        self.loaderView?.stopAnimation()
                        self.collectionView.reloadData()
                }
                
                case .failure(let error):
                    print(error.rawValue)
            }
        }
    }
    
    
    private func addMorePhotosWith(_ photosArray: [Photo]) {
        for photo in photosArray {
            if !self.dataSource.contains(photo) {
                
                var photo = photo
                let user = Person(with: photo)
                self.configureUser(user: user)
                photo.user = user
                self.dataSource.append(photo)
            }
        }
    }

    
    private func refreshCollectionWith(_ photosArray: [Photo]) {
        self.dataSource = []
        for photo in photosArray {
            
            var photo = photo
            let user = Person(with: photo)
            self.configureUser(user: user)
            photo.user = user
            self.dataSource.append(photo)
        }
    }
  
    
    private func configureUser(user: Person) {
        guard user.iconServer > 0 else { return }
        
        APIWrapper.getUserInfo(for: user.id) { result in
            switch result {
                case .success(let person):
                    guard let nsid = person.nsid else { return }
                    let userPicUrl = "http://farm\(person.iconfarm).staticflickr.com/\(person.iconserver)/buddyicons/\(nsid).jpg"
                    DispatchQueue.main.async {
                        user.userPicUrl = userPicUrl
                }
                
                case .failure(let error):
                    print(error.rawValue)
            }
        }
    }
}

/*
let json = ["person": ["id": "80036114@N08",
                       "nsid": "80036114@N08",
                       "ispro": 1,
                       "can_buy_pro": 0,
                       "iconserver": "8669",
                       "iconfarm": 9,
                       "path_alias": "normanwest4tography",
                       "has_stats":"1",
                       "pro_badge": "standard",
                       "expire":"0",
                       "username": ["_content": "normanwest4tography"],
                       "realname": ["_content" : "Norman West"],
                       "location": ["_content":"South Wales, UK."],
                       "timezone": ["label": "GMT: Dublin, Edinburgh, Lisbon, London",
                                    "offset": "+00:00",
                                    "timezone_id": "EuropeLondon"],
                       "description": ["_content": "Hello and welcome to my Flickr site. I am a keen amateur with a passion for photographing all aspects of wildlife and landscapes. Based in South Wales, the majority of wildlife photographs are from the local area./nNow retired, visits further afield are planned and as such this website is a work in progress."],
                       "photosurl": ["_content": "https:www.flickr.com/photos_normanwest4tography"],
                       "profileurl" : ["_content": "https:www.flickr.com/people/normanwest4tography"],
                       "mobileurl": ["_content": "https:m.flickr.com/photostream.gne?id=79943301"],
                       "photos": ["firstdatetaken": ["_content": "2000-01-01 00:00:46"],
                                  "firstdate": ["_content":"1338990226"],
                                  "count": ["_content": 2818]]],
            "stat": "ok"] as [String : Any]
*/
