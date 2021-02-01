//
//  PokemonDetailsViewController.swift
//  Pokemon
//
//  Created by Stefano Foglia on 01/02/21.
//

import UIKit

class PokemonDetailsViewController: UIViewController {
    
    // MARK: - Properties
    let viewModel = PokeDetailsViewModel()

    var pokemon: Pokemon?
    var isSaveMode = false
    var details: PokemonDetails?
    
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    let imagesStackView = UIStackView()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let infoView: InfoView = {
        let view = InfoView()
        view.configureView()
        return view
    }()
    
    let firstExtraImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let secondExtraImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .mainPink()
        button.setTitle("Save Pokemon", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        return button
    }()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewComponents()
        setConstraints()
        setupObservables()
        checkMode()
    }
    
    //    Observer on the change of state in viewModel
    private func setupObservables() {
        viewModel.state.bind { [weak self] (state) in
            switch state {
            case .initial:
                DispatchQueue.main.async {
                    ActivityIndicator.shared.hideActivityIndicator()
                    self?.refreshUI()
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
            case .successSave:
                DispatchQueue.main.async {
                    if self!.isSaveMode {
                        self?.saveButton.setTitle("Delete", for: .normal)
                    } else {
                        self?.saveButton.isEnabled = false
                        self?.saveButton.setTitle("Saved!", for: .normal)
                    }
                }
            case .errorSave:
                DispatchQueue.main.async {
                AlertView.shared.showError(title: "Error", message: "Something went wrong!", view: self)
                }
            case .successDelete:
                DispatchQueue.main.async {
                self?.navigationController?.popViewController(animated: true)
                }
            case .none:
                break
            }
        }

        saveButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }

//    if is in saved pokemon section button action is to delete else is to save
    @objc func buttonAction() {
        if isSaveMode {
            viewModel.deletePokemon(id: pokemon!.id)
        } else {
            viewModel.savePokemon(pokemon: pokemon!)
        }
    }

    func refreshUI() {
        navigationItem.title = viewModel.details?.fullName.capitalized
        imageView.image = viewModel.details?.images[0]
        if viewModel.details?.images.count ?? 0 > 1 {
            firstExtraImageView.image = viewModel.details?.images[1]
        }
        if viewModel.details?.images.count ?? 0 > 2 {
            secondExtraImageView.image = viewModel.details?.images[2]
        }
        infoView.pokemonDetails = viewModel.details
    }

    // MARK: - Helper Function

    func configureViewComponents() {
        
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .white
        
        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        imagesStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        stackView.axis = .vertical
        stackView.spacing = 10;
        
        stackView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        imagesStackView.axis = .horizontal
        imagesStackView.alignment = .center
        imagesStackView.distribution = .equalCentering
        
    }
        
    
    func setConstraints() {
        imagesStackView.addArrangedSubview(firstExtraImageView)
        firstExtraImageView.anchor(top: imagesStackView.topAnchor, left: imagesStackView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        imagesStackView.addArrangedSubview(secondExtraImageView)
        secondExtraImageView.anchor(top: imagesStackView.topAnchor, left: nil, bottom: nil, right: imagesStackView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        
        stackView.addArrangedSubview(imageView)
        imageView.anchor(top: stackView.topAnchor, left: stackView.leftAnchor, bottom: nil, right: stackView.rightAnchor, paddingTop: 20, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 100, height: 100)
        
        stackView.addArrangedSubview(infoView)
        infoView.anchor(top: imageView.bottomAnchor, left: stackView.leftAnchor, bottom: nil, right: stackView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 150)

        stackView.addArrangedSubview(imagesStackView)
        imagesStackView.anchor(top: infoView.bottomAnchor, left: stackView.leftAnchor, bottom: nil, right: stackView.rightAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 100, height: 100)

        stackView.addArrangedSubview(saveButton)
        saveButton.anchor(top: imagesStackView.bottomAnchor, left: stackView.leftAnchor, bottom: nil, right: stackView.rightAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 12, paddingRight: 12, width: 0, height: 50)
    }
    
    private func checkMode() {
        if isSaveMode {
            viewModel.details = details
            saveButton.setTitle("Delete", for: .normal)
            refreshUI()
        } else {
            viewModel.fetchDetails(url: pokemon?.detailUrl ?? "")
        }
    }
}
