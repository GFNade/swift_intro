import UIKit

class CircleView: UIView {
    
    var progress: CGFloat = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2.0
        
        let startAngle = -CGFloat.pi / 2
        let endAngle = startAngle + 2 * CGFloat.pi * progress
        
        let circlePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        circlePath.lineWidth = 10.0
        
        UIColor.blue.setStroke()
        
        circlePath.stroke()
    }
}

