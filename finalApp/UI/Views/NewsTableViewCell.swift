import UIKit
import RxSwift

class NewsTableViewCell: UITableViewCell {
    var newsImageView: UIImageView!
    var titleLabel: UILabel!
    var descriptionLabel: UILabel!
    var imageUrl: String?
    
    var author: String?
    var publishedAt: String?
    var content: String?
    var sourceName: String?
    var url: String?
    
    private let disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // Görsel oluşturma ve ayarlama
        newsImageView = UIImageView()
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(newsImageView)

        // Başlık oluşturma ve ayarlama
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20) // Başlık yazısının fontunu 20 olarak ayarla
        titleLabel.textAlignment = .center // Başlığı sola yasla
        addSubview(titleLabel)

        // Açıklama oluşturma ve ayarlama
        descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0 // Birden fazla satırda metin görüntülemek için
        descriptionLabel.font = UIFont.systemFont(ofSize: 15) // Açıklama yazısının fontunu 15 olarak ayarla
        descriptionLabel.textAlignment = .left // Açıklamayı sola yasla
        addSubview(descriptionLabel)

        // Constraints (kısıtlamalar) ayarlama
        NSLayoutConstraint.activate([
            newsImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            newsImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            newsImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            newsImageView.heightAnchor.constraint(equalTo: newsImageView.widthAnchor, multiplier: 0.7),

            titleLabel.topAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant:  5),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showImageFromURL(_ urlString: String) {
        // URL'den resmi indirin ve gösterin
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                if let data = data, let image = UIImage(data: data), urlString == self?.imageUrl {
                    DispatchQueue.main.async {
                        self?.newsImageView.image = image
                    }
                }
                else if let error = error {
                    print("Resim yüklenirken hata oluştu: \(error.localizedDescription)")
                    // Hata durumunda varsayılan bir resmi göster
                    DispatchQueue.main.async {
                        self?.newsImageView.image = UIImage(named: "x")
                    }
                }
            }.resume()
        } else {
            // URL geçerli değilse varsayılan bir resmi göster
            DispatchQueue.main.async {
                self.newsImageView.image = UIImage(named: "x")
            }
        }
    }
    
    

}
