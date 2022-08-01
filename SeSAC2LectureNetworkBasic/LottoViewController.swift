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
        
        pickerView(lottoPickerView, didSelectRow: 0, inComponent: 0)
    }
    
    @IBAction func numberTextFieldDidEndOnExit(_ sender: UITextField) {
        
    }
    
    
    func requestLotto(number: Int) {
        
        //AF: 200~299 status code 301
        let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(number)"
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
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(numberList[row])회차"
    }

}
