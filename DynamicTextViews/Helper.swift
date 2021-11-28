//
//  Helper.swift
//  DynamicTextViews
//
//  Created by Md Jubel Hossain on 17/11/21.
//

import Foundation
import UIKit

extension UIView{
    
    func addDashedBorder(_ color: UIColor = UIColor.black, withWidth width: CGFloat = 2, cornerRadius: CGFloat = 5, dashPattern: [NSNumber] = [3,6]) {

      let shapeLayer = CAShapeLayer()

      shapeLayer.bounds = bounds
      shapeLayer.position = CGPoint(x: bounds.width/2, y: bounds.height/2)
      shapeLayer.fillColor = nil
      shapeLayer.strokeColor = color.cgColor
      shapeLayer.lineWidth = width
      shapeLayer.lineJoin = .round // Updated in swift 4.2
      shapeLayer.lineDashPattern = dashPattern
      shapeLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath

      self.layer.addSublayer(shapeLayer)
    }
    
    func addBlurEffect(){
//        if !UIAccessibility.isReduceTransparencyEnabled {
//            self.backgroundColor = .clear
//
//            let blurEffect = UIBlurEffect(style: .extraLight)
//            let blurEffectView = UIVisualEffectView(effect: blurEffect)
//            //always fill the view
//            blurEffectView.frame = self.bounds
//            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//
//            self.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
//        } else {
        self.backgroundColor = UIColor.white
//        }
    }
    
    func addBlur(type: UIBlurEffect.Style = UIBlurEffect.Style.regular){
        
        self.backgroundColor = .clear

        let blurEffect = UIBlurEffect(style: type)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //fill the view
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        self.addSubview(blurEffectView)
    }
    
    func dropShadow(scale: Bool = true) {
      layer.masksToBounds = false
      layer.shadowColor = UIColor.black.cgColor
      layer.shadowOpacity = 0.5
      layer.shadowOffset = CGSize(width: -1, height: 1)
      layer.shadowRadius = 1

      layer.shadowPath = UIBezierPath(rect: bounds).cgPath
      layer.shouldRasterize = true
      layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }

    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
      layer.masksToBounds = false
      layer.shadowColor = color.cgColor
      layer.shadowOpacity = opacity
      layer.shadowOffset = offSet
      layer.shadowRadius = radius

      layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
      layer.shouldRasterize = true
      layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func cornerRadius(_ cornerRadius: CGFloat){
        layer.cornerCurve = .continuous
        layer.masksToBounds = true
        layer.cornerRadius = cornerRadius
    }
    
