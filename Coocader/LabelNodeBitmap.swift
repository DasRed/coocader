import UIKit
import SpriteKit

/**
 * @see https://github.com/marioklaver/ASAttributedLabelNode
 */
class LabelNode: SKSpriteNode {
    
    // text
    var text: String! = "" { didSet { self.drawText() } }
    
    // font name
    var fontName: String! = Setting.FONT_NAME { didSet { self.drawText() } }
    
    // font size
    var fontSize: CGFloat! = Setting.FONT_SIZE_NORMAL { didSet { self.drawText() } }
    
    // font color
    var fontColor: UIColor! = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) { didSet { self.drawText() } }
    
    // border color
    var strokeColor: UIColor! = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0) { didSet { self.drawText() } }
    
    // border width
    var lineWidth: CGFloat! = 4.0 { didSet { self.drawText() } }

    /// init with text
    convenience init(text: String) {
        self.init()
        
        self.setup()
        self.text = text
        
        self.drawText()
    }

    /// init with parent and text
    convenience init(parent: SKNode, text: String) {
        self.init()

        self.setup()
        self.text = text

        self.drawText()
        parent.addChild(self)
    }
    
    // setup
    private func setup() {
        self.userInteractionEnabled = false
        self.zPosition = 1
    }
    
    // draws the text
    private func drawText() {
        let label = SKLabelNode(fontNamed: self.fontName)
        label.fontSize = self.fontSize
        label.text = self.text

        self.size.width = label.frame.size.width + 1.0 * self.lineWidth
        self.size.height = label.frame.size.height + 2.0 * self.lineWidth

        let attributedString = NSMutableAttributedString(string: self.text , attributes: [
            NSFontAttributeName : UIFont(name: self.fontName, size: self.fontSize)!,
            NSForegroundColorAttributeName: self.fontColor,
            NSStrokeColorAttributeName: self.strokeColor,
            
            // must be negative so that the text will be filled with foreground color
            NSStrokeWidthAttributeName: -1 * self.lineWidth
        ])
        
        let scaleFactor = UIScreen.mainScreen().scale
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedLast.rawValue)
        let oContext = CGBitmapContextCreate(nil, Int(self.size.width * scaleFactor), Int(self.size.height * scaleFactor), 8, Int(self.size.width * scaleFactor) * 4, colorSpace, bitmapInfo.rawValue)
        if let context = oContext {
            CGContextScaleCTM(context, scaleFactor, scaleFactor)
            CGContextConcatCTM(context, CGAffineTransformMake(1, 0, 0, -1, 0, self.size.height));
            UIGraphicsPushContext(context)
            
            let rect = attributedString.boundingRectWithSize(self.size, options: .UsesLineFragmentOrigin, context: nil)
            let strHeight = rect.height
            let yOffset = (self.size.height - strHeight) / 2.0
            attributedString.drawWithRect(CGRect(x: 0, y: yOffset, width: self.size.width, height: strHeight), options: .UsesLineFragmentOrigin, context: nil)
            
            let imageRef = CGBitmapContextCreateImage(context)
            UIGraphicsPopContext()
            self.texture = SKTexture(CGImage: imageRef!)
        }
    }
}