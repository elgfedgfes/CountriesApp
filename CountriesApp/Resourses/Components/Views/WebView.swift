//
//  WebView.swift
//  CountriesApp
//
//  Created by Luis Fernando Sánchez Palma on 09/05/24.
//

import UIKit
import WebKit

class WebView: UIViewController {
    var mapURLToShow: String?
    
    lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero)
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
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
        title = "Map"
        setupUIElements()
        setupConstraints()
    }
    
    fileprivate func setupUIElements() {
        view.addSubview(webView)
        view.addSubview(closeButton)
        setURLWebView(urlString: mapURLToShow)
    }
    
    fileprivate func setupConstraints() {
        NSLayoutConstraint.activate([
            webView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: closeButton.topAnchor, constant: -10),
            
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            closeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            closeButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    private func setURLWebView(urlString: String?) {
        guard let nonNilUrlString = urlString, let nonNilUrl = URL(string: nonNilUrlString) else {
            return
        }
        webView.load(URLRequest(url: nonNilUrl))
    }
    
    @objc func dismmissView(_ sender: UIButton) {
        dismiss(animated: true)
    }

}
