//
//  MapViewController.swift
//  SeSACWeek6
//
//  Created by 이현호 on 2022/08/11.
//

import UIKit
import MapKit

//Location 1. 임포트
import CoreLocation

import Alamofire
import SwiftyJSON

import Kingfisher

/*
 MapView
 - 지도와 위치 권한은 상관 X
 - 만약 지도에 현재 위치 등을 표현하고 싶다면 위치 권한을 등록해주어야 함
 - 중심, 범위 지정
 - 핀(어노테이션)
 */

/*
 권한: 반영이 조금씩 느릴 수 있음. 지웠다가 실행한다고 하더라도. 한번 허용
 
 */

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var currentLocation: UILabel!
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var currentHum: UILabel!
    @IBOutlet weak var currentWind: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var comment: UILabel!
    
    //Location 2. 위치에 대한 대부분을 담당
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Location 3. 프로토콜 연결
        locationManager.delegate = self
        
        //        checkUserDeviceLocationServiceAuthorization() 제거 가능한 이유 명확히 알기!
        
        //지도 중심 설정: 애플맵 활용해 좌표 복사
        let center = CLLocationCoordinate2D(latitude: 37.561686, longitude: 126.975039)
        setRegionAndAnnotation(center: center)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        showRequestLocationServiceAlert()
        
    }
    
    func setRegionAndAnnotation(center: CLLocationCoordinate2D) {
        
        //위도 경도 기준으로 위치 설정
        //지도 중심 기반으로 보여질 범위
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 300, longitudinalMeters: 300)
        mapView.setRegion(region, animated: true)
        
        //핀과 지도범위 설정은 따로
        //정확한 위치 설정을 위해서는 pointAnnotation 사용
        let annotation = MKPointAnnotation()
        //핀 위치 설정
        annotation.coordinate = center
        annotation.title = "이곳이 엘살바도르다"
        
        //지도에 핀 추가
        mapView.addAnnotation(annotation)
        
    }
    
}

extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
            CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.subLocality, $1) }
    }
}

//위치 관련된 User 정의 메서드
extension MapViewController {
    
    //서버에서 날씨 정보 요청
    func callRequest(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        let url = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(APIKey.weather)"
        
        //Alamofire -> URLSession Framework -> 비동기로 Request (따로 코드를 처리해주지 않아도 됨 Request 안쪽에 처리 되어 있음)
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
                //성공케이스에 대한 설정
            case .success(let value):
                
                let json = JSON(value)
                print(json)
                
                //현위치 표시
                let location = CLLocation(latitude: lat, longitude: lon)
                location.fetchCityAndCountry { city, country, error in
                    guard let city = city, let country = country, error == nil else { return }
                    self.currentLocation.text = "\(city), \(country)"
                }
                
                //기온 표시
                let kelvin = json["main"]["temp"].doubleValue
                let temp = kelvin - 273.15
                let num = String(format: "%.1f", temp)
                self.currentTemp.text = "지금은 \(num)'C 에요"
                
                //습도 표시
                let hum = json["main"]["humidity"].intValue
                self.currentHum.text = "\(hum)%만큼 습해요"
                
                //풍속 표시
                let speed = json["wind"]["speed"].intValue
                self.currentWind.text = "\(speed)m/s의 바람이 불어요"
                
                //날씨 아이콘 표시
                let icon = json["weather"][0]["icon"].stringValue
                self.weatherIcon.kf.setImage(with: URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png"))
                
                self.comment.text = "오늘도 행복한 하루 보내세요"
                
                //실패케이스에 대한 설정
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //Location 7. iOS 버전에 따른 분기 처리 및 iOS 위치 서비스 활성화 여부 확인(위치 권한 요청)
    //위치 서비스 활성화
    //위치 서비스가 켜져 있다면 권한을 요청하고, 꺼져 있다면 커스텀 얼럿으로 상황 알려주기
    //CLAuthorizationStatus
    //- notDetermined: 앱 첫 실행시 아직 권한 요청에 대해 선택 안한 경우
    //- denied: 허용 안함 / 설정에서 추후에 거부 / 위치 서비스 중지 / 비행기 모드
    //- restricted: 앱 권한 자체 없는 경우 / 자녀 보호 기능 같은 걸로 아예 제한
    //2. 두 번째로 실행
    func checkUserDeviceLocationServiceAuthorization() {
        
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14.0, *) {
            //인스턴스를 통해 locationManager가 갖고 있는 상태를 가져옴
            authorizationStatus = locationManager.authorizationStatus
        } else {
            //iOS 14 이전에는 아래와 같이 타입프로퍼티, 타입메서드와 같은 형태로 사용했었음
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        //iOS 위치 서비스 활성화 여부 체크: locationServicesEnabled()
        if CLLocationManager.locationServicesEnabled() {
            //위치 서비스가 활성화 되어 있으므로, 위치 권한 요청 가능해서 위치 권한을 요청함
            checkUserCurrentLocationAuthorization(authorizationStatus)
        } else {
            print("위치 서비스가 꺼져 있어서 위치 권한 요청을 못합니다.")
        }
        
    }
    
    //Location 8. 사용자의 위치 권한 상태 확인
    //현재 상태 확인
    //사용자가 위치를 허용했는지, 거부했는지, 아직 선택하지 않았는지 등을 확인(단, 사전에 iOS 위치 서비스 활성화 꼭 확인)
    //3. 세 번째로 실행
    func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            print("NOTDETERMINED")
            
            //주의점: infoPlist WhenInUse -> request 메서드 OK
            //kCLLocationAccuracyBest 각각 디바이스에 맞는 정확도로 설정해줌
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            //앱을 사용하는 동안에 권한에 대한 위치 권한 요청
            locationManager.requestWhenInUseAuthorization()
            
            //plist WhenInUse -> request 메서드 OK
            //locationManager.startUpdatingLocation() 없어도 괜찮지 않을까요?
            
        case .restricted, .denied:
            print("DENIED, 아이폰 설정으로 유도")
        case .authorizedWhenInUse:
            print("WHEN IN USE")
            //사용자가 위치를 허용해둔 상태라면, startUpdatingLocation을 통해 didUpdateLocations 메서드가 실행
            locationManager.startUpdatingLocation() //단점: 정확도를 위해서 무한대로 호출됨
        default: print("DEFAULT")
        }
    }
    
