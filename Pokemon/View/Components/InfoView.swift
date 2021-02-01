//
//  InfoView.swift
//  Pokemon
//
//  Created by Stefano Foglia on 01/02/21.
//

import UIKit

class InfoView: UIView {
    
    var pokemonDetails: PokemonDetails?
    {
        didSet {
            guard let details = self.pokemonDetails else { return }

            let sortedKeys = details.stats.sorted(by: { $0.0 < $1.0 })
            configureLabel(label: typeLabel, title: "Type", details: details.type)
            configureLabel(label: weightLabel, title: "Weight", details: "\(details.weight)")
            configureLabel(label: defenseLabel, title: sortedKeys[1].key.capitalized, details: sortedKeys[1].value.capitalized)
            configureLabel(label: hpLabel, title: sortedKeys[2].key.capitalized, details: sortedKeys[2].value.capitalized)
            configureLabel(label: attackLabel, title: sortedKeys[0].key.capitalized, details: sortedKeys[0].value.capitalized)
            configureLabel(label: specialAttackLabel, title: sortedKeys[3].key.capitalized, details: sortedKeys[3].value.capitalized)
        }
    }
    
    let typeLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let defenseLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let hpLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let speedLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let attackLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let weightLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let specialAttackLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper Functions
    

    func configureLabel(label: UILabel, title: String, details: String) {
        let attributedText = NSMutableAttributedString(attributedString: NSAttributedString(string: "\(title):  ", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.mainPink()]))
        attributedText.append(NSAttributedString(string: "\(details)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.gray]))
        label.attributedText = attributedText
    }

    func configureView() {
        addSubview(typeLabel)
        typeLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(defenseLabel)
        defenseLabel.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        
        let separatorView = UIView()
        separatorView.backgroundColor = .groupTableViewBackground
        addSubview(separatorView)
        separatorView.anchor(top: typeLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 4, paddingBottom: 0, paddingRight: 4, width: 0, height: 1)
        
        addSubview(hpLabel)
        hpLabel.anchor(top: separatorView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(weightLabel)
        weightLabel.anchor(top: hpLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(speedLabel)
        speedLabel.anchor(top: separatorView.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        
        addSubview(specialAttackLabel)
        specialAttackLabel.anchor(top: separatorView.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)

        addSubview(attackLabel)
        attackLabel.anchor(top: specialAttackLabel.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
    }
    
}

