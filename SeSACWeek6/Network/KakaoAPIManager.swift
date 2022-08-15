//
//  KakaoAPIManager.swift
//  SeSACWeek6
//
//  Created by 이현호 on 2022/08/08.
//

import Foundation

import Alamofire
import SwiftyJSON

class kakaoAPIManager {
    
    static let shared = kakaoAPIManager()
    
    private init() {}
    
    //좀 더 명시적으로 보여주기 위해 함수 밖에 선언해줌
    let header: HTTPHeaders = ["Authorization": "KakaoAK \(APIKey.kakao)"]
    
    func callRequest(type: Endpoint, query: String, completionHandler: @escaping (JSON) -> () ) {
        print(#function)
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let url = type.requestURL + query
                
        //Alamofire -> URLSession Framework -> 비동기로 Request (따로 코드를 처리해주지 않아도 됨 Request 안쪽에 처리 되어 있음)
        AF.request(url, method: .get, headers: header).validate().responseData { response in
            switch response.result {
                //성공케이스에 대한 설정
            case .success(let value):
                
                let json = JSON(value)
                completionHandler(json)
                
                //실패케이스에 대한 설정
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
}
