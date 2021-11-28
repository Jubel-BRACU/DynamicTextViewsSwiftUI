//
//  BottomView.swift
//  DynamicTextViews
//
//  Created by Md Jubel Hossain on 17/11/21.
//


import Foundation
import UIKit


protocol TextPanelElementTap {
    func bottomTextPanelCollectionIndex(index: String)
}
class TextLayerPanel: UIView {
    //MARK: - properties
    var selectedIndex: Int = 0
    var delegate: TextPanelElementTap?
//    var currentCells: [EditCell] = [EditCell](){
//        didSet{
//            print("Current Cell Asi Ami", currentCells.count)
//            textLayerCollectionView.reloadData()
//        }
//    }
    let mainPanelAsset = ["Transform","mmFont","Color","Stroke","Shadow"]
    let mainPanelName = ["Transform", "Font","Color","Stroke","Shadow"]
    var textLayerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()).collectionView(scrollDirection: .horizontal, isScrolling: true, isPaging: false, showHorizontalIndicator: false, showsVerticallIndicator: false, backgroundColor: .black)
    var backButton: UIButton = UIButton()
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit(){
//        if let flowLayout = panelCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            flowLayout.scrollDirection = .horizontal
//           // flowLayout.minimumInteritemSpacing = 12
//           // flowLayout.minimumLineSpacing = 0
//        }
        textLayerCollectionView.isPagingEnabled = false
        textLayerCollectionView.register(panelCollectionViewCell.self, forCellWithReuseIdentifier: "panelCell")
        addSubview(backButton)
        addSubview(textLayerCollectionView)
        textLayerCollectionView.translatesAutoresizingMaskIntoConstraints = false
        //anchor
        backButton.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        backButton.layer.cornerRadius = 10
        backButton.setImage(UIImage(named: "arrow.back"), for: .normal)
        backButton.tintColor = .white
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.heightAnchor.constraint(equalTo: textLayerCollectionView.heightAnchor).isActive = true
        backButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        backButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 6).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        backButton.addTarget(self, action: #selector(handleBackTappedInToolBar), for: .touchUpInside)
        backButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
       
        
        textLayerCollectionView.delegate = self
        textLayerCollectionView.dataSource = self
      
    }
    
    override func layoutSubviews() {
        textLayerCollectionView.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 40).isActive = true
        textLayerCollectionView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        textLayerCollectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textLayerCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
   
    @objc func handleBackTappedInToolBar(){
        viewSlideInFromTopToBottom(view: self)
        self.isHidden = true
    }
    
}

extension TextLayerPanel : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print("total cell : ",mainPanelAsset.count)
        
        
        return mainPanelAsset.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = textLayerCollectionView.dequeueReusableCell(withReuseIdentifier: "panelCell", for: indexPath) as! panelCollectionViewCell
       // cell.backgroundColor = .red
        cell.ImageClick.image =  UIImage(named: mainPanelAsset[indexPath.row])
        cell.textLabel.text =  mainPanelName[indexPath.row]
        cell.textLabel.textAlignment = .center
        cell.textLabel.textColor = .white
        return cell
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.frame.size.width
        if width > 428 {
            let height = self.textLayerCollectionView.frame.height
            let width = ((self.textLayerCollectionView.frame.width-30) / (CGFloat(mainPanelAsset.count )))
            return CGSize(width: width, height: height)
        }
        else {
            
            let width = ((self.textLayerCollectionView.frame.width-30) / (mainPanelAsset.count <= 4 ? CGFloat(mainPanelAsset.count) : CGFloat(4.2)))
            let height = self.textLayerCollectionView.frame.height
            return CGSize(width: width, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected index " , indexPath.row)
        selectedIndex  = indexPath.row
        
        delegate?.bottomTextPanelCollectionIndex(index: mainPanelName[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return UIScreen.main.bounds.width > 428 ? 0 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return UIScreen.main.bounds.width > 428 ? 12 : 12
    }

}

