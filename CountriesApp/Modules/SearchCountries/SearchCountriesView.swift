//
//  SearchCountriesView.swift
//  CountriesApp
//
//  Created by Luis Fernando Sánchez Palma on 08/05/24.
//

import UIKit

class SearchCountriesView: UIViewController {
    private let viewModel = SearchCountriesViewModel()
    private var previousSearchText: String = ""
    
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
        layout.minimumInteritemSpacing = 1.0
        layout.minimumLineSpacing = 1.0
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
        label.text = "No results found"
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
        bind()
        setupUIElements()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchResentSearch()
    }
    
    private func bind() {
        viewModel.refreshData = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.collectionView.reloadData()
                if self?.viewModel.countries.count != 0 {
                    self?.tableView.isHidden = false
                    self?.notFoundLabel.isHidden = true
                }
                if self?.viewModel.resentSearchResult.count != 0 {
                    self?.collectionView.isHidden = false
                    self?.resentSearchLabel.isHidden = false
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
        if viewModel.resentSearchResult.count == 0 {
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
        viewModel.saveResentSearch(name: viewModel.countries[indexPath.row].nameCommon ?? "")
        self.navigationController?.pushViewController(infoCountriesVC, animated: true)
    }
    
}

extension SearchCountriesView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.resentSearchResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentSearchCollectionViewCell.identifier, for: indexPath) as? RecentSearchCollectionViewCell {
            cell.nameLabel.text = viewModel.resentSearchResult[indexPath.row]
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.getFilterCountries(searchText: viewModel.resentSearchResult[indexPath.row])
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
