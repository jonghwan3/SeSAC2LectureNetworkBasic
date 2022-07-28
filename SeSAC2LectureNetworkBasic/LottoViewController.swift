//
//  LottoViewController.swift
//  SeSAC2LectureNetworkBasic
//
//  Created by 박종환 on 2022/07/28.
//

import UIKit

class LottoViewController: UIViewController {

    @IBOutlet weak var numberTextField: UITextField!
    
    var lottoPickerView = UIPickerView() //
    
    let numberList: [Int] = Array(1...1025).reversed()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberTextField.inputView = lottoPickerView
        numberTextField.tintColor = .clear
        
        lottoPickerView.delegate = self
        lottoPickerView.dataSource = self
    }
    
    @IBAction func numberTextFieldDidEndOnExit(_ sender: UITextField) {
    }
    
}

extension LottoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numberList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        numberTextField.text = "\(numberList[row])회차"
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(numberList[row])회차"
    }

}
