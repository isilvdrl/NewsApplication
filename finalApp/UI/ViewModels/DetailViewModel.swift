//
//  DetailViewModel.swift
//  finalApp
//
//  Created by IŞIL VARDARLI on 17.09.2023.
//

import Foundation
import RxSwift

class DetailViewModel{
    
    let databaseManager = DatabaseManager.shared
    
    func saveOrDeleteNewsItem(_ newsItem: Article) -> Observable<Void> {
        return Observable.create { [weak self] observer in
            // Veritabanında kaydın olup olmadığını kontrol edin
            if self?.databaseManager.isNewsItemSaved(title: newsItem.title ?? "") ?? false {
                // Kayıt veritabanında mevcut, bu nedenle silin
                self?.databaseManager.deleteNewsItem(title: newsItem.title ?? "")
                print("Haber silindi.")
            } else {
                // Kayıt veritabanında mevcut değil, bu nedenle ekle
                self?.databaseManager.insertNewsItem(
                    title: newsItem.title ?? "",
                    description: newsItem.description ?? "",
                    content: newsItem.content ?? "",
                    publishedAt: newsItem.publishedAt ?? "",
                    sourceName: newsItem.source.name,
                    author: newsItem.author ?? "",
                    urlToImage: newsItem.urlToImage ?? "",
                    url: newsItem.url 
                )
                .subscribe(
                    onNext: { [weak self] in
                        print("Veritabanı işlemi tamamlandı.")

                    },
                    onError: { [weak self] error in
                        print("Veritabanı işlemi sırasında hata oluştu: \(error.localizedDescription)")
                    }
                )
                .disposed(by: DisposeBag()) 
            }
            
            return Disposables.create()
        }
    }
    
    func isNewsItemSaved(title: String) -> Bool {
        return databaseManager.isNewsItemSaved(title: title)
    }
    
}
