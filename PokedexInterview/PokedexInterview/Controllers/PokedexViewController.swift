//
//  PokedexViewController.swift
//  PokedexInterview
//
//  Created by Gabriel Bergamo on 11/06/24.
//

import UIKit

class PokedexViewController: UIViewController {
    
    var viewModel = PokedexViewModel()
    let tableView = UITableView()
    let headerLabel = UILabel()
    let searchBar = UISearchBar()
    let emptyLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    var alert: UIAlertController?
    var firstLoadingView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
        setupHeaderLabel()
        setupSearchBar()
        setupTableView()
        setupEmptyLabel()
        manageTableViewVisibility()
    }
    
    private func setupHeaderLabel() {
        headerLabel.backgroundColor = .white
        
        let titleAttributes = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24)]
        let titleString = NSMutableAttributedString(string: "Pokemon", attributes: titleAttributes)
        let boxAttributes = [ NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 28)]
        let boxString = NSMutableAttributedString(string: "Box", attributes: boxAttributes)
        titleString.append(boxString)
        headerLabel.attributedText = titleString
        
        
        headerLabel.textAlignment = .center
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerLabel)
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(PokemonCell.self, forCellReuseIdentifier: "PokemonCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        firstLoadingView = UIView(frame: view.frame)
        firstLoadingView!.backgroundColor = UIColor.black
        firstLoadingView!.alpha = 0.9
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(
            x: (view.frame.maxX / 2) - 25,
            y: (view.frame.maxY / 2) - 125,
            width: 50,
            height: 50)
        )
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.color = .white
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating()
        firstLoadingView?.addSubview(loadingIndicator)
        
        tableView.addSubview(firstLoadingView!)
    }
    
    private func setupSearchBar() {
        searchBar.placeholder = "Search name or type"
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func loadData() {
        guard !viewModel.isLoading && !viewModel.isLastPage else { return }
        viewModel.isLoading = true
        showAlert()
        viewModel.getPokemons(completion: { [weak self] in
            guard let self = self else { return }
            
            self.hideAlert()
            let startIndex = self.viewModel.currentPage * PokedexViewModel.itemsPerPage
            let endIndex = min(startIndex + PokedexViewModel.itemsPerPage, self.viewModel.filteredList.count)
            
            guard startIndex < self.viewModel.filteredList.count else {
                self.viewModel.isLoading = false
                self.viewModel.isLastPage = true
                self.manageTableViewVisibility()
                return
            }
            
            self.viewModel.displayedList.append(contentsOf: self.viewModel.filteredList[startIndex..<endIndex])
            self.viewModel.currentPage += 1
            self.viewModel.isLoading = false
            self.tableView.reloadData()
            self.manageTableViewVisibility()
        })
    }
    
    private func setupEmptyLabel() {
        emptyLabel.text = "No Pokémon found."
        emptyLabel.font = UIFont.systemFont(ofSize: 18)
        emptyLabel.textColor = .gray
        emptyLabel.textAlignment = .center
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyLabel)
        
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func manageTableViewVisibility() {
        if viewModel.displayedList.isEmpty && !viewModel.isLoading {
            emptyLabel.isHidden = false
            tableView.isHidden = true
        } else {
            emptyLabel.isHidden = true
            tableView.isHidden = false
        }
    }
    
    private func showAlert() {
        alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating()

        alert?.view.addSubview(loadingIndicator)
        if let alert = alert {
            present(alert, animated: true, completion: nil)
        }
    }
    
    private func hideAlert() {
        firstLoadingView?.removeFromSuperview()
        alert?.dismiss(animated: true)
    }
}

extension PokedexViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.displayedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath) as? PokemonCell,
            indexPath.row < viewModel.displayedList.count {
            let pokemon = viewModel.displayedList[indexPath.row]
            cell.configureCell(with: pokemon)
            
            if indexPath.row == viewModel.displayedList.count - 1 {
                loadData()
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
}

extension PokedexViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterText = searchText
        viewModel.currentPage = 0
        viewModel.isLastPage = false
        viewModel.displayedList.removeAll()
        loadData()
        manageTableViewVisibility()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
