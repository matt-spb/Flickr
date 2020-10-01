//
//  ViewController.swift
//  Flickr
//
//  Created by matt_spb on 23.02.2020.
//  Copyright © 2020 matt_spb_dev. All rights reserved.
//

import UIKit
import SwiftyJSON

// посмотреть в курсе шона как он сделал навбар

class TapeViewController: BaseVC {
    
    @IBOutlet weak var tableView: UITableView!
        
    var dataSource: [PhotoModel] = []
    var page = 1
    var shouldShowLoadingCell = false
    var cellID: String = "tapePhotoCell"
    
    let refreshControl: UIRefreshControl = {
        let refControl = UIRefreshControl()
        refControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refControl
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.refreshControl = refreshControl
        registerNibs()
        loadPhotos()
        setupActivityIndicatior()
        loaderView?.startAnimation()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.backgroundColor = .black
        navigationController?.navigationBar.isHidden = true
    }
    
    
    @objc private func refresh(sender: UIRefreshControl) {
        page = 1
        loadPhotos(refresh: true)
        sender.endRefreshing() //дернуть когда придут данные
    }
}


extension TapeViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = dataSource.count
        return shouldShowLoadingCell ? count + 1 : count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoadingIndexPath(indexPath) {
            return LoadingCell(style: .default, reuseIdentifier: "loading")
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "tapePhotoCell", for: indexPath) as! TapePhotoCell
            let photoModel = dataSource[indexPath.row]
            cell.configure(with: photoModel)
            cell.contentView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            return cell
        }
    }

    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isLoadingIndexPath(indexPath) {
            return 56
        } else {
            let imageHeight = dataSource[indexPath.row].height
            let imageWidth = dataSource[indexPath.row].width
            let ratio = CGFloat(imageWidth / imageHeight)
            return view.frame.width / ratio + 90
        }
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photoModel = dataSource[indexPath.row]
        guard let destVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "DetailVC") as? DetailPhotoVC else { return }
        destVC.photoModel = photoModel
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard isLoadingIndexPath(indexPath) else { return }
        fetchNextPage()
    }
    
    
    private func fetchNextPage() {
        page += 1
        loadPhotos()
    }
    
    
    private func isLoadingIndexPath(_ indexPath: IndexPath) -> Bool {
        guard shouldShowLoadingCell else { return false }
        return indexPath.row == self.dataSource.count
    }
}


// MARK: - Networking

extension TapeViewController {
    
    private func loadPhotos(refresh: Bool = false) {
        print("Fetching page \(page), refresh: \(refresh)")
        loaderView?.startAnimation()
        
        APIWrapper.getFullInfoPhoto(page: page, per_page: Const.Screen.tape.per_page, success: { [weak self] (response) in
            
            guard let self = self else { return }
            //print("response: \(response)")
            
            let json = JSON(response)
            
            let photosArray = json["photos"]["photo"].arrayValue
            if refresh {
                self.dataSource = []
                for jsonPhoto in photosArray {
                    let photo = PhotoModel(json: jsonPhoto)
                    let user = User(with: jsonPhoto)
                    self.configureUser(user: user)
                    photo.user = user
                    self.dataSource.append(photo)
                }
                print("count = \(self.dataSource.count)")
            } else {
                for jsonPhoto in photosArray {
                    let photo = PhotoModel(json: jsonPhoto)
                    if !self.dataSource.contains(photo) {
                        let user = User(with: jsonPhoto)
                        self.configureUser(user: user)
                        photo.user = user
                        self.dataSource.append(photo)
                    }
                }
                print("count = \(self.dataSource.count)")
            }
           
            let pages = json["photos"]["pages"].intValue
            self.shouldShowLoadingCell = self.page < pages
                        
            DispatchQueue.main.async {
                self.loaderView?.stopAnimation()
                self.tableView.reloadData()
            }
        }) { error in
            print(error ?? "")
        }
    }
    
    
    private func configureUser(user: User) {
        guard user.iconServer > 0 else { return }
        APIWrapper.getUserNsid(for: user.id) { result in
            switch result {
                case .success(let nsid):
                    DispatchQueue.main.async {
                        let userPicUrl = "http://farm\(user.iconFarm).staticflickr.com/\(user.iconServer)/buddyicons/\(nsid).jpg"
                        user.nsid = nsid
                        user.userPicUrl = userPicUrl
                    }

                case .failure(let error):
                    print(error.rawValue)
            }
        }
    }
    
    
    fileprivate func registerNibs() {
        let nib = UINib(nibName: "TapePhotoCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellID)
    }
}



 //Добавить Лоадер в начальный момент(UIActivityIndicator), когда таблица пустая без изображений и скрыть его и больше не показывать когда появились изображения
 //Добавить в таблицу PullToRefresh и по нему скидывать все данные на 0 и запрашивать только первые 15 изображений
 //В итоге датасурс должен быть равен total и лишние фотки не должны запрашиваться у сервера
 //Сделать нижний pullToRefresh при подгрузкe новых фотографий
 // сделать догрузку коллекшн вью
         

// по нажатию на фото и в ленте и в коллекции сделать переход на страничку с фото как в приложении, с отображением всей доступной информации о фото
