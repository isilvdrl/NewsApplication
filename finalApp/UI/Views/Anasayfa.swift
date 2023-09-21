//
//  Anasayfa.swift
//  finalApp
//
//  Created by IŞIL VARDARLI on 5.09.2023.
//

import UIKit
import SideMenu
import RxSwift

class Anasayfa: UIViewController, UISearchBarDelegate {

    var menu: SideMenuNavigationController?
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
  
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    private var filteredNewsItems: [Article] = [] // Filtrelenmiş haberleri saklamak için bir dizi
          
    private var newsService = NetworkService()
    private var newsItems: [Article] = []
    
    private var viewModel = AnasayfaViewModel()
    

   override func viewDidLoad() {
       super.viewDidLoad()
 
       navigationBarFont(for: navigationController)
       setupView()
       // Kategori seçimi bildirimini dinleyin
        NotificationCenter.default.addObserver(self, selector: #selector(handleCategorySelection(_:)), name: Notification.Name("CategorySelected"), object: nil)
     

       let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
       view.addGestureRecognizer(tapGesture)

       // Haberleri çekmek için API isteğini gönderin
       fetchNews()
   }
    
    private func setupView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "NewsCell")
        menu = SideMenuNavigationController(rootViewController: MenuListController())
        menu?.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        searchBar.delegate = self
    }
    
    func fetchNews() {
        viewModel.fetchNews { [weak self] result in
            switch result {
            case .success(let newsItems):
                self?.newsItems = newsItems
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("Error fetching news: \(error)")
            }
        }
    }

    
    @IBAction func didTapMenu(){
        present(menu!, animated: true)
    }
    // UISearchBarDelegate'den gelen metod
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchText.isEmpty {
                // Eğer arama metni boşsa, tüm haberleri göstermek için verileri sıfırla
                filteredNewsItems.removeAll()
            } else {
                // Haberleri başlığa göre filtrele
                filteredNewsItems = newsItems.filter { $0.title?.range(of: searchText, options: .caseInsensitive) != nil }
            }
            
            // Tabloyu yeniden yükle
            tableView.reloadData()
    }
    var searchBarIsEmpty: Bool {
           guard let text = searchBar.text else { return true }
           return text.isEmpty
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.becomeFirstResponder()
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc func handleCategorySelection(_ notification: Notification) {
        if let selectedCategory = notification.object as? String {
            print("Selected Category: \(selectedCategory)") // Konsola seçilen kategori adını yazdırın
            // Kategori seçildiğinde side menu'yu kapat
            dismiss(animated: true, completion: nil)

            // Seçilen kategoriye göre haberleri çekin ve gösterin
            fetchNewsByCategory(category: selectedCategory)
            // Scroll to the top of the table view
            scrollToTop()
        }
    }
    
    func fetchNewsByCategory(category: String) {
        viewModel.fetchNewsByCategory(category: category) { [weak self] result in
            switch result {
            case .success(let newsItems):
                self?.newsItems = newsItems
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("Error fetching news by category: \(error)")
            }
        }
    }
    // Örnek kullanım
    func saveNewsToDatabase(title: String, description: String, content: String, publishedAt: String, sourceName: String, author: String, urlToImage: String, url: String) {
        viewModel.saveNewsToDatabase(
            title: title,
            description: description,
            content: content,
            publishedAt: publishedAt,
            sourceName: sourceName,
            author: author,
            urlToImage: urlToImage,
            url: url
        )
        .subscribe(
            onNext: {
                // Başarıyla kaydedildiğinde yapılacak işlemler
                print("Haber başarıyla kaydedildi.")
            },
            onError: { error in
                // Hata durumunda yapılacak işlemler
                print("Haber kaydederken hata oluştu: \(error.localizedDescription)")
            }
        )
        .disposed(by: disposeBag) // DisposeBag'inizin uygun şekilde tanımlandığından emin olun
    }

    func scrollToTop() {
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }

}


extension Anasayfa: UITableViewDataSource, UITableViewDelegate {
    /*
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let saveAction = UITableViewRowAction(style: .default, title: "Kaydet") { [weak self] (action, indexPath) in
            // Kaydet butonuna tıklandığında yapılacak işlem
            if let newsCell = tableView.cellForRow(at: indexPath) as? NewsTableViewCell {

            newsCell.setEditing(false, animated: true)
            }
        }
      
        return [saveAction]
    }*/
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBarIsEmpty {
               return newsItems.count
           } else {
               return filteredNewsItems.count
           }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsTableViewCell
        let newsItem: Article
                
                if searchBarIsEmpty {
                    newsItem = newsItems[indexPath.row]
                } else {
                    newsItem = filteredNewsItems[indexPath.row]
                }
                
