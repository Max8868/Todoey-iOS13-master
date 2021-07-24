//
//  Extensions.swift
//  LivoAPP
//
//  Created by Livo App on 25/05/21.
//

import Foundation
import UIKit

let corRoxoLivo = #colorLiteral(red: 0.4039215686, green: 0.1764705882, blue: 0.568627451, alpha: 1)
let corAzulEscuroLivo = #colorLiteral(red: 0.09000000358, green: 0.1840000004, blue: 0.3179999888, alpha: 1)
let corVerdeLivo = #colorLiteral(red: 0.2160000056, green: 0.8859999776, blue: 0.5759999752, alpha: 1)

extension UIView  {
    // render the view within the view's bounds, then capture it as image
  func asImage() -> UIImage {
    let renderer = UIGraphicsImageRenderer(bounds: bounds)
    return renderer.image(actions: { rendererContext in
        layer.render(in: rendererContext.cgContext)
    })
  }
}
class BtnRoxoLivo : UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 10
        self.backgroundColor = corRoxoLivo
        self.setTitleColor(.white, for: .normal)
        
    }
    
}
class BtnBrancoLivo : UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 10
        self.backgroundColor = .white
        self.setTitleColor(corAzulEscuroLivo, for: .normal)
        
        
    }
    
}

class BtnVerdeLivo : UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 10
        self.backgroundColor = corVerdeLivo
        self.setTitleColor(.white, for: .normal)
        
    }
    
}
extension UIButton {
    
    func btnRoxoLivo(font: UIFont) {
        
        self.layer.cornerRadius = 10
        self.backgroundColor = corRoxoLivo
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = font
        
    }
    
    func btnBancoLivo(font: UIFont) {
        
        self.layer.cornerRadius = 10
        self.backgroundColor = .white
        self.setTitleColor(corAzulEscuroLivo, for: .normal)
        self.titleLabel?.font = font
        
    }
    
    func btnVerdeLivo(font: UIFont) {
        
        self.layer.cornerRadius = 10
        self.backgroundColor = corVerdeLivo
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = font
        
    }
    
    func btnBorder() {
        self.layer.cornerRadius = 10
    }
    
    func ativaBtn(){
        DispatchQueue.main.async{
            self.isEnabled = true
            self.isUserInteractionEnabled = true
            self.isSpringLoaded = false
            UIView.animate(withDuration: 1) {
                self.alpha = 1.0
            }
        }
    }
    
    func desativaBtn(){
        DispatchQueue.main.async{
            self.isEnabled = false
            self.isUserInteractionEnabled = false
            self.isSpringLoaded = true
            UIView.animate(withDuration: 1) {
                self.alpha = 0
            }
        }
    }
    
    func desingDisableRecorrentes(){
        self.layer.cornerRadius = 10
        self.tintColor = #colorLiteral(red: 0.5803330541, green: 0.5804335475, blue: 0.5803198814, alpha: 1)
        self.setTitleColor(#colorLiteral(red: 0.5803330541, green: 0.5804335475, blue: 0.5803198814, alpha: 1), for: .normal)
        UIButton.animate(withDuration: 0.5, animations: {
            self.layer.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
            })
        
    }
    
    func desingEnableRecorrentes(){
        self.layer.cornerRadius = 10
        self.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        UIButton.animate(withDuration: 0.5, animations: {
            self.layer.backgroundColor = #colorLiteral(red: 0.4039215686, green: 0.1764705882, blue: 0.568627451, alpha: 1)
            })
        
    }
}
extension UIView {

    enum ViewSide {
        case Left, Right, Top, Bottom
    }

    func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat) {

        let border = CALayer()
        border.backgroundColor = color

        switch side {
        case .Left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height); break
        case .Right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height); break
        case .Top: border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness); break
        case .Bottom: border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness); break
        }

        layer.addSublayer(border)
    }
    
    func animShow(){
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear],
                           animations: {
                            self.center.y -= self.bounds.height
                            self.layoutIfNeeded()
            }, completion: nil)
            self.isHidden = false
        }
        func animHide(){
            UIView.animate(withDuration: 1, delay: 0, options: [.curveLinear],
                           animations: {
                            self.center.y += self.bounds.height
                            self.layoutIfNeeded()

            },  completion: {(_ completed: Bool) -> Void in
            self.isHidden = true
                })
        }
    
//    func animateCornerRadius(from: CGFloat, to: CGFloat, duration: CFTimeInterval)
//        {
//            CATransaction.begin()
//            let animation = CABasicAnimation(keyPath: "cornerRadius")
//            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
//            animation.fromValue = from
//            animation.toValue = to
//            animation.duration = duration
//            CATransaction.setCompletionBlock { [weak self] in
//                self?.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
//                self?.layer.cornerRadius = to
//                /*
//
//                 layerMaxXMaxYCorner - bottom right corner
//                 layerMaxXMinYCorner - top right corner
//                 layerMinXMaxYCorner - bottom left corner
//                 layerMinXMinYCorner - top left corner
//                  
//                 */
//                
//            }
//            layer.add(animation, forKey: "cornerRadius")
//            CATransaction.commit()
//        }
}
@IBDesignable
public class ViewGradiente: UIView {
    @IBInspectable var startColor:   UIColor = .black { didSet { updateColors() }}
    @IBInspectable var endColor:     UIColor = .white { didSet { updateColors() }}
    @IBInspectable var startLocation: Double =   0.05 { didSet { updateLocations() }}
    @IBInspectable var endLocation:   Double =   0.95 { didSet { updateLocations() }}
    @IBInspectable var horizontalMode:  Bool =  false { didSet { updatePoints() }}
    @IBInspectable var diagonalMode:    Bool =  false { didSet { updatePoints() }}

    override public class var layerClass: AnyClass { CAGradientLayer.self }

    var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }

    func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? .init(x: 1, y: 0) : .init(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 0, y: 1) : .init(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? .init(x: 0, y: 0) : .init(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 1, y: 1) : .init(x: 0.5, y: 1)
        }
    }
    func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updatePoints()
        updateLocations()
        updateColors()
    }

}
