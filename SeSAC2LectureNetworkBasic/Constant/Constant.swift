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
