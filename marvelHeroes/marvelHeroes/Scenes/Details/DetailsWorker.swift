//
//  DetailsWorker.swift
//  marvelHeroes
//
//  Created by Rodrigo Conte on 01/02/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import Foundation
import UIKit
import CoreData

class DetailsWorker {
    
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    func getFavoriteCharacter(withId id: Int, completion: (Result<[FavoriteEntity], Error>) -> Void) {
        let entityName = String(describing: FavoriteEntity.self)
        FavoriteDAO().get(entityName: entityName, withId: id, completion: completion)
    }
    
    func requestImage(fromURL url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    completion(.success(image))
                } else {
                    completion(.failure(error ?? NSError()))
                }
            }
        }.resume()
    }
    
    func saveCharacterOnFavorite(name: String, id: Int, completion: (Error?) -> Void) {
        let object = FavoriteEntity(context: context)
        object.name = name
        object.id = Int32(id)
        
        FavoriteDAO().save(object: object, completion: completion)
    }
    
    func removeCharacterFromFavorite(id: Int, completion: (Error?) -> Void) {
        let entityName = String(describing: FavoriteEntity.self)
        FavoriteDAO().get(entityName: entityName, withId: id) { (result) in
            switch result {
            case .success(let favorites):
                for favorite in favorites {
                    FavoriteDAO().delete(object: favorite, completion: nil)
                }
                completion(nil)
            case .failure:
                completion(NSError())
            }
        }
    }
}