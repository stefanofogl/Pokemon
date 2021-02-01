//
//  PokeListCollectionViewController.swift
//  Pokemon
//
//  Created by Stefano Foglia on 01/02/21.
//

import UIKit

private let reuseIdentifier = "Cell"

class PokeListCollectionViewController: UICollectionViewController {

    let viewModel = PokeListViewModel()
    var pokemonList = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    var searchBar: UISearchBar!
    var inSearchMode = false
    var collectionViewFlowLayout: UICollectionViewFlowLayout!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewComponents()
        setupObservables()
        viewModel.checkInternetConnection()
    }
    
    private func setupObservables() {
        viewModel.state.bind { [weak self] (state) in
            switch state {
            case .initial:
                self?.pokemonList = self?.viewModel.pokemonList ?? []
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
            case .connectionError:
                DispatchQueue.main.async {
                    ActivityIndicator.shared.hideActivityIndicator()
                    AlertView.shared.showError(title: "Connection error", message: "You can only view saved pokemon in favourites section", view: self)
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
        
        collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionView.setCollectionViewLayout(collectionViewFlowLayout, animated: true)
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

extension PokeListCollectionViewController: UISearchBarDelegate {
    
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
            collectionView.reloadData()
        }
    }
}

extension PokeListCollectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 32, left: 8, bottom: 8, right: 8)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = (view.frame.width - 36) / 3
        return CGSize(width: width, height: width)
    }
}

extension PokeListCollectionViewController {

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
        navigationController?.pushViewController(controller, animated: true)
    }
}
