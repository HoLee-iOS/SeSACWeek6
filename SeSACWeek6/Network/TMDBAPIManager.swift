//
//  TMDBAPIManager.swift
//  SeSACWeek6
//
//  Created by 이현호 on 2022/08/10.
//

import Foundation

import Alamofire
import SwiftyJSON

class TMDBAPIManager {
    
    static let shared = TMDBAPIManager()
    
    private init() {}
    
    let tvList = [
        ("환혼", 135157),
        ("이상한 변호사 우영우", 197067),
        ("인사이더", 135655),
        ("미스터 션사인", 75820),
        ("스카이 캐슬", 84327),
        ("사랑의 불시착", 94796),
        ("이태원 클라스", 96162),
        ("호텔 델루나", 90447)
    ]
    
    let imageURL = "https://image.tmdb.org/t/p/w500"
    
    func callRequest(query: Int, completionHandler: @escaping ([String]) -> () ) {
        print(#function)
        let url = "https://api.themoviedb.org/3/tv/\(query)/season/1?api_key=\(APIKey.tmdb)&language=ko-KR"
                
        //Alamofire -> URLSession Framework -> 비동기로 Request (따로 코드를 처리해주지 않아도 됨 Request 안쪽에 처리 되어 있음)
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
                //성공케이스에 대한 설정
            case .success(let value):
                
                let json = JSON(value)
                
                var stillArray: [String] = []
                
                for i in json["episodes"].arrayValue {
                    let value = i["still_path"].stringValue
                    stillArray.append(value)
                }
                
                let value = json["episodes"].arrayValue.map { $0["still_path"].stringValue }
                
                //dump(stillArray) //print vs dump
                
                completionHandler(value)
                
                //실패케이스에 대한 설정
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    func requestImage(completionHandler: @escaping ([[String]]) -> ()) {
        
        var posterList: [[String]] = []
        
        //나중에 배울 것: async/await(iOS 13 이상)
        TMDBAPIManager.shared.callRequest(query: tvList[0].1) { value in
            posterList.append(value)

            TMDBAPIManager.shared.callRequest(query: self.tvList[1].1) { value in
                posterList.append(value)

                TMDBAPIManager.shared.callRequest(query: self.tvList[2].1) { value in
                    posterList.append(value)
                   
                    TMDBAPIManager.shared.callRequest(query: self.tvList[3].1) { value in
                        posterList.append(value)
                     
                        TMDBAPIManager.shared.callRequest(query: self.tvList[4].1) { value in
                            posterList.append(value)
                           
                            TMDBAPIManager.shared.callRequest(query: self.tvList[5].1) { value in
                                posterList.append(value)
                                
                                TMDBAPIManager.shared.callRequest(query: self.tvList[6].1) { value in
                                    posterList.append(value)
                                    
                                    TMDBAPIManager.shared.callRequest(query: self.tvList[7].1) { value in
                                        posterList.append(value)
                                        completionHandler(posterList)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
//    func requestEpisodeImage() {
        
        //1. 순서 보장 X
        //2. 언제 끝날 지 모름
        //3. Limit (ex. 1초 5번 요청을 한다면 서버에서 Block) => 담주에 해결 예정
//        for item in tvList {
//            TMDBAPIManager.shared.callRequest(query: item.1) { stllPath in
//                print(item.0)
//                dump(stllPath)
//            }
//        }
        
        //배열과 튜플의 혼합된 형태 사용법
//        let id = tvList[6].1 // 96162
//
//        TMDBAPIManager.shared.callRequest(query: id) { stillPath in
//
//            dump(stillPath)
//            TMDBAPIManager.shared.callRequest(query: self.tvList[5].1) { stillPath in
//
//                dump(stillPath)
//            }
//
//        }
//
//
//
//    }
    
    
}
