//
//  DataPersistanceManager.swift
//  Netflix Clone
//
//  Created by oeng hokleng on 22/3/23.
//

import UIKit
import CoreData


class DataPersistanceManager {
    
    enum DatabasError: Error {
        case failToSaveData
        case failToFetchData
        case failToDeleteData
    }
    
    static let shared = DataPersistanceManager()
    
    func downloadTitleWith(model: Title, completion: @escaping (Result<Void, Error>) -> Void){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let item = TitleItem(context: context)
        item.original_title = model.original_title ?? "Unknow"
        item.overview = model.overview
        item.poster_path = model.poster_path
        item.id = Int64(model.id)
        item.media_type = model.media_type
        item.vote_count = Int64(model.vote_count)
        item.vote_average = model.vote_average
        item.release_date = model.release_date
        
        do {
            try context.save()
            
            completion(.success(()))
        }catch {
            completion(.failure(DatabasError.failToSaveData))
        }
    
    }
    
    func fetchingMoviesFromDataBase(completion: @escaping (Result<[TitleItem], Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<TitleItem>
        request = TitleItem.fetchRequest()
        
        do {
            let titles =  try context.fetch(request)
            completion(.success(titles))
        }catch {
            print(error.localizedDescription)
            completion(.failure(DatabasError.failToFetchData))
        }
    }
    
    func deleteTitleWith(model: TitleItem, completion: @escaping (Result<Void, Error>) -> Void){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model)
        
        do {
            try context.save()
            completion(.success(()))
        }catch {
            completion(.failure(DatabasError.failToDeleteData))
        }
        
    }
}
