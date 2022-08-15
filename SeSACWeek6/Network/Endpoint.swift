//
//  Endpoint.swift
//  SeSACWeek6
//
//  Created by 이현호 on 2022/08/08.
//

import Foundation

enum Endpoint {
    case blog
    case cafe
        
    //저장 프로퍼티를 못쓰는 이유?
    var requestURL: String {
        switch self {
        case .blog:
            return URL.makeEndPointString("blog?query=")
        case .cafe:
            return URL.makeEndPointString("cafe?query=")
        }
    }
}


