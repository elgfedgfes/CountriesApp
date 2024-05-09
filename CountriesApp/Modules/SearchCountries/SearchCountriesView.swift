//
//  SearchCountriesView.swift
//  CountriesApp
//
//  Created by Luis Fernando Sánchez Palma on 08/05/24.
//

import UIKit

class SearchCountriesView: UIViewController {
    private let viewModel = SearchCountriesViewModel()
    private let dataManager = CoreDataManager()
    private var previousSearchText: String = ""
    private var resentSearchResult: [String]?
    
    lazy var searchBar: UISearchController = {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        return searchController
    }()
    
    lazy var resentSearchLabel: UILabel = {
       let label = UILabel()
        label.text = "Recent search"
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSizeMake(1,1)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(RecentSearchCollectionViewCell.self, forCellWithReuseIdentifier: RecentSearchCollectionViewCell.identifier)
        collectionView.isHidden = true
        return collectionView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CountriesTableViewCell.self, forCellReuseIdentifier: CountriesTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var notFoundLabel: UILabel = {
       let label = UILabel()
        label.text = "No se encontraron resultados"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Search"
        self.navigationItem.searchController = searchBar
        self.definesPresentationContext = false
        self.navigationItem.hidesSearchBarWhenScrolling = false
        previousSearchText = searchBar.searchBar.text ?? ""
        viewModel.delegate = self
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dataManager.RecentSearchGET { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let responseData):
                    self?.resentSearchResult = responseData
                    self?.collectionView.reloadData()
                    if self?.resentSearchResult?.count != 0 {
                        self?.collectionView.isHidden = false
                        self?.resentSearchLabel.isHidden = false
                    }
                    self?.setupUIElements()
                    self?.setupConstraints()
                case .failure(let error):
                    print("error: \(error)")
                }
            }
        }
        
    }
    
    private func bind() {
        viewModel.refreshData = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                if ((self?.tableView.isHidden) != nil) {
                    self?.tableView.isHidden = false
                    self?.notFoundLabel.isHidden = true
                }
            }
        }
    }
    
    fileprivate func setupUIElements() {
        view.addSubview(resentSearchLabel)
        view.addSubview(collectionView)
        view.addSubview(tableView)
        view.addSubview(notFoundLabel)
    }
    
    fileprivate func setupConstraints() {
        NSLayoutConstraint.activate([
            resentSearchLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            resentSearchLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resentSearchLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            collectionView.topAnchor.constraint(equalTo: resentSearchLabel.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.heightAnchor.constraint(equalToConstant: 50),
            
            notFoundLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            notFoundLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        if collectionView.isHidden {
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])

        } else {
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
        }
    }
}

extension SearchCountriesView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CountriesTableViewCell.identifier, for: indexPath) as? CountriesTableViewCell {
            cell.backgroundColor = indexPath.row % 2 == 0 ? .systemBackground : .secondarySystemBackground
            cell.setCell(countries: viewModel.countries[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let infoCountriesVC = InfoCountriesView()
        infoCountriesVC.registerDataToShow = viewModel.countries[indexPath.row]
        dataManager.RecentSearchPOST(name: viewModel.countries[indexPath.row].nameCommon ?? "") { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    print("succes: name saved")
                case .failure(let error):
                    print("error: \(error)")
                }
            }
        }
        self.navigationController?.pushViewController(infoCountriesVC, animated: true)
    }
    
}

extension SearchCountriesView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        resentSearchResult?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentSearchCollectionViewCell.identifier, for: indexPath) as? RecentSearchCollectionViewCell {
            cell.nameLabel.text = resentSearchResult?[indexPath.row]
            return cell
        }
        return UICollectionViewCell()
    }
}

extension SearchCountriesView: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let currentSearchText = searchController.searchBar.text else {
            return
        }
        
        if currentSearchText != previousSearchText {
            viewModel.getFilterCountries(searchText: currentSearchText)
            previousSearchText = currentSearchText
        }
    }
}

extension SearchCountriesView: SearchCountriesViewModelDelegate {
    func notifyNotFoundCountries() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.isHidden = true
            self?.notFoundLabel.isHidden = false
        }
    }
}
