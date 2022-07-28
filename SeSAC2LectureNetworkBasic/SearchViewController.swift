//
//  SearchViewController.swift
//  SeSAC2LectureNetworkBasic
//
//  Created by 박종환 on 2022/07/27.
//

import UIKit

/*
 Swift Protocol
 - Delegate
 - Datasource

 1. 왼팔/오른팔
 2. 테이블뷰 아웃렛 연결
 3. 1 + 2
 */

extension UIViewController {
    func setBackgroundColor() {
        view.backgroundColor = .red
    }
}

class SearchViewController: UIViewController, ViewPresentableProtocol, UITableViewDelegate, UITableViewDataSource {
    static let identifer: String = "SearchViewController"
    
    var navigationTitleString: String = "타이틀"
    
    var backgroundColor: UIColor = .blue
    
    
    @IBOutlet weak var searchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        searchTableView.backgroundColor = .clear
        //연결고리 작업: 테이블뷰가 해야 할 역할 > 뷰 컨트롤러에게 요청
        searchTableView.delegate = self
        searchTableView.dataSource = self
        //테이블뷰가 사용할 테이블뷰 셀(XIB) 등록
        //XIB: xml interface builder <= NIB(예전에 사용한 이름)
        searchTableView.register(UINib(nibName: ListTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ListTableViewCell.identifier)
    }
    
    func configureView() {
        searchTableView.backgroundColor = .clear
        searchTableView.separatorColor = .clear
        searchTableView.rowHeight = 60
    }
    
    func configureLabel() {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
        
        cell.backgroundColor = .clear
        cell.titleLabel.font = .boldSystemFont(ofSize: 22)
        cell.titleLabel.text = "HELLO"
        
        return cell
    }
    

}
