//
//  ViewController.swift
//  Flickr
//
//  Created by matt_spb on 23.02.2020.
//  Copyright © 2020 matt_spb_dev. All rights reserved.
//

import UIKit

// посмотреть в курсе шона как он сделал навбар
// почему при первом запуске загружается 20 фотографий, даже если пер пейдж равно 5? Особенности тейбл вью?

protocol TapeVCDelegate: AnyObject {
    func updateTableView()
    func reloadData()
    func startLoaderView()
}


class TapeViewController: BaseVC {
    
    @IBOutlet weak var tableView: UITableView!
     
    private var tapeViewModel = TapeViewModel()
        
    let refreshControl: UIRefreshControl = {
        let refControl = UIRefreshControl()
        refControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refControl
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.refreshControl = refreshControl
        registerNibs()
        tapeViewModel.loadPhotos()
        setupActivityIndicatior()
        loaderView?.startAnimation()
        
        tapeViewModel.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.backgroundColor = .black
        navigationController?.navigationBar.isHidden = true
    }
    
    
    @objc private func refresh(sender: UIRefreshControl) {
        tapeViewModel.page = 1
        tapeViewModel.loadPhotos(refresh: true)
        sender.endRefreshing() //дернуть когда придут данные
    }
}


extension TapeViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tapeViewModel.numberOfRows()
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tapeViewModel.isLoadingIndexPath(indexPath) { //vm
            return LoadingCell(style: .default, reuseIdentifier: "loading")
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "tapePhotoCell", for: indexPath) as! TapePhotoCell
            let photo = tapeViewModel.dataSource[indexPath.row] //обычно делают свойство прайвит и метод, чтобы его достать. Для удобства тестирования. Гарант того, что нельзя изменить датасурс из любого места
            cell.configure(with: photo) //можно сделать отдельную вьюмодель для ячейки (инициировать из фотки). Потом
            cell.contentView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            return cell
        }
    }

    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tapeViewModel.heightForRowAt(indexPath: indexPath, frameWidth: view.frame.width)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photoModel = tapeViewModel.dataSource[indexPath.row]
        guard let destVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "DetailVC") as? DetailPhotoVC else { return }
        destVC.photoModel = photoModel
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard tapeViewModel.isLoadingIndexPath(indexPath) else { return }
        tapeViewModel.fetchNextPage() //унести во вью модель
    }
}


// MARK: - Networking

extension TapeViewController: TapeVCDelegate {
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    func updateTableView() {
        DispatchQueue.main.async {
            self.loaderView?.stopAnimation()
            self.tableView.reloadData()
        }
    }
    
    
    func startLoaderView() {
        DispatchQueue.main.async {
            self.loaderView?.startAnimation()
        }
    }
            

    fileprivate func registerNibs() {
        let nib = UINib(nibName: "TapePhotoCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: TapePhotoCell.cellID)
    }
}


 //Сделать нижний pullToRefresh при подгрузкe новых фотографий
         

// ДЗ от 26.01.21
// Сел и подумал какая проблема. Описать ее словами. Почему он не останавливает. Подумать логику решения
// Следущий шаг это вынести Нетворкинг во вьюмодель. Можно поиграться с комплишн хендлером и с делегатами для колбэков
// продолжить вынос логики из остальных ВК во вьюмодель


// кто то постоянно вызывает метод loadPhotos
