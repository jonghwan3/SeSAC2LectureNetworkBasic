//
//  ViewController.swift
//  SeSAC2LectureNetworkBasic
//
//  Created by 박종환 on 2022/07/27.
//

import UIKit

class ViewController: UIViewController, ViewPresentableProtocol, UITableViewDelegate, UITableViewDataSource {
    
    static let identifer: String = "ViewController"
    
    var navigationTitleString: String {
        get {
            return "대장님의 다마고치"
        }
        set {
            title = newValue
        }
    }
    
    var backgroundColor: UIColor {
        get {
            return .blue
        }
    }
    
    func configureView() {
        navigationTitleString = "고래밥님의 다마고치"
//        backgroundColor = .red
    }
    
    func configureLabel() {
        
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }


}

