//
//  HomeView.swift
//  CountriesApp
//
//  Created by Luis Fernando Sánchez Palma on 08/05/24.
//

import UIKit

class HomeView: UIViewController {
    
    lazy var buttonStackContainer : UIStackView = {
       let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 20
        stack.contentMode = .scaleAspectFit
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var countriesButton: UIButton = {
       let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Countries", for: .normal)
        button.layer.cornerRadius = 25
        button.backgroundColor = .secondarySystemBackground
        button.addTarget(self, action: #selector(goToCountriesView), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var searchButton: UIButton = {
       let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Search Countries", for: .normal)
        button.layer.cornerRadius = 25
        button.backgroundColor = .secondarySystemBackground
        button.addTarget(self, action: #selector(goToSearchCountriesView), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Home"
        setupUIElements()
        setupConstraints()
    }
    
    fileprivate func setupUIElements() {
        view.addSubview(buttonStackContainer)
        buttonStackContainer.addArrangedSubview(countriesButton)
        buttonStackContainer.addArrangedSubview(searchButton)
    }
    
    fileprivate func setupConstraints() {
        NSLayoutConstraint.activate([
            buttonStackContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            buttonStackContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            buttonStackContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            countriesButton.heightAnchor.constraint(equalToConstant: 50),
            searchButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc func goToCountriesView(_ sender: UIButton) {

    }
    
    @objc func goToSearchCountriesView(_ sender: UIButton) {

    }
}

