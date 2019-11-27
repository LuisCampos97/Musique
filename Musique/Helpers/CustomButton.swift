import UIKit

@IBDesignable
class CustomButton: UIButton {
    
    @IBInspectable var color: UIColor = UIColor.orange
    
    override func layoutSubviews() {
        setTitleColor(.white, for: .normal)
        setBackgroundColor(color: UIColor.orange, forState: .highlighted)
        backgroundColor = color
        layer.cornerRadius = 7
        
        if let label = titleLabel {
            label.textAlignment = .center
        }
    }
    
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        self.clipsToBounds = true
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.setBackgroundImage(colorImage, for: forState)
        }
    }
}
