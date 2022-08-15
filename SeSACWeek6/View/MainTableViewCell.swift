//
//  MainTableViewCell.swift
//  SeSACWeek6
//
//  Created by 이현호 on 2022/08/09.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    
    @IBOutlet weak var contentCollectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        print("MainTableViewCell", #function)
        
        setUpUI()
    }

    func setUpUI() {
        titleLabel.font = .boldSystemFont(ofSize: 24)
        //        titleLabel.text = "넷플릭스 인기 콘텐츠"
        titleLabel.backgroundColor = .clear
        
        contentCollectionView.backgroundColor = .clear
        contentCollectionView.collectionViewLayout = collectionViewLayout()
    }
    
    func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 300, height: 180) //180
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        //컬렉션 뷰에서 띄우는 속성
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return layout
        
    }
    

}

