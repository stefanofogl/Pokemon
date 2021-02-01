//
//  TabBarController.swift
//  Pokemon
//
//  Created by Stefano Foglia on 01/02/21.
//

import UIKit

class TabBarController: UITabBarController {

//    Configure tab bar
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainPink()
        UITabBar.appearance().barTintColor = .mainPink()
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = .white
        setupVCs()
    }
    

    private func setupVCs() {
        
        let layout = UICollectionViewFlowLayout()
        
        let allPokeList = UINavigationController(rootViewController: PokeListCollectionViewController(collectionViewLayout: layout))
        let allPokeItem = UITabBarItem(tabBarSystemItem: .mostViewed, tag: 0)
        allPokeItem.title = nil

        allPokeList.tabBarItem = allPokeItem
        
        let savedPokeList = UINavigationController(rootViewController: SavedPokeCollectionViewController(collectionViewLayout: layout))
        
        let savedPokeItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
        savedPokeList.tabBarItem = savedPokeItem
        
        viewControllers = [ allPokeList, savedPokeList ]
        
        tabBar.items?[0].title = "Pokemon"
        tabBar.items?[1].title = "Saved Pokemon"
    }

}