    func asImage(_ rect: CGRect? = nil) -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: rect ?? bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContext(self.frame.size)
            self.layer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image!.cgImage!)
        }
    }
    
    func asPreviewImage()-> UIImage{
//        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
//        self.drawHierarchy(in: CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: frame.height), afterScreenUpdates: true)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        let cgIImage =  image?.cgImage?.cropping(to: CGRect(origin: CGPoint(x: frame.origin.x * UIScreen.main.scale  , y: frame.origin.y * UIScreen.main.scale), size: CGSize(width: bounds.width * UIScreen.main.scale, height: bounds.height * UIScreen.main.scale)))
//        let newImage = UIImage(cgImage: cgIImage!, scale: UIScreen.main.scale, orientation: UIImage.Orientation.up)
//        UIGraphicsEndImageContext()
//        return newImage
       
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0);
            if let _ = UIGraphicsGetCurrentContext() {
                drawHierarchy(in: bounds, afterScreenUpdates: true)
                let screenshot = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                return screenshot!
            }
        return UIImage(named: "defaultScreen")!
    }
    
    func setGradientBackground(colorTop: UIColor, colorBottom: UIColor , gradientLayer: CAGradientLayer) {
        gradientLayer.colors = [colorBottom.cgColor, colorTop.cgColor]
        gradientLayer.startPoint = CGPoint(x:1, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = bounds
        gradientLayer.needsDisplayOnBoundsChange = true
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func anchor (top : NSLayoutYAxisAnchor? , left: NSLayoutXAxisAnchor? , bottom : NSLayoutYAxisAnchor? , right : NSLayoutXAxisAnchor? , paddingTop : CGFloat , paddingLeft : CGFloat , paddingBottom : CGFloat , paddingRight : CGFloat , width : CGFloat , height : CGFloat){
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top , constant: paddingTop).isActive = true
        }
        if let left = left {
            self.leftAnchor.constraint(equalTo: left , constant: paddingLeft).isActive = true
        }
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom , constant: -paddingBottom).isActive = true
        }
        if let right = right {
            self.rightAnchor.constraint(equalTo: right , constant: -paddingRight).isActive = true
        }
        if  width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
    }
    
    func fillSuperview(padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewTopAnchor = superview?.topAnchor {
            topAnchor.constraint(equalTo: superviewTopAnchor, constant: padding.top).isActive = true
        }
        
        if let superviewBottomAnchor = superview?.bottomAnchor {
            bottomAnchor.constraint(equalTo: superviewBottomAnchor, constant: -padding.bottom).isActive = true
        }
        
        if let superviewLeadingAnchor = superview?.leadingAnchor {
            leadingAnchor.constraint(equalTo: superviewLeadingAnchor, constant: padding.left).isActive = true
        }
        
        if let superviewTrailingAnchor = superview?.trailingAnchor {
            trailingAnchor.constraint(equalTo: superviewTrailingAnchor, constant: -padding.right).isActive = true
        }
    }
    
    func centerInSuperview(size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewCenterXAnchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: superviewCenterXAnchor).isActive = true
        }
        
        if let superviewCenterYAnchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: superviewCenterYAnchor).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    func anchorView(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func centerX(inView view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil,
                 paddingLeft: CGFloat = 0, constant: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
        
        if let lefts = leftAnchor {
            anchorView(left: lefts, paddingLeft: paddingLeft)
        }
    }
    
    public var width: CGFloat{
        return frame.size.width
    }
    public var height: CGFloat{
           return frame.size.height
       }
    public var top: CGFloat{
        return frame.origin.y
       }
    public var bottom: CGFloat{
        return frame.origin.y + frame.size.height
       }
    public var left: CGFloat{
        return frame.origin.x
       }
    public var right: CGFloat {
        return frame.origin.x + frame.size.width
    }
    
    func setDimensions(width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func addShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.55
        layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        layer.masksToBounds = false
    }
    
    func adShadowForIconList(){
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        layer.shadowRadius = 10
        layer.masksToBounds = false
    }
    
    enum ViewBorder: String {
        case left, right, top, bottom
    }
    
    func add(Border border: ViewBorder, withColor color: UIColor = UIColor.black, andWidth width: CGFloat = 1.0, lineWithPaddingLeft: Bool = true) {
        
        let borderView = UIView()
        borderView.backgroundColor = color
        borderView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(borderView)
        NSLayoutConstraint.activate(getConstrainsFor(forView: borderView, WithBorderType: border, andWidth: width, lineWithPaddingLeft: lineWithPaddingLeft))
        
    }
    
    private func getConstrainsFor(forView borderView: UIView, WithBorderType border: ViewBorder, andWidth width: CGFloat, lineWithPaddingLeft: Bool=true) -> [NSLayoutConstraint] {
        
        let height = borderView.heightAnchor.constraint(equalToConstant: width)
        let widthAnchor = borderView.widthAnchor.constraint(equalToConstant: width)
        let leading = borderView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lineWithPaddingLeft == true ? UIScreen.main.bounds.width*0.048309:0)
        let trailing = borderView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        let top = borderView.topAnchor.constraint(equalTo: self.topAnchor)
        let bottom = borderView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        
        switch border {
        
        case .bottom:
            return [bottom, leading, trailing, height]
            
        case .top:
            return [top, leading, trailing, height]
            
        case .left:
            return [top, bottom, leading, widthAnchor]
            
        case .right:
            return [top, bottom, trailing, widthAnchor]
        }
    }
    
    func view(backgroundColor: UIColor, alpha: CGFloat) ->UIView{
        let view = UIView()
        view.backgroundColor = backgroundColor
        view.alpha = alpha
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}
extension UICollectionView {
    func collectionView(scrollDirection: ScrollDirection = .horizontal, isScrolling: Bool = true, isPaging: Bool = false, showHorizontalIndicator: Bool = false, showsVerticallIndicator: Bool = false, backgroundColor: UIColor = .clear ) -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = scrollDirection
        layout.sectionInset = UIEdgeInsets.zero
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isPagingEnabled = isPaging
        collection.clipsToBounds = true
        collection.isScrollEnabled = isScrolling
        collection.showsHorizontalScrollIndicator = showHorizontalIndicator
        collection.showsVerticalScrollIndicator = showsVerticallIndicator
        collection.backgroundColor = backgroundColor
        return collection
    }
    
}
extension UIView{
    func animShow(duration: Float){
        self.layoutIfNeeded()
        UIView.animate(withDuration: TimeInterval(duration), delay: 0, options: [.curveEaseIn],
                       animations: {
            self.frame.origin.y -= self.bounds.height
            
        }, completion: nil)
        self.isHidden = false
    }
    func animHide(duration: Float){
        
        UIView.animate(withDuration: TimeInterval(duration), delay: 0, options: [.curveEaseOut],
                       animations: {
            //  self.frame.origin.y += self.height
            self.layoutIfNeeded()
            
        },completion: { finished in
            self.isHidden = true
        })
        
    }
    
}
func viewSlideInFromTopToBottom(view: UIView) -> Void {
    let transition:CATransition = CATransition()
    transition.duration = 0.5
    transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    transition.type = CATransitionType.push
    transition.subtype = CATransitionSubtype.fromBottom
    view.layer.add(transition, forKey: kCATransition)
}
