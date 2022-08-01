//
//  BeerViewController.swift
//  SeSAC2LectureNetworkBasic
//
//  Created by 박종환 on 2022/08/01.
//

import UIKit

import Alamofire
import Kingfisher
import SwiftyJSON

class BeerViewController: UIViewController {
    
    @IBOutlet weak var beerImageView: UIImageView!
    @IBOutlet weak var beerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func requestRandomBeer() {
        let url = "https://api.punkapi.com/v2/beers/random"
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                self.beerLabel.text = json[0]["name"].stringValue
                let url = URL(string: json[0]["image_url"].stringValue)
                self.beerImageView.kf.setImage(with: url)
                
            case .failure(let error):
                print(error)
            }
            
        }
        
        
    }
    @IBAction func buttonClicked(_ sender: UIButton) {
        requestRandomBeer()
    }
    
}