    func showRequestLocationServiceAlert() {
        let requestLocationServiceAlert = UIAlertController(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
            
            //설정까지 이동하거나 설정 세부화면까지 이동하거나
            //한 번도 설정 앱에 들어가지 않았거나, 막 다운받은 앱이거나 - 설정
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
            
        }
        let cancel = UIAlertAction(title: "취소", style: .default)
        requestLocationServiceAlert.addAction(cancel)
        requestLocationServiceAlert.addAction(goSetting)
        
        present(requestLocationServiceAlert, animated: true, completion: nil)
    }
    
}

//Location 4. 프로토콜 선언
extension MapViewController: CLLocationManagerDelegate {
    
    //Location 5. 사용자의 위치를 성공적으로 가지고 온 경우 실행
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function, locations)
        
        //ex. 위도 경도 기반으로 날씨 정보를 조회
        //ex. 지도를 다시 세팅
        if let coordinate = locations.last?.coordinate {
            //            let latitude = coordinate.latitude
            //            let longtitude = coordinate.longitude
            //            let center = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
            setRegionAndAnnotation(center: coordinate)
            
            //날씨 API 요청
            callRequest(lat: coordinate.latitude, lon: coordinate.longitude)
        }
        
        //위치 업데이트 멈춰!!
        locationManager.stopUpdatingLocation()
    }
    
    //Location 6. 사용자의 위치를 가지고 오지 못한 경우 실행
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
    }
    
    //Location 9. 사용자의 권한 상태가 바뀔 때를 알려줌
    //거부했다가 설정에서 변경했거나, 혹은 notDetermined에서 허용을 했거나 등
    //허용했어서 위치를 가지고 오는 중에, 설정에서 거부하고 돌아온다면?
    //iOS 14 이상: 사용자의 권한 상태가 변경이 될 때, 위치 관리자 생성할 때 호출됨
    //1. 앱 실행시 제일 처음 실행
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        checkUserDeviceLocationServiceAuthorization()
    }
    //iOS 14 미만
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
    
}

extension MapViewController: MKMapViewDelegate {
    
    //지도에 커스텀 핀 추가
    //    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    //        <#code#>
    //    }
    
    //사용자가 지도를 움직이다가 멈추면 실행되는 메서드
    //    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
    //        locationManager.startUpdatingLocation()
    //    }
    
}
