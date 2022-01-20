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
  
  @IBOutlet weak var pickerView: UIPickerView!
  
    var selectedButton = String()
    let cities = ["Tabuk".localize(),
                  "Jeddah".localize(),
                  "Abha".localize(),
                  "Riyadh".localize(),
                  "Makkah".localize() ,
                  "Taif".localize(),
                  "Bisha".localize(),
                  "other".localize()]
   
    var delegate : CitiesAndCategoriesVCDelegate!
    
    var selectedCity = String()
    var selectedCategory = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView.delegate = self
        pickerView.dataSource = self
        
      // set initial values for city & category
        selectedCity = cities[0]
        selectedCategory = CategoryCollectionVC.categories[0].name
        
    }
    
  // run CitiesAndCategoriesVC delegate
    @IBAction func doneButtonAction(_ sender: Any) {
        if selectedButton == "city".localize() {
            delegate.pickerSelectedRow(name: selectedCity, selectedButton: selectedButton)
        } else {
            delegate.pickerSelectedRow(name: selectedCategory, selectedButton: selectedButton)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
  // MARK: - PickerView Delegate & Data Source
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
   
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if selectedButton == "city".localize() {
            return cities.count
        }else {
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
            selectedCity = cities[row]
        }else {
            selectedCategory = CategoryCollectionVC.categories[row].name
        }
        
    }
    
    
    
}

