import UIKit

@IBDesignable
class CustomTextField: UITextField {
    
    @IBInspectable var color = UIColor.white
    
    override func draw(_ rect: CGRect) {
        let linesPath = UIBezierPath()
        
        linesPath.lineWidth = 4
        
        linesPath.move(to: CGPoint(x: 0, y: frame.height - 2))
        linesPath.addLine(to: CGPoint(x: frame.width, y: frame.height - 2))
        
        borderStyle = .none
        textColor = color
        
        color.setStroke()
        linesPath.stroke()
    }

}
