//
//  citiesAndCategoriesVC.swift
//  Rasha-D
//
//  Created by rasha  on 24/05/1443 AH.
//

import UIKit
protocol CitiesAndCategoriesVCDelegate {
    func pickerSelectedRow(name : String, selectedButton : String)
    
}

class citiesAndCategoriesVC: UIViewController , UIPickerViewDelegate , UIPickerViewDataSource {
    
    
    var selectedButton = String()
    
    
    let cities = ["Tabuk".localize(),
                  "Jeddah".localize(),
                  "Abha".localize(),
                  "Riyadh".localize(),
                  "Makkah".localize() ,
                  "Taif".localize(),
                  "Bisha".localize(),
                  "other".localize()]
    
    
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    var delegate : CitiesAndCategoriesVCDelegate!
    
    var pickerSelectedRow = String()
    var selectedCategory = String()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        pickerView.delegate = self
        pickerView.dataSource = self
        
        pickerSelectedRow = cities[0]
        selectedCategory = CategoryCollectionVC.categories[0].name
        
    }
    
    @IBAction func doneButtonAction(_ sender: Any) {
        if selectedButton == "city".localize() {
            delegate.pickerSelectedRow(name: pickerSelectedRow, selectedButton: selectedButton)
        } else {
            delegate.pickerSelectedRow(name: selectedCategory, selectedButton: selectedButton)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if selectedButton == "city".localize() {
            return cities.count
            
        }else  {
            return CategoryCollectionVC.categories.count
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if selectedButton == "city".localize() {
            return cities[row]
            
        }else {
            return CategoryCollectionVC.categories[row].name
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if selectedButton == "city".localize() {
            pickerSelectedRow = cities[row]
        }else {
            selectedCategory = CategoryCollectionVC.categories[row].name
        }
        
    }
    
    
    
}

