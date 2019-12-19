import UIKit

@IBDesignable
class CustomButton: UIButton {
    
    //rgb(193, 44, 47) converted too UIColor
    @IBInspectable var color: UIColor = UIColor(red:0.76, green:0.17, blue:0.18, alpha:1.0)
    
    override func layoutSubviews() {
        setTitleColor(.white, for: .normal)
        backgroundColor = color
        layer.cornerRadius = 7
        
        if let label = titleLabel {
            label.textAlignment = .center
        }
    }
}
