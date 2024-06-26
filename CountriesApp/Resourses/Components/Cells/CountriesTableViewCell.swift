//
//  CountriesTableViewCell.swift
//  CountriesApp
//
//  Created by Luis Fernando Sánchez Palma on 08/05/24.
//

import UIKit

class CountriesTableViewCell: UITableViewCell {
    static let identifier = "CountriesTableViewCell"
    
    lazy var dataStack : UIStackView = {
       let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .equalCentering
        stack.spacing = 2
        stack.contentMode = .scaleAspectFit
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var nameCommonLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.text = ""
        return label
    }()
    
    
    lazy var nameOfficialLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18)
        label.textColor = .systemGray
        label.text = ""
        return label
    }()
    
    lazy var capitalLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18)
        label.textColor = .systemGray
        label.text = ""
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUIElements()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUIElements() {
        contentView.addSubview(dataStack)
        dataStack.addArrangedSubview(nameCommonLabel)
        dataStack.addArrangedSubview(nameOfficialLabel)
        dataStack.addArrangedSubview(capitalLabel)
    }
    
    fileprivate func setupConstraints() {
        NSLayoutConstraint.activate([
            dataStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            dataStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            dataStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            dataStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
        ])
    }
    
    func setCell(countries: CountriesModel) {
        nameCommonLabel.text = countries.nameCommon
        nameOfficialLabel.text = countries.nameOfficial
        capitalLabel.text = countries.capital?.first
    }
}
