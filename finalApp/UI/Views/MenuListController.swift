//
//  MenuListController.swift
//  finalApp
//
//  Created by IŞIL VARDARLI on 13.09.2023.
//

import UIKit

class MenuListController: UITableViewController{

    var items = [
        (NSLocalizedString("General", comment: ""), "general"),
        (NSLocalizedString("Business", comment: ""), "business"),
        (NSLocalizedString("Entertainment", comment: ""), "entertainment"),
        (NSLocalizedString("Health", comment: ""), "health"),
        (NSLocalizedString("Science", comment: ""), "science"),
        (NSLocalizedString("Sports", comment: ""), "sports"),
        (NSLocalizedString("Technology", comment: ""), "technology")
    ]

    
    let darkColor = UIColor(hex: 0x730202)

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = darkColor
        tableView.register(UITableViewCell.self,forCellReuseIdentifier: "cell")
        
        // Stack view'ların height değerini artırmak için aşağıdaki kodu ekleyin
        let stackViewHeight: CGFloat = 60.0 // İstediğiniz yüksekliği ayarlayın
        tableView.rowHeight = stackViewHeight
        tableView.estimatedRowHeight = stackViewHeight
        
    }

    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].0
        cell.textLabel?.textColor = .white
        cell.backgroundColor = darkColor
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedCategory = items[indexPath.row].1 // Seçilen kategori adı
        // Seçilen kategori adını bildirimle gönderin
        NotificationCenter.default.post(name: Notification.Name("CategorySelected"), object: selectedCategory)
    }
}

