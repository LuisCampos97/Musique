import UIKit

class CustomButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    
    func setupButton() {
        setTitleColor(.white, for: .normal)
        backgroundColor = UIColor.orange
        layer.cornerRadius = 7
        //frame.width = 170
        //frame.height = 30
    }
}
