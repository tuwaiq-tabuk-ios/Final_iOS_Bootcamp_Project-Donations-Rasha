//
//  CategoryCollectionViewController.swift
//  Rasha-D
//
//  Created by rasha  on 28/05/1443 AH.
//

import UIKit

private let reuseIdentifier = "Cell"

class CategoryCollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    static let categories = [Category(name: "Clothes".localize(), image: UIImage(named: "clothes")!),
                             Category(name: "Medical".localize(), image: UIImage(named: "medical2")!),
                             Category(name: "Food".localize(), image: UIImage(named: "food")!),
                             Category(name: "Furniture".localize(), image: UIImage(named: "furniture")!),
                             Category(name: "Electric".localize(), image: UIImage(named: "electric")!),
                             Category(name: "Books".localize(), image: UIImage(named: "books")!)]
    
    static var selectedCategory = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .clear
        setGradientBackground()
        
        // Register cell classes
        self.collectionView!.register(UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return CategoryCollectionVC.categories.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CategoryCell
        
        cell.CategoryNameLabel.text = CategoryCollectionVC.categories[indexPath.row].name
        cell.CategoryImageView.image = CategoryCollectionVC.categories[indexPath.row].image
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dimension = (collectionView.frame.size.width - 5) / 2
        return CGSize(width: dimension, height: dimension)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        CategoryCollectionVC.selectedCategory = CategoryCollectionVC.categories[indexPath.row].name
        self.tabBarController?.selectedIndex = 0
    }
    
}
