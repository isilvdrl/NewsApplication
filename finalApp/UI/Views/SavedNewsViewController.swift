//
//  SavedNewsViewController.swift
//  finalApp
//
//  Created by IŞIL VARDARLI on 6.09.2023.
//

import UIKit
import RxSwift

class SavedNewsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var savedNews: [Article] = []
    private let disposeBag = DisposeBag()
    
    var savedNewsViewModel = SavedNewsViewModel()


    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarFont(for: navigationController)
        // TableView'ı yapılandır ve verileri göster
        tableView.delegate = self
        tableView.dataSource = self
       // tableView.reloadData()
        
        // TableView konfigürasyonu
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "SavedNewsCell")
        // Veritabanından kaydedilmiş haberleri çek
        loadSavedNews()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Veritabanından kaydedilmiş haberleri yeniden yükle
        loadSavedNews()
        
        // TableView'ı yeniden yükle
        tableView.reloadData()
    }
    
    // Veritabanından kaydedilmiş haberleri çek
    func loadSavedNews() {
        savedNewsViewModel.getSavedNews()
            .subscribe(onSuccess: { [weak self] news in
                self?.savedNews = news
                self?.tableView.reloadData()
            }, onError: { error in
                print("Hata: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }

   
}


extension SavedNewsViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // TableView veri kaynakları
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedNewsCell", for: indexPath) as! NewsTableViewCell
        let newsItem = savedNews[indexPath.row]
        
        // Her hücreye haber başlığını ata
        cell.titleLabel?.text = newsItem.title ?? "Başlık Yok"
        cell.descriptionLabel?.text = newsItem.description ?? "Açıklama Yok"
        cell.imageUrl = newsItem.urlToImage
        cell.isUserInteractionEnabled = true
        
        // Aşağıdaki kodu ekleyerek hücrenin resmini gösterin
        if let imageUrl = newsItem.urlToImage {
            cell.showImageFromURL(imageUrl)
        } else {
            // imageUrl değeri nil veya boşsa veya herhangi bir hata durumu varsa varsayılan resmi göster
            cell.newsImageView.image = UIImage(named: "Default")
        }
        
        // Hücreye tıklama işlevi eklemek için bir gesture recognizer ekle
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCellTap(_:)))
        cell.addGestureRecognizer(tapGesture)
        
        
        
        return cell
    }
    
    
    // Haber hücresine tıklandığında detay sayfasına git
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedNews = savedNews[indexPath.row]
        performSegue(withIdentifier: "SavedNewsDetailSegue", sender: selectedNews)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SavedNewsDetailSegue" {
            if let detailViewController = segue.destination as? DetailViewController, let newsItem = sender as? Article {
                // Seçilen haberin bilgilerini DetailViewController'a taşıyın
                detailViewController.newsItem = newsItem
            }
        }
    }
    
    
    @objc func handleCellTap(_ sender: UITapGestureRecognizer) {
        if let cell = sender.view as? NewsTableViewCell, let indexPath = tableView.indexPath(for: cell) {
            let selectedNewsItem = savedNews[indexPath.row]
            
            // Segue'yi başlatın
            performSegue(withIdentifier: "SavedNewsDetailSegue", sender: selectedNewsItem)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: nil){ _,_,_ in
            print("delete button tapped")
            self.performDeleteAction(forRowAt: indexPath)
            
        }
        delete.image = UIImage(systemName: "square.and.arrow.up")
        delete.backgroundColor = UIColor(hex: 0xB57114)
        let swipe = UISwipeActionsConfiguration(actions: [delete])
        return swipe
    }
    
    func performDeleteAction(forRowAt indexPath: IndexPath) {
        let newsItem: Article
        newsItem = savedNews[indexPath.row]

        savedNewsViewModel.deleteNewsItem(title: newsItem.title ?? "")
            .subscribe(onCompleted: { [weak self] in
                // Haber başarıyla silindiğinde yapılacak işlemleri burada gerçekleştirin
                print("Haber silindi.")
                // Şimdi, silinen öğeyi savedNews dizisinden kaldıralım
                self?.savedNews.remove(at: indexPath.row)
                // TableView'ı yeniden yükleyerek güncel verileri gösterelim
                self?.tableView.reloadData()
            }, onError: { error in
                print("Hata: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }

    
 
    
}
