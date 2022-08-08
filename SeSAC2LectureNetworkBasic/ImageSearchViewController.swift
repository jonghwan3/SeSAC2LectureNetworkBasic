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
import JGProgressHUD

class ImageSearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var list: [String] = []
    
    //네트워크 요청 시 시작 페이지 넘버
    var startPage = 1
    var total = 0
    
    @IBOutlet weak var imageSearchCollectionView: UICollectionView!
    
    @IBOutlet weak var imageSearchBar: UISearchBar!
    //ProgressView
    let hud = JGProgressHUD()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageSearchCollectionView.delegate = self
        imageSearchCollectionView.dataSource = self
        imageSearchCollectionView.prefetchDataSource = self //페이지네이션
        
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
    
    //페이지네이션 방법1. 컬렉션뷰가 특정 셀을 그리려는 시점에 호출되는 메서드.
    //마지막 셀에 사용자가 위치해있는 지 명확하게 확인하기가 어려움
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        <#code#>
//    }
    
    //페이지네이션 방법2. UIScrollViewDelegateProtocol
    //테이블뷰/컬렉션뷰는 스크롤뷰를 상속받고 있어서, 스크롤뷰 프로토콜을 사용할 수 있음.
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(scrollView.contentOffset.y)
//    }
    
    //fetchImage, requestImage, callRequestImage, getImage... > response에 따라 네이밍을 설정해주기도 함.
    func fetchImage(input: String) {
        //show
        hud.show(in: view)
        ImageSearchAPIManager.shared.fetchImageData(input: input, startPage: startPage) { total, list in
            self.total = total
            self.list.append(contentsOf: list)
            DispatchQueue.main.async {
                self.imageSearchCollectionView.reloadData()
            }
            self.hud.dismiss()
        }
    }
    
}

//페이지네이션 방법3.
//용량이 큰 이미지를 다운받아 셀에 보여주려고 하는 경우에 효과적.
//셀이 화면에 보이기 전에 미리 필요한 리소스를 다운받을 수도 있고, 필요하지 않다면 데이터를 취소할 수도 있음.
//iOS10 이상, 스크롤 성능 향상됨.
extension ImageSearchViewController: UICollectionViewDataSourcePrefetching {

    //셀이 화면에 보이기 직전에 필요한 리소스를 미리 다운받을 수 있는 목적으로 주로 사용됨
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        for index in indexPaths {
            if index.row == list.count - 1 && total > list.count {
                startPage += 30
                fetchImage(input: imageSearchBar.text ?? "")
            }
        }
        print("===\(indexPaths)")
    }
    
    //작업을 취소할 때
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        print("===취소: \(indexPaths)")
    }
    
}

extension ImageSearchViewController: UISearchBarDelegate {
        
    //검색 버튼 클릭 시 실행.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let text = searchBar.text {
            list.removeAll()
            startPage = 1
            fetchImage(input: text)
            //imageSearchCollectionView.scrollToItem(at: <#T##IndexPath#>, at: .top, animated: true)
        }
    }
    
    //취소 버튼 눌렀을 때 실행
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        list.removeAll()
        imageSearchCollectionView.reloadData()
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    //서치바에 커서가 깜빡이기 시작할 때 실행
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchBar.setShowsCancelButton(true, animated: true)
    }
}
