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

class BeerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var list: [BeerModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: BeerCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: BeerCollectionViewCell.reuseIdentifier)
        
        let layout = UICollectionViewFlowLayout()
                let spacing: CGFloat = UIScreen.main.bounds.width * 0
                let sectionSpacing: CGFloat = UIScreen.main.bounds.width * 0.03
                let width = (UIScreen.main.bounds.width - spacing * 2 - sectionSpacing * 2) / 3
        layout.itemSize = CGSize(width: width, height: width * 2.4)
                layout.scrollDirection = .vertical
                layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
                layout.minimumInteritemSpacing = spacing
                layout.minimumLineSpacing = spacing
                collectionView.collectionViewLayout = layout
        
        requestRandomBeer()
    }
    
    func requestRandomBeer() {
        let url = EndPoint.beerURL
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
               
                for beer in json.arrayValue {
                    let beerTitle = beer["name"].stringValue
                    let beerURL = beer["image_url"].stringValue
                    let descript = beer["description"].stringValue
                    let data = BeerModel(beerTitle: beerTitle, imgURL: beerURL, descrpt: descript)
                    
                    self.list.append(data)
                }
                
                self.collectionView.reloadData()
                
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BeerCollectionViewCell.reuseIdentifier, for: indexPath) as? BeerCollectionViewCell else { return UICollectionViewCell() }
        
        cell.beerNameLabel.text = list[indexPath.item].beerTitle
        
        let url = URL(string: list[indexPath.item].imgURL ?? "")
        cell.beerImageView.kf.setImage(with: url)
        
        cell.beerDescriptionLabel.text = list[indexPath.item].descrpt ?? ""
        
        return cell
        
    }
    
}
