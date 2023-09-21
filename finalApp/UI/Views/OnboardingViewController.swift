//
//  OnboardingViewController.swift
//  finalApp
//
//  Created by IŞIL VARDARLI on 9.09.2023.
//

import UIKit

protocol OnboardingDelegate: class {
    func showMainTabBarController()
}

class OnboardingViewController : UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pageControl : UIPageControl!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setupView()
        setupPageControl()
        setupCollectionView()
        showCaption(atIndex: 0)
    }
    
    private func setupView(){
        view.backgroundColor = .systemGroupedBackground
    }
    
    private func setupPageControl(){
        pageControl.numberOfPages = Slide.collection.count
    }
    
    private func setupCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.collectionViewLayout = layout
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    @IBAction func getStartedButtonTapped(_ sender: UIButton){
        performSegue(withIdentifier: K.Segue.showLoginSignUp, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segue.showLoginSignUp {
            if let destination = segue.destination as? LoginViewController {
                destination.delegate = self
            }
        }
    }
    
    private func showCaption(atIndex index: Int){
        let slide = Slide.collection[index]
        titleLable.text = slide.title
        descriptionLabel.text = slide.description
    }
    
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Slide.collection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.ReuseIdentifier.onboardingCollectionViewCell, for: indexPath) as? OnboardingCollectionViewCell else{ return UICollectionViewCell() }
        let imageName = Slide.collection[indexPath.item].imageName
        let image = UIImage(named: imageName) ?? UIImage()
        cell.configure(image: image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        showCaption(atIndex: index)
        pageControl.currentPage = index
    }
    
    
}


extension OnboardingViewController : OnboardingDelegate{
    func showMainTabBarController() {
        //dismiss login view controller
        // show main tab bar
        if let loginViewController = self.presentedViewController as? LoginViewController{
            loginViewController.dismiss(animated: true)
            PresenterManager.shared.show(vc: .mainTabBarController)
        }
        
       
    }
    
    
    
}
