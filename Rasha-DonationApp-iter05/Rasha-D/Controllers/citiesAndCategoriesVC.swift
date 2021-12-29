//
//  citiesAndCategoriesVC.swift
//  Rasha-D
//
//  Created by rasha  on 24/05/1443 AH.
//

import UIKit
protocol citiesAndCategoriesVCDelegate {
    func citySelected(cityName : String)
}

class citiesAndCategoriesVC: UIViewController , UIPickerViewDelegate , UIPickerViewDataSource {
  
    
    
    
    let cities = ["Tabuk", "Jeddah", "Abha", "Ryadh","Maccah" , "Taife"]
    

    @IBOutlet weak var pickerView: UIPickerView!
    
    var delegate : citiesAndCategoriesVCDelegate!
    
    var selectedCity = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pickerView.delegate = self
        pickerView.dataSource = self
        
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cities.count
    }

    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cities[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCity = cities[row]
    }
    
    
    

    @IBAction func doneButtonAction(_ sender: Any) {
        
        delegate.citySelected(cityName: selectedCity)
        self.dismiss(animated: true, completion: nil)
    }
}
