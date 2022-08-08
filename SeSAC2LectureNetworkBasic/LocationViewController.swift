//
//  LocationViewController.swift
//  SeSAC2LectureNetworkBasic
//
//  Created by 박종환 on 2022/07/29.
//

import UIKit

class LocationViewController: UIViewController {
    
    //LocationViewController.self 메타 타입 => "LocationViewController"
    
    //Notification 1.
    let notificationCenter = UNUserNotificationCenter.current()
    static var notificationBadge = 0
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Custom Font
        for family in UIFont.familyNames {
            print("=========\(family)=========")
            
            for name in UIFont.fontNames(forFamilyName: family) {
                print("---------\(name)---------")
            }
        }
        
        requestAuthorization()
        
    }
 
    @IBAction func downloadImage(_ sender: UIButton) {
        
        let url = "https://apod.nasa.gov/apod/image/2208/M13_final2_sinfirma.jpg"
        print("1", Thread.isMainThread)
        DispatchQueue.global().async { //동시 여러 작업 가능하게 해줘!
            let data = try! Data(contentsOf: URL(string: url)!)
            let image = UIImage(data: data)
            print("2", Thread.isMainThread)
            DispatchQueue.main.async {
                self.imageView.image = image
                print("3", Thread.isMainThread)
            }
            
        }
        
    }
    
    @IBAction func notificationButtonClicked(_ sender: UIButton) {
        sendNotification()
    }
    
    //Notification 2. 권한 요청
    func requestAuthorization() {
        
        let authorizationOption = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)
        
        notificationCenter.requestAuthorization(options: authorizationOption) { success, error in
            
            if success {
//                self.sendNotification()
            }
            
        }
        
    }
    
    //Notification 3. 권한 허용한 사용자에게 알림 요청
    //iOS 시스템에서 알림을 담당 > 알림 등록
    
    /*
     
     - 권한 허용 해야만 알림이 온다.
     - 권한 허용 문구 시스템적으로 최초 한 번만 뜬다.
     - 허용 안 된 경우, 애플 설정으로 직접 유도하는 코드를 구성 해야 한다.
     
     - 기본적으로 알림은 포그라운드에섯 수신되지 않는다.
     - 로컬 알림에서 60초 이상 반복 가능 / 갯수 제한 64개 / 커스텀 사운드
     
     1. 뱃지 제거 > 언제 제거하는 게 맞을까? SceneDelegate : sceneDidBecomeActive
     2. 노티 제거 > 노티의 유효 기간은? > 카톡(오픈채팅, 단톡) vs 잔디 > 언제 삭제해주는 게 맞을까?  > LaucnchScreen, sceneDidBecomeActive, sceneWillEnterForeground
     3. 포그라운드 수신
     
     +a
     - 노티는 앱 실행이 기본인데, 특정 노티를 클릭할 때 특정 화면으로 가고 싶다면?
     - 포그라운드 수신, 특정 화면에서는 안 받고, 특정 조건에서만 포그라운드 수신을 받고 싶다면?
     - iOS15 집중모드 등 5~6 우선순위 존재!
    */
    func sendNotification() {
        let notificationContent = UNMutableNotificationContent()
        
        notificationContent.title = "다마고치를 키워보세요"
        notificationContent.subtitle = "오늘 행운의 숫자는 \(Int.random(in: 1...100))입니다."
        notificationContent.body = "저는 따끔따끔 다마고치입니다. 배고파요."
        notificationContent.badge = NSNumber(value: LocationViewController.notificationBadge + 1)
        LocationViewController.notificationBadge = notificationContent.badge as! Int
        
        //언제 보낼 것인가? 1. 시간 간격 2. 캘린더 3. 위치에 따라 설정 가능
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        
//        var dateComponent = DateComponents()
//        dateComponent.minute = 15
        
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        
        //알림 요청
        //identifier: 같을 경우에는 stack으로 쌓이지 않는다.
        //만약 알림 관리할 필요 X -> 알림 클릭하면 앱을 켜주는 정도.
        //만약 알림 관리할 필요 O -> 카카오톡 대화창, +1, 고유 이름, 규칙
        //12개 >
        let request = UNNotificationRequest(identifier: "\(Date())", content: notificationContent, trigger: trigger)
        
        notificationCenter.add(request)
    }
    
}
