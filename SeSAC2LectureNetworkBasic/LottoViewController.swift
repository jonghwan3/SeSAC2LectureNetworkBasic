//
//  LottoViewController.swift
//  SeSAC2LectureNetworkBasic
//
//  Created by 박종환 on 2022/07/28.
//

import UIKit

import Alamofire
import SwiftyJSON

class LottoViewController: UIViewController {

    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet var lottoLabelCollection: [UILabel]!
    
    var lottoCnt: Int?
    
    var lottoPickerView = UIPickerView() //
    
    let numberList: [Int] = Array(1...1025).reversed()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lottoCnt = lottoLabelCollection.count
        
        numberTextField.inputView = lottoPickerView
        numberTextField.tintColor = .clear
        
        lottoPickerView.delegate = self
        lottoPickerView.dataSource = self
        
        numberTextField.text = "\(getCurrentNumber())회차"
        
        requestLotto(number: getCurrentNumber())
    }
    
    func getCurrentNumber() -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        //2022년 7월 30일 ~ 2022년 8월 6일 1026회차
        let referDate: Date! = formatter.date(from: "2022-07-30")
        let referNumber = 1026
        
        //2022년 8월 07일 ~ 2022년 8월 14일 1027회차
        let offsetComps = Calendar.current.dateComponents([.day], from: referDate, to: Calendar.current.startOfDay(for: Date.now))
        let idx = offsetComps.day! / 7
        
        return referNumber + idx
        
    }
    
    func requestLotto(number: Int) {
        
        //AF: 200~299 status code 301
        let url = "\(EndPoint.lottoURL)&drwNo=\(number)"
        AF.request(url, method: .get).validate(statusCode: 200..<299).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                for i in 0..<self.lottoCnt! {
                    self.lottoLabelCollection[i].text = json["drwtNo\(i+1)"].stringValue
                }
                
                self.lottoLabelCollection[self.lottoCnt! - 1].text = json["bnusNo"].stringValue
            
            case .failure(let error):
                print(error)
            }
        }
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
        requestLotto(number: numberList[row])
        numberTextField.text = "\(numberList[row])회차"
        //view.endEditing(true)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(numberList[row])회차"
    }

}
