//
//  CardCollectionViewCell.swift
//  SeSACWeek6
//
//  Created by 이현호 on 2022/08/09.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cardView: CardView!
    
    //변경되지 않는 UI
    override func awakeFromNib() {
        super.awakeFromNib()
        
        print("CardColletcionViewCell", #function)
        
        setupUI()
        
    }
    
    //재사용을 위해 준비함
    override func prepareForReuse() {
        //부모클래스에서도 잘 동작하기 위한 코드
        //override는 항상 super가 따라다님
        super.prepareForReuse()
        
        print("prepareForReuse", #function)
        
        cardView.contentLabel.text = "A"
    }
    
    func setupUI() {
        cardView.backgroundColor = .clear
        cardView.posterImageView.backgroundColor = .lightGray
        cardView.posterImageView.layer.cornerRadius = 10
        cardView.likeButton.tintColor = .systemPink
    }

}
