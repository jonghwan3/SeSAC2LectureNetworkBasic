//
//  ImageSearchViewController.swift
//  SeSAC2LectureNetworkBasic
//
//  Created by 박종환 on 2022/08/03.
//

import UIKit

import Alamofire
import SwiftyJSON
import Kingfisher

class ImageSearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var list: [String] = []
    
    @IBOutlet weak var imageSearchCollectionView: UICollectionView!
    
    @IBOutlet weak var imageSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageSearchCollectionView.delegate = self
        imageSearchCollectionView.dataSource = self
        
        imageSearchCollectionView.register(UINib(nibName: ImageSearchCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: ImageSearchCollectionViewCell.reuseIdentifier)
        
        let layout = UICollectionViewFlowLayout()
                let spacing: CGFloat = UIScreen.main.bounds.width * 0
                let sectionSpacing: CGFloat = UIScreen.main.bounds.width * 0.03
                let width = (UIScreen.main.bounds.width - spacing * 2 - sectionSpacing * 2) / 3
        layout.itemSize = CGSize(width: width, height: width * 1.2)
                layout.scrollDirection = .vertical
                layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
                layout.minimumInteritemSpacing = spacing
                layout.minimumLineSpacing = spacing
        imageSearchCollectionView.collectionViewLayout = layout
        
        imageSearchBar.delegate = self
        imageSearchBar.text = "과자"
        
        fetchImage(input: imageSearchBar.text ?? "")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = imageSearchCollectionView.dequeueReusableCell(withReuseIdentifier: ImageSearchCollectionViewCell.reuseIdentifier, for: indexPath) as? ImageSearchCollectionViewCell else { return UICollectionViewCell() }
        
        let url = URL(string: list[indexPath.item])
        cell.searchImageView.kf.setImage(with: url)
        
        return cell
    }
    
    //fetchImage, requestImage, callRequestImage, getImage... > response에 따라 네이밍을 설정해주기도 함.
    //내일 > 페이지네이션
    func fetchImage(input: String) {
        let text = input.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = EndPoint.imageSearchURL + "query=\(text!)&display=30&start=1"

        let header: HTTPHeaders = ["X-Naver-Client-Id": APIKey.NAVER_ID, "X-Naver-Client-Secret": APIKey.NAVER_SECRET]
        
        self.list.removeAll()
        
        AF.request(url, method: .get, headers: header).validate(statusCode: 200...500).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                for image in json["items"].arrayValue {
                    let data = image["link"].stringValue
                    self.list.append(data)
                }
                
                self.imageSearchCollectionView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

extension ImageSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fetchImage(input: searchBar.text ?? "")
    }
    
}
