//
//  CardView.swift
//  SeSACWeek6
//
//  Created by 이현호 on 2022/08/09.
//

import UIKit

/*
 Xml Interface Builder
 1. UIView Custom Class
 2. File's owner => 
 */

/*
 - 인터페이스 빌더 UI 초기화 구문: required init?
    - 프로토콜 초기화 구문
 - 코드 UI 초기화 구문: override init
 
 */

protocol A {
    func example()
    init()
}


class CardView: UIView {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var contentLabel: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        let view = UINib(nibName: "CardView", bundle: nil).instantiate(withOwner: self).first as! UIView
        view.frame = bounds
        
        //값을 set해주면 리사이징에 대한 오류 해결 가능함
//        view.translatesAutoresizingMaskIntoConstraints = true
        view.backgroundColor = .lightGray
        //아래 addSubview는 코드베이스로 추가를 해준 것임
        self.addSubview(view)
        
        //카드뷰를 인터페이스 빌더 기반으로 만들고, 레이아웃도 설정했는데 false가 아닌 true로 나오는 이유는 addSubview와 같이 코드로 뷰를 추가해줌
        //true. 오토레이아웃 적용이 되는 관점보다 오토리사이징이 내부적으로 constraints 처리가 됨
        print(view.translatesAutoresizingMaskIntoConstraints)
    }
   
    
}
