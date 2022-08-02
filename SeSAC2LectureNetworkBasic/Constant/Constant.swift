//
//  Constant.swift
//  SeSAC2LectureNetworkBasic
//
//  Created by 박종환 on 2022/08/01.
//

import Foundation

//enum StoryboardName {
//    case Main
//    case Search
//    case Setting
//}

struct APIKey {
    static let BOXOFFICE = "54fdab2c76b86023a519f90cf914ac62"
    
    static let NAVER_ID = "OTt0y7wh5Ox8bhsrJ6f7"
    static let NAVER_SECRET = "mqxHVdg7hG"
    
    static let TMBD = "065cad0114ed07db03e6530887bebf88"
}

struct EndPoint {
    static let boxOfficeURL = "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?"
    static let lottoURL = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber"
    static let translateURL = "https://openapi.naver.com/v1/papago/n2mt"
    static let beerURL = "https://api.punkapi.com/v2/beers"
}

struct StoryboardName {

    //접근제어를 통해 초기화 방지
    private init() {

    }

    static let main = "Main"
    static let search = "Search"
    static let setting = "Setting"
}

/*
 1. struct type property vs enum type property => 인스턴스 생성 방지
 2. enum case vs enum static => 중복, case 제약
 */

//enum StoryboardName {
//    static let nickname = "고래밥"
//    static let search = "Search"
//    static let setting = "Setting"
//}

enum FontName: String {
    case title = "Sanfransisco"
//    case body = "Sanfransisco" //Raw Value for enum case is not unique
    case caption = "AppleSandol"
}
