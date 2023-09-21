//
//  DetailViewController.swift
//  finalApp
//
//  Created by IŞIL VARDARLI on 6.09.2023.
//

import UIKit
import RxSwift

class DetailViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var publishedAtLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    let databaseManager = DatabaseManager.shared // Veritabanı yöneticisini oluşturun
    
    var newsItem: Article?
    private let disposeBag = DisposeBag()
    
    private var detailViewModel = DetailViewModel()

    @IBAction func saveButtonTapped(_ sender: UIButton) {
   
        if let newsItem = newsItem {
            detailViewModel.saveOrDeleteNewsItem(newsItem)
                .subscribe(
                    onNext: { [weak self] in
                        print("Veritabanı işlemi tamamlandı.")
                    },
                    onError: { [weak self] error in
                        print("Veritabanı işlemi sırasında hata oluştu: \(error.localizedDescription)")
                    }
                )
                .disposed(by: disposeBag)
        }
        // Sayfayı yeniden yükler
        setupView()
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarFont(for: navigationController)
        setupView()
        updateTextColor()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateTextColor()
    }

    private func updateTextColor() {
        if self.traitCollection.userInterfaceStyle == .dark {
            // Dark mode is enabled
            titleLabel.textColor = .white
            descriptionLabel.textColor = .white
            contentLabel.textColor = .white
            publishedAtLabel.textColor = .white
            sourceLabel.textColor = .white
            authorLabel.textColor = .white
        } else {
            // Light mode is enabled
            titleLabel.textColor = .black
            descriptionLabel.textColor = .black
            contentLabel.textColor = .black
            publishedAtLabel.textColor = .black
            sourceLabel.textColor = .black
            authorLabel.textColor = .black
        }
    }
    private func setupView(){
        if let newsItem = newsItem {
            titleLabel.text = newsItem.title ?? "Başlık Yok"
            titleLabel.sizeToFit()
            descriptionLabel.text = newsItem.description ?? "Açıklama Yok"
            descriptionLabel.sizeToFit()
            
            contentLabel.text = newsItem.content ?? "İçerik Yok"
            contentLabel.sizeToFit()
            
            publishedAtLabel.text = newsItem.publishedAt ?? "İçerik Yok"
            publishedAtLabel.sizeToFit()
            
            sourceLabel.text = newsItem.source.name
            sourceLabel.sizeToFit()
            
            authorLabel.text = newsItem.author ?? "-"
            authorLabel.sizeToFit()
            
            let saveImageName = detailViewModel.isNewsItemSaved(title: newsItem.title ?? "") ? "square.and.arrow.up" : "square.and.arrow.down"
            let saveButton = UIBarButtonItem(image: UIImage(systemName: saveImageName), style: .plain, target: self, action: #selector(saveButtonTapped(_:)))
            navigationItem.rightBarButtonItem = saveButton

            
            if let imageUrl = newsItem.urlToImage, let imageURL = URL(string: imageUrl) {
                let task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.imageView.image = image
                        }
                    }
                    else if let error = error {
                        print("Resim yüklenirken hata oluştu: \(error.localizedDescription)")
                        // Hata durumunda varsayılan bir resmi göster
                        DispatchQueue.main.async {
                            self.imageView.image = UIImage(named: "Default")
                        }
                    }
                    
                }
                task.resume()
            } else {
                // Eğer resim URL'si yoksa veya URL geçersizse, bir varsayılan resim gösterebilirsiniz.
                self.imageView.image = UIImage(named: "Default") 
            }
        }
        
    }
   
}


   







