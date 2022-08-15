//
//  URL+Extension.swift
//  SeSACWeek6
//
//  Created by 이현호 on 2022/08/08.
//

import Foundation

extension URL {
    static let baseURL = "https://dapi.kakao.com/v2/search/"
    
    //위의 baseURL에 목적에 따라 다른 단어를 붙여줘서 URL을 완성시켜주는 타입 함수
    static func makeEndPointString(_ endpoint: String) -> String {
        return baseURL + endpoint
    }
}
