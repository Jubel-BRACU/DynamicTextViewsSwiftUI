//
//  BottomViewCell.swift
//  DynamicTextViews
//
//  Created by Md Jubel Hossain on 17/11/21.
//

import Foundation
import UIKit

class panelCollectionViewCell: UICollectionViewCell {
    
    let textLabel : UILabel = {
        let iv = UILabel()
        iv.clipsToBounds = true
        iv.backgroundColor = .clear
        iv.adjustsFontSizeToFitWidth = true
       // iv.font = UIFont(name: "Jost-Regular", size: self.height*0.096)
        iv.sizeToFit()
        return iv
    }()
    
    let ImageClick : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .clear
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        textLabel.font = UIFont(name: "Jost-Regular", size:CGFloat( UIScreen.main.bounds.width > 428 ? 20 : 12))
        addSubview(ImageClick)
        addSubview(textLabel)
        ImageClick.anchorView(top: self.topAnchor,left: self.leftAnchor,right: self.rightAnchor, paddingTop: CGFloat( UIScreen.main.bounds.width > 428 ? 20 : self.height*0.16), height: 24)
        textLabel.anchorView(top: ImageClick.bottomAnchor,left: self.leftAnchor,right: self.rightAnchor,paddingTop: 9, height: CGFloat( UIScreen.main.bounds.width > 428 ? 22 : 14))

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
