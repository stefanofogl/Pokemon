//
//  SavedPokeCollectionViewController.swift
//  Pokemon
//
//  Created by Stefano Foglia on 01/02/21.
//

import UIKit

private let reuseIdentifier = "Cell"

class SavedPokeCollectionViewController: UICollectionViewController {

    let viewModel = SavedPokeViewModel()
    var pokemonList = [Pokemon]()
    var detailList = [PokemonDetails]()
    var filteredPokemon = [Pokemon]()
    var filteredDetail = [PokemonDetails]()
    var searchBar: UISearchBar!
    var inSearchMode = false

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewComponents()
        setupObservables()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchSavedPokemon()
    }

    //    Observer on the change of state in viewModel
    private func setupObservables() {
        viewModel.state.bind { [weak self] (state) in
            switch state {
            case .initial:
                self?.pokemonList = self?.viewModel.pokemonList ?? []
                self?.detailList = self?.viewModel.detailList ?? []
                DispatchQueue.main.async {
                    ActivityIndicator.shared.hideActivityIndicator()
                    self?.collectionView.reloadData()
                }
            case .loading:
                DispatchQueue.main.async {
                    ActivityIndicator.shared.showActivityIndicatory(view: self)
                }
            case .error:
                DispatchQueue.main.async {
                    ActivityIndicator.shared.hideActivityIndicator()
                    AlertView.shared.showError(title: "Error", message: "Something went wrong!", view: self)
                }
            case .noData:
                self?.pokemonList = []
                self?.detailList = []
                DispatchQueue.main.async {
                    ActivityIndicator.shared.hideActivityIndicator()
                    AlertView.shared.showError(title: "No pokemon saved", message: "Tap on save button on pokemon details", view: self)
                    self?.collectionView.reloadData()
                }
            case .none:
                break
            }
        }
    }

    func configureViewComponents() {
        collectionView.backgroundColor = .white
        
        navigationController?.navigationBar.barTintColor = .mainPink()
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.title = "Pokedex"
        
        configureSearchBarButton()
        
        collectionView.register(PokeListCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
    }

    func configureSearchBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchBar))
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    func configureSearchBar() {
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.showsCancelButton = true
        searchBar.becomeFirstResponder()
        searchBar.tintColor = .white
        
        navigationItem.rightBarButtonItem = nil
        navigationItem.titleView = searchBar
    }

    @objc func showSearchBar() {
        configureSearchBar()
    }

}

extension SavedPokeCollectionViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.titleView = nil
        configureSearchBarButton()
        inSearchMode = false
        collectionView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" || searchBar.text == nil {
            inSearchMode = false
            collectionView.reloadData()
            view.endEditing(true)
        } else {
            inSearchMode = true
            filteredPokemon = pokemonList.filter({ $0.fullName.range(of: searchText.lowercased()) != nil })
            filteredDetail = detailList.filter({ $0.fullName.range(of: searchText.lowercased()) != nil })
            collectionView.reloadData()
        }
    }
}

extension SavedPokeCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 32, left: 8, bottom: 8, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 36) / 3
        return CGSize(width: width, height: width)
    }
}

extension SavedPokeCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return inSearchMode ? filteredPokemon.count : pokemonList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PokeListCollectionViewCell
        
        cell.pokemon = inSearchMode ? filteredPokemon[indexPath.row] : pokemonList[indexPath.row]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let controller = PokemonDetailsViewController()
        controller.pokemon = inSearchMode ? filteredPokemon[indexPath.row] : pokemonList[indexPath.row]
        controller.isSaveMode = true
        controller.details = inSearchMode ? filteredDetail[indexPath.row] : detailList[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }

}
