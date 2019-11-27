import UIKit

@IBDesignable
class CustomButton: UIButton {
    
    @IBInspectable var color: UIColor = UIColor.orange
    
    override func layoutSubviews() {
        setTitleColor(.white, for: .normal)
        backgroundColor = color
        layer.cornerRadius = 7
        
        if let label = titleLabel {
            label.textAlignment = .center
        }
    }
}
