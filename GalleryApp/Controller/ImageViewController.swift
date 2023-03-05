//
//  ImageViewController.swift
//  GalleryApp
//
//  Created by Ivan Fabri on 05/03/2023.
//

import UIKit

class ImageViewController: UIViewController {
    
    // MARK: Properties
    
    private let dataService: DataFetching
    private var urlString: String
    
    private var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 3
        scrollView.zoomScale = 1.0
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private var imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let activityIndicatior: UIActivityIndicatorView = {
        let activityIndicatior = UIActivityIndicatorView(style: .large)
        activityIndicatior.startAnimating()
        return activityIndicatior
    }()
    
    // MARK: init
    
    public init(dataService: DataFetching, urlString: String) {
        self.dataService = dataService
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        setViews()
        fetchImages(urlString: urlString)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.doubleTapImage(_:)))
        doubleTap.numberOfTapsRequired = 2
        imageView.addGestureRecognizer(doubleTap)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let image = imageView.image {
            setMinZoomScaleForImageSize(image.size)
        }
    }
    
    // MARK: Methods
    
    private func setViews() {
        self.view.backgroundColor = .lightGray
        scrollView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        self.view.addSubview(scrollView)
        
        scrollView.addSubview(imageView)
        
        activityIndicatior.center = self.view.center
        view.addSubview(activityIndicatior)
        
        scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        
        imageView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
    }
    
    private func fetchImages(urlString: String) {
        self.dataService.fetchImage(urlString: urlString) { image, error in
            self.activityIndicatior.stopAnimating()
            guard let image = image else {
                self.imageView.image = UIImage(systemName: "photo")
                self.getErrorMessage(error: error)
                return
            }
            self.imageView.image = image
        }
    }
    
    private func setMinZoomScaleForImageSize(_ imageSize: CGSize) {
        let widthScale = view.frame.width / imageSize.width
        let heightScale = view.frame.height / imageSize.height
        let minScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
        
        let imageWidth = imageSize.width * minScale
        let imageHeight = imageSize.height * minScale
        let newImageFrame = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
        imageView.frame = newImageFrame
        
        centerImage()
    }
    
    private func centerImage() {
        let imageViewSize = imageView.frame.size
        let scrollViewSize = view.frame.size
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
    
    private func zoomRectangle(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width  = imageView.frame.size.width  / scale
        zoomRect.origin.x = center.x - (center.x * scrollView.zoomScale)
        zoomRect.origin.y = center.y - (center.y * scrollView.zoomScale)
        
        return zoomRect
    }
    
    @objc func doubleTapImage(_ sender: UITapGestureRecognizer) {
        if scrollView.zoomScale == scrollView.minimumZoomScale {
            scrollView.zoom(to: zoomRectangle(scale: scrollView.maximumZoomScale, center: sender.location(in: sender.view)), animated: true)
        } else {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        }
    }
}

// MARK: UIScrollViewDelegate

extension ImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImage()
    }
}
