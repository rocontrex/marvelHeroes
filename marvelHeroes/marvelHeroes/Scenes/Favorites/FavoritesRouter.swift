//
//  FavoritesRouter.swift
//  marvelHeroes
//
//  Created by Rodrigo Conte on 01/02/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol FavoritesRoutingLogic {
  //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol FavoritesDataPassing {
  var dataStore: FavoritesDataStore? { get }
}

class FavoritesRouter: NSObject, FavoritesRoutingLogic, FavoritesDataPassing {
  weak var viewController: FavoritesViewController?
  var dataStore: FavoritesDataStore?
}