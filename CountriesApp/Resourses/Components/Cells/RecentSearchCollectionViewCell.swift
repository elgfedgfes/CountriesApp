//
//  RecentSearchCollectionViewCell.swift
//  CountriesApp
//
//  Created by Luis Fernando Sánchez Palma on 09/05/24.
//

import UIKit

class RecentSearchCollectionViewCell: UICollectionViewCell {
    static let identifier = "RecentSearchCollectionViewCell"
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "Nombre"
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUIElements()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUIElements() {
        contentView.backgroundColor =  .secondarySystemBackground
        contentView.layer.cornerRadius = 15
        contentView.addSubview(nameLabel)
    }
    
    fileprivate func setupConstraints() {
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 30),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -5),
        ])
    }
}
