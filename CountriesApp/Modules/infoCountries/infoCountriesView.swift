//
//  infoCountriesView.swift
//  CountriesApp
//
//  Created by Luis Fernando Sánchez Palma on 08/05/24.
//

import UIKit

class infoCountriesView: UIViewController {
    var registerDataToShow: CountriesModel?
    
    lazy var infoStackContainer : UIStackView = {
       let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fillEqually
        stack.spacing = 20
        stack.contentMode = .scaleAspectFit
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var nameCommonLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Common name: \(registerDataToShow?.nameCommon ?? "")"
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var nameOfficialLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Official name: \(registerDataToShow?.nameOfficial ?? "")"
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var capitalLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Capital name: \(registerDataToShow?.capital?.first ?? "")"
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var currenciesLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = ""
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var nameCurrenciesLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = ""
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
    
    lazy var showFlagButton: UIButton = {
       let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Show Flag", for: .normal)
        button.layer.cornerRadius = 25
        button.backgroundColor = .secondarySystemBackground
        button.addTarget(self, action: #selector(goToShowFlag), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var showMapButton: UIButton = {
       let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Show Map", for: .normal)
        button.layer.cornerRadius = 25
        button.backgroundColor = .secondarySystemBackground
        button.addTarget(self, action: #selector(goToShowMap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Country Information"
        setupUIElements()
        setupConstraints()
        obtainCurrencies(currencies: (registerDataToShow?.Currencies))
    }
    
    fileprivate func setupUIElements() {
        view.addSubview(infoStackContainer)
        view.addSubview(buttonStackContainer)
        
        infoStackContainer.addArrangedSubview(nameCommonLabel)
        infoStackContainer.addArrangedSubview(nameOfficialLabel)
        infoStackContainer.addArrangedSubview(capitalLabel)
        infoStackContainer.addArrangedSubview(currenciesLabel)
        infoStackContainer.addArrangedSubview(nameCurrenciesLabel)
        
        
        buttonStackContainer.addArrangedSubview(showFlagButton)
        buttonStackContainer.addArrangedSubview(showMapButton)
    }
    
    fileprivate func setupConstraints() {
        NSLayoutConstraint.activate([
            infoStackContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            infoStackContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            infoStackContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            infoStackContainer.bottomAnchor.constraint(equalTo: buttonStackContainer.topAnchor, constant: -50),
            
            buttonStackContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            buttonStackContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            buttonStackContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            
            showFlagButton.heightAnchor.constraint(equalToConstant: 50),
            showMapButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc func goToShowFlag(_ sender: UIButton) {
        let showFlagVC = FlagView()
        showFlagVC.flagURLToShow = registerDataToShow?.flagURL
        showFlagVC.modalPresentationStyle = .fullScreen
        self.navigationController?.present(showFlagVC, animated: true)
    }
    
    @objc func goToShowMap(_ sender: UIButton) {
        let showWebVC = WebView()
        showWebVC.mapURLToShow = registerDataToShow?.mapURL
        showWebVC.modalPresentationStyle = .fullScreen
        self.navigationController?.present(showWebVC, animated: true)
    }
    
    func obtainCurrencies(currencies: Currencies?) {
        guard let nonNilCurrencies = currencies else {
            return
        }
        
        for (currencyName, currency) in Mirror(reflecting: nonNilCurrencies).children {
            if let currency = currency as? Aed, let name = currency.name {
                currenciesLabel.text = "Currency: \(currencyName ?? "")"
                nameCurrenciesLabel.text = "Currency name: \(name)"
            }

            if let currency = currency as? BAM, let name = currency.name {
                currenciesLabel.text = "Currency: \(currencyName ?? "")"
                nameCurrenciesLabel.text = "Currency name: \(name)"
            }
            
        }
    }
}
