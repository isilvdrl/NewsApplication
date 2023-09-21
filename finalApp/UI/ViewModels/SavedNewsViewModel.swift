//
//  SavedNewsViewModel.swift
//  finalApp
//
//  Created by IŞIL VARDARLI on 18.09.2023.
//

import Foundation
import RxSwift

class SavedNewsViewModel{
    
    private let databaseManager = DatabaseManager.shared

    func getSavedNews() -> Single<[Article]> {
        return databaseManager.getSavedNews()
    }
    
    func deleteNewsItem(title: String) -> Completable {
        return Completable.create { [weak self] completable in
            self?.databaseManager.deleteNewsItem(title: title)
            completable(.completed)
            return Disposables.create()
        }
    }

}
