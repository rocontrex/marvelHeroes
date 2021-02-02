//
//  CharactersRouter.swift
//  marvelHeroes
//
//  Created by Rodrigo Conte on 31/01/21.
//  Copyright (c) 2021 Rodrigo Conte. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol CharactersRoutingLogic {
    func routeToDetail()
}

protocol CharactersDataPassing {
    var dataStore: CharactersDataStore? { get }
}

class CharactersRouter: NSObject, CharactersRoutingLogic, CharactersDataPassing {
    
    weak var viewController: CharactersViewController?
    var dataStore: CharactersDataStore?
    
    // MARK: Routing
    
    func routeToDetail() {
        let destinationVC = DetailsFactory.setupController()
        guard var destinationDS = destinationVC.router?.dataStore else { return }
        guard let indexPath = viewController?.tableView.indexPathForSelectedRow else { return }
        destinationDS.character = dataStore?.charactersBeingDisplayed[indexPath.row]

        viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
}
