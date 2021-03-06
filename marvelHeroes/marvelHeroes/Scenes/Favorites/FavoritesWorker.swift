//
//  FavoritesWorker.swift
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
import CoreData

class FavoritesWorker {
    
    let coreData = FavoriteDAO()
    
    func getFavoriteCharacters(completion: (Result<[FavoriteEntity], Error>) -> Void) {
        let entityName = String(describing: FavoriteEntity.self)
        coreData.getAll(entityName: entityName, completion: completion)
    }
    
    func removeCharacterFromFavorite(id: Int, completion: (Error?) -> Void) {
        let entityName = String(describing: FavoriteEntity.self)
        coreData.get(entityName: entityName, withId: id) { (result) in
            switch result {
            case .success(let favorites):
                removeAll(favorites: favorites)
                completion(nil)
            case .failure(_):
                completion(NSError())
            }
        }
    }
    
    private func getAllFavorites(completion: (Result<[FavoriteEntity], Error>) -> Void) {
        let entityName = String(describing: FavoriteEntity.self)
        coreData.getAll(entityName: entityName, completion: completion)
    }
    
    private func removeAll(favorites: [NSManagedObject]) {
        for favorite in favorites {
            coreData.delete(object: favorite, completion: nil)
        }
    }
}

