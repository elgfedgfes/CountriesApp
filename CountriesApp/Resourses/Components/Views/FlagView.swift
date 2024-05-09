//
//  FlagView.swift
//  CountriesApp
//
//  Created by Luis Fernando Sánchez Palma on 09/05/24.
//

import UIKit

class FlagView: UIViewController {
    var flagURLToShow: String?
    var networkManager = NetworkManager()
    
    lazy var flagImageView: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var closeButton: UIButton = {
       let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Close", for: .normal)
        button.layer.cornerRadius = 25
        button.backgroundColor = .secondarySystemBackground
        button.addTarget(self, action: #selector(dismmissView), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Flag"
        setupUIElements()
        setupConstraints()
    }
    
    
    fileprivate func setupUIElements() {
        view.addSubview(flagImageView)
        view.addSubview(closeButton)
        setFlagImagebyURL(imageURL: flagURLToShow ?? "")
    }
    
    fileprivate func setupConstraints() {
        NSLayoutConstraint.activate([
            flagImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            flagImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            flagImageView.heightAnchor.constraint(equalToConstant: 300),
            flagImageView.widthAnchor.constraint(equalToConstant: 300),
            
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            closeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            closeButton.heightAnchor.constraint(equalToConstant: 50),
            
        ])
    }
    
    func setFlagImagebyURL(imageURL: String) {
        networkManager.fetchImage(url: imageURL) { [weak self] responseData in
            DispatchQueue.main.async {
                self?.flagImageView.image = responseData
            }
        } failure: { errorResponse in
            print("Error: \(errorResponse)")
        }
    }
    
    @objc func dismmissView(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
