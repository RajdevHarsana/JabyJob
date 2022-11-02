import Foundation
import UIKit


//private var __maxLengths = [UITextField: Int]()
private var __maxLengths = [UITextField: Int]()
extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        if let t = textField.text {
            textField.text = String(t.prefix(maxLength))
        }
    }
}

@IBDesignable
extension UIView {
     // Shadow
     @IBInspectable var shadow: Bool {
          get {
               return layer.shadowOpacity > 0.0
          }
          set {
               if newValue == true {
                    self.addShadow()
               }
          }
     }

     fileprivate func addShadow(shadowColor: CGColor =
           UIColor.black.cgColor,shadowOffset: CGSize = CGSize(width: 3.0, height: 3.0),
               shadowOpacity: Float = 0.2,
                        shadowRadius: CGFloat = 5.0) {
          let layer = self.layer
          layer.masksToBounds = false

          layer.shadowColor = shadowColor
          layer.shadowOffset = shadowOffset
          layer.shadowRadius = shadowRadius
          layer.shadowOpacity = shadowOpacity
          layer.shadowPath = UIBezierPath(roundedRect: layer.bounds, cornerRadius: layer.cornerRadius).cgPath

          let backgroundColor = self.backgroundColor?.cgColor
          self.backgroundColor = nil
          layer.backgroundColor =  backgroundColor
     }

     // Corner radius
     @IBInspectable var circle: Bool {
          get {
               return layer.cornerRadius == self.bounds.width*0.5
          }
          set {
               if newValue == true {
                    self.cornerRadius = self.bounds.width*0.5
               }
          }
     }

     @IBInspectable var cornerRadius: CGFloat {
          get {
               return self.layer.cornerRadius
          }

          set {
               self.layer.cornerRadius = newValue
          }
     }
     @IBInspectable
     public var borderWidth: CGFloat {
         get {
              return layer.borderWidth
         }
          set {
               layer.borderWidth = newValue
          }
     }

     // Border color
     @IBInspectable
     public var borderColor: UIColor? {
         get {
              if let borderColor = layer.borderColor {
                   return UIColor(cgColor: borderColor)
              }
              return nil
         }
          set {
               layer.borderColor = newValue?.cgColor
          }
     }
}
class ShadowView: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        // corner radius
        self.layer.cornerRadius = 10

        // border
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.black.cgColor

        // shadow
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = 4.0
    }

}
