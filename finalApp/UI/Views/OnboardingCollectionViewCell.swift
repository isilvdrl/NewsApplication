//
//  OnboardingCollectionViewCell.swift
//  finalApp
//
//  Created by IŞIL VARDARLI on 10.09.2023.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var slideImageView: UIImageView!
    
    func configure(image: UIImage)
    {
        slideImageView.image = image
    }
}
