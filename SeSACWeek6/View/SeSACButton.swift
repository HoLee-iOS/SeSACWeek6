//
//  SeSACButton.swift
//  SeSACWeek6
//
//  Created by 이현호 on 2022/08/09.
//

import UIKit

/*
 Swift Attribute(속성)
 @IBInspectable, @IBDesignable, @objc, @escaping, @available, @discardableResult, @propertyWrapper
 */


//디자이너블을 선언해줘야만 인터페이스 빌더 컴파일 시점에 실시간으로 아래에서 추가해서 변경해주는 객체 속성을 확인할 수 있음
@IBDesignable class SeSACButton: UIButton {

    //인터페이스 빌더 인스펙터 영역에 해당하는 속성을 보여주기만 해줌
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable var borderColor: UIColor {
        get { return UIColor(cgColor: layer.borderColor!) }
        set { layer.borderColor = newValue.cgColor }
    }
    
}
