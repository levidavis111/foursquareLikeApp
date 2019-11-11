//
//  MapCollectionViewCell.swift
//  unit-five-project-one
//
//  Created by Levi Davis on 11/7/19.
//  Copyright © 2019 Levi Davis. All rights reserved.
//

import UIKit

class MapCollectionViewCell: UICollectionViewCell {
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()

        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(imageView)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        [imageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor), imageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
         imageView.widthAnchor.constraint(equalToConstant: 200),
         imageView.heightAnchor.constraint(equalToConstant: 150)].forEach{ $0.isActive = true
        }
    }
}
