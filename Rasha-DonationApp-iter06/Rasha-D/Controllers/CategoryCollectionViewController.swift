//
//  CategoryCollectionViewController.swift
//  Rasha-D
//
//  Created by rasha  on 28/05/1443 AH.
//

import UIKit

private let reuseIdentifier = "Cell"

class CategoryCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {


    static let categories = [Category(name: "Clothes", image: UIImage(systemName: "person")!),
                             Category(name: "Books", image: UIImage(systemName: "person")!),
                             Category(name: "Electrics", image: UIImage(systemName: "person")!),
                             Category(name: "Devices", image: UIImage(systemName: "person")!),]
    
    static var selectedCategory = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        return CategoryCollectionViewController.categories.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CategoryCell
    
        cell.CategoryNameLabel.text = CategoryCollectionViewController.categories[indexPath.row].name
        cell.CategoryImageView.image = CategoryCollectionViewController.categories[indexPath.row].image
    
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dimension = (collectionView.frame.size.width - 5) / 2
        return CGSize(width: dimension, height: dimension)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        CategoryCollectionViewController.selectedCategory = CategoryCollectionViewController.categories[indexPath.row].name
        self.tabBarController?.selectedIndex = 0
    }
    
}
