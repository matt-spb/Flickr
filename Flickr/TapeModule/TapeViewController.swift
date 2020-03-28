//
//  ViewController.swift
//  Flickr
//
//  Created by matt_spb on 23.02.2020.
//  Copyright © 2020 matt_spb_dev. All rights reserved.
//

import UIKit
import SwiftyJSON


class TapeViewController: BaseVC {
        
    var dataSource: [PhotoModel] = []
    var page = 1
    var hasMorePhotos = true
    
    let refreshControl: UIRefreshControl = {
        let refControl = UIRefreshControl()
        refControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refControl
    }()

    @IBOutlet weak var tableView: UITableView!
    
    var cellID: String = "tapePhotoCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationController?.navigationBar.isHidden = true
        tableView.refreshControl = refreshControl
        registerNibs()
        loadPhotos()
        setupActivityIndicatior()
        loaderView?.startAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    
    @objc private func refresh(sender: UIRefreshControl) {
        dataSource = []
        page = 1
        loadPhotos()
        sender.endRefreshing() //дернуть когда придут данные
    }
}


extension TapeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tapePhotoCell", for: indexPath) as! TapePhotoCell
        let photoModel = dataSource[indexPath.row]
        cell.configure(with: photoModel)
        cell.contentView.backgroundColor = .black
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageHeight = dataSource[indexPath.row].height
        let imageWidth = dataSource[indexPath.row].width
        let ratio = CGFloat(imageWidth / imageHeight)
        return view.frame.width / ratio

    }

    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == dataSource.count - 1 && hasMorePhotos {
            page += 1
            loadPhotos()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photoModel = dataSource[indexPath.row]
        guard let destVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "DetailVC") as? DetailPhotoVC else { return }
        destVC.photoModel = photoModel
        navigationController?.pushViewController(destVC, animated: true)
    }
}


extension TapeViewController {
    
    func loadPhotos() {
        //showLoadingView()
        loaderView?.startAnimation()
        
        APIWrapper.getFullInfoPhoto(page: page, per_page: Const.Screen.tape.per_page, success: { [weak self] (response) in
            
            guard let self = self else { return }
            print("response: \(response)")
            
            let json = JSON(response)
            
            let photosArray = json["photos"]["photo"].arrayValue
            var photos: [PhotoModel] = []
            
            for jsonPhoto in photosArray {
                
                let photo = PhotoModel(json: jsonPhoto)
                photos.append(photo)
            }
                        
            let currentPage = json["photos"]["page"].intValue
            let pages = json["photos"]["pages"].intValue

            if currentPage == pages {
                self.hasMorePhotos = false
            }
            self.dataSource.append(contentsOf: photos)
            
            DispatchQueue.main.async {
                self.loaderView?.stopAnimation()
                self.tableView.reloadData()
                
            }
        }) { error in
            print(error ?? "")
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
