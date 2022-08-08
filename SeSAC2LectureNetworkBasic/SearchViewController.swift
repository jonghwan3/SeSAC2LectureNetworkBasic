//
//  SearchViewController.swift
//  SeSAC2LectureNetworkBasic
//
//  Created by 박종환 on 2022/07/27.
//

import UIKit

import Alamofire
import SwiftyJSON
import JGProgressHUD

/*
 Swift Protocol
 - Delegate
 - Datasource

 1. 왼팔/오른팔
 2. 테이블뷰 아웃렛 연결
 3. 1 + 2
 */

/*
 각 json value -> list -> 테이블뷰 갱신
*/


extension UIViewController {
    func setBackgroundColor() {
        view.backgroundColor = .white
    }
}

class SearchViewController: UIViewController, ViewPresentableProtocol, UITableViewDelegate, UITableViewDataSource {
    static let identifer: String = "SearchViewController"
    var navigationTitleString: String = "타이틀"
    var backgroundColor: UIColor = .blue
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    
    //BoxOffice 배열
    var list: [BoxOfficeModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        searchTableView.backgroundColor = .clear
        //연결고리 작업: 테이블뷰가 해야 할 역할 > 뷰 컨트롤러에게 요청
        searchTableView.delegate = self
        searchTableView.dataSource = self
        //테이블뷰가 사용할 테이블뷰 셀(XIB) 등록
        //XIB: xml interface builder <= NIB(예전에 사용한 이름)
        searchTableView.register(UINib(nibName: ListTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: ListTableViewCell.reuseIdentifier)
        
        searchBar.delegate = self
        requestBoxOffice(text: getYesterday())
    }
    
    func getYesterday() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd" //TMI -> "yyyyMMdd" "YYYYMMdd" (주 단위 년도라, 12월쯤 달라질 수 있음)
//        let date = Date(timeIntervalSinceNow: -86400)
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        
//        let str = formatter.string(from: Date.now - 86400)
        let str = formatter.string(from: yesterday!)
        
        //네트워크 통신: 서버 점검 등에 대한 예외 처리
        //네트워크 느린 환경 테스트:
        //  실기기 테스트 시 Condition 조절 가능!
        //  시뮬레이터에서도 가능! (추가 설치)
        
        return str
    }
    
    func configureView() {
        searchTableView.backgroundColor = .clear
        searchTableView.separatorColor = .clear
        searchTableView.rowHeight = 60
    }
    
    func configureLabel() {
        
    }
    
    func requestBoxOffice(text: String) {
        
        list.removeAll()
        
        let hud = JGProgressHUD()
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 3.0)
        
        let url = "\(EndPoint.boxOfficeURL)key=\(APIKey.BOXOFFICE)&targetDt=\(text)"
        AF.request(url, method: .get).validate(statusCode: 200..<299).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
//                let movieNm1 = json["boxOfficeResult"]["dailyBoxOfficeList"][0]["movieNm"].stringValue
//                let movieNm2 = json["boxOfficeResult"]["dailyBoxOfficeList"][1]["movieNm"].stringValue
//                let movieNm3 = json["boxOfficeResult"]["dailyBoxOfficeList"][2]["movieNm"].stringValue
                
//                for i in 0...json["boxOfficeResult"]["dailyBoxOfficeList"].count - 1 {
//                    self.list.append(json["boxOfficeResult"]["dailyBoxOfficeList"][i]["movieNm"].stringValue)
//                }
                
                for movie in json["boxOfficeResult"]["dailyBoxOfficeList"].arrayValue {
                    
                    let movieNm = movie["movieNm"].stringValue
                    let openDt = movie["openDt"].stringValue
                    let audiAcc = movie["audiAcc"].stringValue
                    
                    let data = BoxOfficeModel(movieTitle: movieNm, releaseData: openDt, totalCount: audiAcc)
                    
                    self.list.append(data)
                }
                
                
                //list 배열에 데이터 추가
//                self.list.append(movieNm1)
//                self.list.append(movieNm2)
//                self.list.append(movieNm3)
                
                
                self.searchTableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.reuseIdentifier, for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
        
        cell.backgroundColor = .clear
        cell.titleLabel.font = .boldSystemFont(ofSize: 20)
        cell.titleLabel.text = "\(list[indexPath.row].movieTitle): \(list[indexPath.row].releaseData)"
        
        return cell
    }
    

}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        requestBoxOffice(text: searchBar.text!) // 옵셔널 바인딩, 8글자, 숫자, 날짜로 변경 시 유효한 형태의 값인가?
    }
    
}
