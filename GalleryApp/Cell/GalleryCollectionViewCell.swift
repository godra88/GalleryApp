//
//  GalleryCollectionViewCell.swift
//  GalleryApp
//
//  Created by Ivan Fabri on 03/03/2023.
//

import Foundation
import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    // MARK: Properties
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    
    let activityIndicatior: UIActivityIndicatorView = {
        let activityIndicatior = UIActivityIndicatorView(style: .medium)
        activityIndicatior.startAnimating()
        return activityIndicatior
    }()
    
    // MARK: init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    
    func setup(image: UIImage?) {
        if image != nil {
            imageView.image = image
            activityIndicatior.stopAnimating()
        } else {
            activityIndicatior.startAnimating()
        }
    }
    
    // MARK: Methods
    
    private func setViews() {
        contentView.addSubview(imageView)
        contentView.layer.cornerRadius = 5
        activityIndicatior.center = contentView.center
        imageView.addSubview(activityIndicatior)
        
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }
    
    // MARK: Overrides
    
    override func prepareForReuse() {
        activityIndicatior.startAnimating()
        imageView.image = UIImage()
    }
}
