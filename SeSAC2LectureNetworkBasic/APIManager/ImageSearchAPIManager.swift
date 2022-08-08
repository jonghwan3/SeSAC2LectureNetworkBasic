//
//  ImageSearchAPIManager.swift
//  SeSAC2LectureNetworkBasic
//
//  Created by 박종환 on 2022/08/05.
//

import Foundation

import Alamofire
import SwiftyJSON

//싱글톤 패턴은 클래스로 보통 만들게 되는데, 구조체 싱글턴 패턴을 사용하지 않는 이유는 무엇일까요?
class ImageSearchAPIManager {
    
    static let shared = ImageSearchAPIManager()
    
    private init() { }
    
    typealias completionHandler = (Int, [String]) -> Void
    
    func fetchImageData(input: String, startPage: Int, completionHandler: @escaping completionHandler) {
        let text = input.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = EndPoint.imageSearchURL + "query=\(text!)&display=30&start=\(startPage)"

        let header: HTTPHeaders = ["X-Naver-Client-Id": APIKey.NAVER_ID, "X-Naver-Client-Secret": APIKey.NAVER_SECRET]
        
    //        list.removeAll()
//        hud.show(in: view)
        
        AF.request(url, method: .get, headers: header).validate(statusCode: 200...500).responseData(queue: .global()) { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                    
                //20개 셀
                
                //셀에서 URL, UIImage 변환을 할 건지 =>
                //서버통신받는 시점에서 URL, UIImage 변환을 할 건지 => 시간 오래 걸림.
                let total = json["total"].intValue
                
    //                for image in json["items"].arrayValue {
    //                    let data = image["link"].stringValue
    //                    self.list.append(data)
    //                }
                
                let list = json["items"].arrayValue.map { $0["link"].stringValue }
                
                completionHandler(total, list)
              
                
            case .failure(let error):
                
                print(error)
                
            }
        }
        
    }
    
}
