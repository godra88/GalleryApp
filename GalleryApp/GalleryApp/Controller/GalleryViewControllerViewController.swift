//
//  GalleryViewController.swift
//  GalleryApp
//
//  Created by Ivan Fabri on 01/03/2023.
//

import UIKit

class GalleryViewController: UIViewController {
    
    // MARK: Properties
    
    private let dataService: DataFetching
    public var albums: [Photo] = []
    public var photoCount = 0 {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .lightGray
        collectionView.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: App.galleryCell)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let activityIndicatior: UIActivityIndicatorView = {
        let activityIndicatior = UIActivityIndicatorView(style: .large)
        activityIndicatior.startAnimating()
        return activityIndicatior
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.text = String(localized: "internetConnectionError")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    // MARK: init
    
    public init(dataService: DataFetching) {
        self.dataService = dataService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        
        setViews()
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.reachabilityChanged), name: NSNotification.Name.reachabilityChanged, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: nil)
    }
    
    // MARK: Methods
    
    public func fetchData(isFirstTimeLoad: Bool) {
        if isFirstTimeLoad {
            self.activityIndicatior.startAnimating()
            self.albums.removeAll()
            self.photoCount = 0
            self.collectionView.refreshControl?.endRefreshing()
        }
        dataService.fetchGallery(isFirstTimeLoad: isFirstTimeLoad) { [weak self] albums, error in
            guard let self = self else { return }
            self.activityIndicatior.stopAnimating()
            self.collectionView.refreshControl?.endRefreshing()
            
            guard let albums = albums else {
                self.getErrorMessage(error: error)
                return
            }
            
            self.photoCount += albums.count
            
            self.fetchImages(albums: albums)
        }
    }
    
    private func fetchImages(albums: [Photo]) {
        albums.forEach { photo in
            self.dataService.fetchImage(urlString: photo.thumbnailUrl ?? "") { image, error in
                guard let image = image else {
                    self.getErrorMessage(error: error)
                    return
                }
                self.albums.append(Photo(albumId:photo.albumId,
                                         id: photo.id,
                                         title: photo.title,
                                         url: photo.url,
                                         thumbnailUrl:photo.thumbnailUrl,
                                         image: image))
                self.collectionView.reloadData()
            }
        }
    }
    
    private func setViews() {
        view.addSubview(collectionView)
        activityIndicatior.center = self.view.center
        view.addSubview(activityIndicatior)
        
        titleLabel.isHidden = true
        view.addSubview(titleLabel)
        
        titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
    }
    
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as? Reachability
        switch reachability?.connection {
        case .cellular, .wifi:
            fetchData(isFirstTimeLoad: true)
            titleLabel.isHidden = true
        case .unavailable:
            self.albums.removeAll()
            self.photoCount = 0
            self.titleLabel.isHidden = false
            self.collectionView.reloadData()
            self.collectionView.refreshControl?.endRefreshing()
        case .none:
            break
        }
    }
    
    @objc func didPullToRefresh() {
        fetchData(isFirstTimeLoad: true)
    }
}

// MARK: UICollectionViewDelegate

extension GalleryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == photoCount - 7 {
            self.fetchData(isFirstTimeLoad: false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let urlString = albums.filter({ ($0.id ?? 0) - 1 == indexPath.item }).first?.url else {
            return
        }
        let imageController = ImageViewController(dataService: dataService, urlString: urlString)
        self.navigationController?.pushViewController(imageController, animated: true)
    }
}

// MARK: UICollectionViewDataSource

extension GalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: App.galleryCell, for: indexPath) as? GalleryCollectionViewCell
        if (albums.count - 1) >= indexPath.row {
            guard let imageData = albums.filter({ ($0.id ?? 0) - 1 == indexPath.item }).first?.image else {
                cell?.setup(image:  nil)
                return cell ?? UICollectionViewCell()
            }
            cell?.setup(image: UIImage(data: imageData) ?? UIImage(named: "placeholder"))
        }
        return cell ?? UICollectionViewCell()
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 100.0, height: 100.0)
    }
}
