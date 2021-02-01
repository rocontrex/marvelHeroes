//
//  FavoritesPresenter.swift
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

protocol FavoritesPresentationLogic {
    func presentFavorites(response: Favorites.GetFavorites.Response)
    func presentRemoveFromDatabase(response: Favorites.RemoveFromDatabase.Response)
    func presentError(_ error: Favorites.Error)
}

class FavoritesPresenter: FavoritesPresentationLogic {
    
    weak var viewController: FavoritesDisplayLogic?
    
    // MARK: Presentation Logic
    
    func presentFavorites(response: Favorites.GetFavorites.Response) {
        let names = response.favorites.map({$0.name ?? "-"})
        let viewModel = Favorites.GetFavorites.ViewModel(names: names)
        viewController?.displayFavorites(viewModel: viewModel)
    }
    
    func presentRemoveFromDatabase(response: Favorites.RemoveFromDatabase.Response) {
        let viewModel = Favorites.RemoveFromDatabase.ViewModel(indexPath: response.indexPath)
        viewController?.displayRemoveFromDatabase(viewModel: viewModel)
    }
    
    func presentError(_ error: Favorites.Error) {
        viewController?.displayError(error)
    }
}