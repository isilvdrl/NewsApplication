//
//  DatabaseManager.swift
//  finalApp
//
//  Created by IŞIL VARDARLI on 6.09.2023.
//

import RxSwift


class DatabaseManager {
    static let shared = DatabaseManager()

    private let db: FMDatabase
    
    init() {
        let dosyaYolu = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let veritabaniURL = URL(fileURLWithPath: dosyaYolu).appendingPathComponent("NewsAppDb.sqlite")
        db = FMDatabase(path: veritabaniURL.path)
        if db.open() {
            print("Veritabanına başarılı bir şekilde bağlandınız.")
        } else {
            print("Veritabanına bağlanırken bir hata oluştu.")
        }

        createTable()
        
    }
    
    func createTable() {
        do {
            try db.executeUpdate("CREATE TABLE IF NOT EXISTS SavedNews (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, content TEXT, publishedAt TEXT, sourceName TEXT, author TEXT, urlToImage TEXT, url TEXT);", values: nil)
        } catch {
            print("Tablo oluşturulurken hata oluştu: \(error.localizedDescription)")
        }
    }
    func insertNewsItem(title: String, description: String, content: String, publishedAt: String, sourceName: String, author: String, urlToImage: String, url: String) -> Observable<Void> {
        return Observable.create { [weak self] observer in
            self?.db.open()
            do {
                let insertSQL = "INSERT INTO SavedNews (title, description, content, publishedAt, sourceName, author, urlToImage, url) VALUES (?, ?, ?, ?, ?, ?, ?, ?);"
                try self?.db.executeUpdate(insertSQL, values: [title, description, content, publishedAt, sourceName, author, urlToImage, url])
                observer.onNext(())
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }

            self?.db.close()
            return Disposables.create()
        }
    }

    func isNewsItemSaved(title: String) -> Bool {
        self.db.open()
        defer {
            self.db.close()
        }
        do {
            let querySQL = "SELECT * FROM SavedNews WHERE title = ?;"
            let result = try self.db.executeQuery(querySQL, values: [title])
            return result.next()
        } catch {
            print("Hata: \(error.localizedDescription)")
            return false
        }
    }

    func deleteNewsItem(title: String) {
        self.db.open()
        defer {
            self.db.close()
        }
        do {
            let deleteSQL = "DELETE FROM SavedNews WHERE title = ?;"
            try self.db.executeUpdate(deleteSQL, values: [title])
        } catch {
            print("Hata: \(error.localizedDescription)")
        }
    }

    func getAllSavedNews() {
        let querySQL = "SELECT * FROM SavedNews;"
        do {
            let result = try db.executeQuery(querySQL, values: nil)
            while result.next() {
                // Her bir satırın verilerini konsola yazdırın
                print("Title: \(result.string(forColumn: "title") ?? "")")
                //print("Description: \(result.string(forColumn: "description") ?? "")")
                // Diğer sütunları da burada aynı şekilde yazdırabilirsiniz
            }
        } catch {
            print("Verileri çekerken hata oluştu: \(error.localizedDescription)")
        }
    }

    
    func getSavedNews() -> Single<[Article]> {
        return Single.create { [weak self] single in
            self?.db.open()
            var news: [Article] = []
            do {
                let querySQL = "SELECT * FROM SavedNews;"
                let result = try self?.db.executeQuery(querySQL, values: nil)
                while result?.next() ?? false {
                    if let title = result?.string(forColumn: "title"),
                       let description = result?.string(forColumn: "description"),
                       let content = result?.string(forColumn: "content"),
                       let publishedAt = result?.string(forColumn: "publishedAt"),
                       let sourceName = result?.string(forColumn: "sourceName"),
                       let author = result?.string(forColumn: "author"),
                       let urlToImage = result?.string(forColumn: "urlToImage"),
                       let url = result?.string(forColumn: "url") {

                        let source = Source(id: nil, name: sourceName)
                        let article = Article(source: source, author: author, title: title, description: description, url: url, urlToImage: urlToImage, publishedAt: publishedAt, content: content)
                      //  print("Title: \(title)")
                      //  print("Description: \(description)" )
                        news.append(article)
                    }
                }
                single(.success(news))
            } catch  {
                print(error.localizedDescription)
            }
            self?.db.close()
            return Disposables.create()
        }
    }


    func resetTable() {
        db.open()
        
        do {
            let deleteSQL = "DELETE FROM SavedNews;"
            try db.executeUpdate(deleteSQL, values: nil)
            print("Tablo sıfırlandı.")
        } catch {
            print("Tabloyu sıfırlarken hata oluştu: \(error.localizedDescription)")
        }
        
        db.close()
    }


    
    
}

