//
//  TranslateViewController.swift
//  SeSAC2LectureNetworkBasic
//
//  Created by 박종환 on 2022/07/28.
//

import UIKit

import Alamofire
import SwiftyJSON

//UIButton, UITextField > Action
//UITextView, UISearchBar, UIPickerView > Action X
//UIControl을 상속받았는지 안 받았는지 확인
//UIResponderChain > resignFirstResponder() / becomeFirstResponder()

class TranslateViewController: UIViewController {
    
    @IBOutlet weak var userInputTextView: UITextView!
    @IBOutlet weak var userOutputTextView: UITextView!
    
    let textViewPlaceholderText = "번역하고 싶은 문장을 작성해보세요."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userInputTextView.delegate = self
        
        userInputTextView.text = textViewPlaceholderText
        userInputTextView.textColor = .lightGray
        
        userInputTextView.font = UIFont(name: "S-CoreDream-5Medium", size: 17)
        userOutputTextView.font = UIFont(name: "S-CoreDream-5Medium", size: 17)
        
        requestTranslatedData()
        
//        userInputTextView.resignFirstResponder()
//        userInputTextView.becomeFirstResponder()
        
    }
    
    func requestTranslatedData() {
        let url = EndPoint.translateURL

        let parameter: Parameters = ["source": "ko", "target": "en", "text": self.userInputTextView.text!]
        
        let header: HTTPHeaders = ["X-Naver-Client-Id": APIKey.NAVER_ID, "X-Naver-Client-Secret": APIKey.NAVER_SECRET]
        
        AF.request(url, method: .post, parameters: parameter, headers: header).validate(statusCode: 200...500).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let statusCode = response.response?.statusCode ?? 500
                
                if statusCode == 200 {
                    self.userOutputTextView.text = json["message"]["result"]["translatedText"].stringValue
                } else {
                    self.userOutputTextView.text = json["errorMessage"].stringValue
                }
                
                print(statusCode)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    @IBAction func translateButtonClicked(_ sender: UIButton) {
        requestTranslatedData()
    }
    
}

extension TranslateViewController: UITextViewDelegate {
    
    //텍스트뷰의 텍스트가 변할 때마다 호출 (자기소개서 글자수 세기)
    func textViewDidChange(_ textView: UITextView) {
//        print(textView.text.count)
    }
    
    //편집이 시작될 때, 커서가 시작될 때
    //텍스트뷰 글자: 플레이스 홀더랑 글자가 같으면 clear, color
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("textViewDidBeginEditing")
        
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
        
    }
    
    //편집이 끝났을 때, 커서가 없어지는 순간
    //텍스트뷰 글자: 사용자가 아무 글자도 안 썼으면 플레이스 홀더 글자 보이게 해!
    func textViewDidEndEditing(_ textView: UITextView) {
        print("textViewDidEndEditing")
        
        if textView.text.isEmpty {
            textView.text = textViewPlaceholderText
            textView.textColor = .lightGray
        }
    }
    
}