        cell.titleLabel?.text = newsItem.title ?? "Başlık Yok"
        cell.descriptionLabel?.text = newsItem.description ?? "Açıklama Yok"
        cell.imageUrl = newsItem.urlToImage
        cell.author = newsItem.author
        cell.publishedAt = newsItem.publishedAt
        cell.sourceName = newsItem.source.name
        cell.content = newsItem.content
        cell.url = newsItem.url
     
        cell.isUserInteractionEnabled = true
        // imageView'un contentMode'unu scaleAspectFit olarak ayarla
        cell.imageView?.contentMode = .scaleAspectFit
        
        // Aşağıdaki kodu ekleyerek hücrenin resmini gösterin
        if let imageUrl = newsItem.urlToImage {
                cell.showImageFromURL(imageUrl)
        } else {
            // imageUrl değeri nil veya boşsa veya herhangi bir hata durumu varsa varsayılan resmi göster
            cell.newsImageView.image = UIImage(named: "x")
        }
        
        // Hücreye tıklama işlevi eklemek için bir gesture recognizer ekle
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCellTap(_:)))
        cell.addGestureRecognizer(tapGesture)
   
        
               
        return cell
    }
    
 
    @objc func handleCellTap(_ sender: UITapGestureRecognizer) {
        if let cell = sender.view as? NewsTableViewCell, let indexPath = tableView.indexPath(for: cell) {
            let selectedNewsItem: Article
            
            if searchBarIsEmpty {
                selectedNewsItem = newsItems[indexPath.row]
            } else {
                selectedNewsItem = filteredNewsItems[indexPath.row]
            }
            
            // Segue'yi başlatın
            performSegue(withIdentifier: "DetailSegue", sender: selectedNewsItem)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue" {
            if let detailViewController = segue.destination as? DetailViewController, let newsItem = sender as? Article {
                // Seçilen haberin bilgilerini DetailViewController'a taşıyın
                detailViewController.newsItem = newsItem
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let newsItem: Article

           if searchBarIsEmpty {
               newsItem = newsItems[indexPath.row]
           } else {
               newsItem = filteredNewsItems[indexPath.row]
           }
        
        if viewModel.isNewsItemSaved(title: newsItem.title!){
            let delete = UIContextualAction(style: .destructive, title: nil){ _,_,_ in
                print("delete button tapped")
                self.performDeleteAction(forRowAt: indexPath)
                
            }
            delete.image = UIImage(systemName: "square.and.arrow.up")
            delete.backgroundColor = UIColor(hex: 0xB57114)
            let swipe = UISwipeActionsConfiguration(actions: [delete])
            return swipe
        }else{
            
            let save = UIContextualAction(style: .destructive, title: nil){ _,_,_ in
                print("save button tapped")
                self.performSaveAction(forRowAt: indexPath)
            }
            save.image = UIImage(systemName: "square.and.arrow.down")
            save.backgroundColor = UIColor(hex: 0x706513)
            let swipe = UISwipeActionsConfiguration(actions: [save])
            return swipe
        }

    }
    
    func performSaveAction(forRowAt indexPath: IndexPath) {
        let newsItem: Article

        if searchBarIsEmpty {
            newsItem = newsItems[indexPath.row]
        } else {
            newsItem = filteredNewsItems[indexPath.row]
        }

        if !viewModel.isNewsItemSaved(title: newsItem.title!) {
            // Veritabanına haber kaydetme işlemi
            saveNewsToDatabase(
                title: newsItem.title ?? "",
                description: newsItem.description ?? "",
                content: newsItem.content ?? "",
                publishedAt: newsItem.publishedAt ?? "",
                sourceName: newsItem.source.name,
                author: newsItem.author ?? "",
                urlToImage: newsItem.urlToImage ?? "",
                url: newsItem.url
            )
        }
    }
    func performDeleteAction(forRowAt indexPath: IndexPath) {
        let newsItem: Article

        if searchBarIsEmpty {
            newsItem = newsItems[indexPath.row]
        } else {
            newsItem = filteredNewsItems[indexPath.row]
        }

        viewModel.deleteNewsItem(title: newsItem.title ?? "")
            .subscribe(onCompleted: { [weak self] in
                // Haber başarıyla silindiğinde yapılacak işlemleri burada gerçekleştirin
                print("Haber silindi.")
                // Şimdi, silinen öğeyi savedNews dizisinden kaldıralım
                //self?.newsItems.remove(at: indexPath.row)
                // TableView'ı yeniden yükleyerek güncel verileri gösterelim
                self?.tableView.reloadData()
            }, onError: { error in
                print("Hata: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }

    
}

