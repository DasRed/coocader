import UIKit
import SpriteKit

/**
 * @see https://github.com/marioklaver/ASAttributedLabelNode
 */
class LabelNode: SKNode {
    
    // text
    var text: String! = "" {
        didSet {
            for label in self.labels {
                label.text = self.text
            }
        }
    }

    /// vertical aligment
    var verticalAlignmentMode: SKLabelVerticalAlignmentMode = .Center {
        didSet {
            for label in self.labels {
                label.verticalAlignmentMode = self.verticalAlignmentMode
            }
        }
    }

    /// horizonal aligment
    var horizontalAlignmentMode: SKLabelHorizontalAlignmentMode = .Center {
        didSet {
            for label in self.labels {
                label.horizontalAlignmentMode = self.horizontalAlignmentMode
            }
        }
    }


    // font name
    var fontName: String! = Setting.FONT_NAME {
        didSet {
            for label in self.labels {
                label.fontName = self.fontName
            }
        }
    }
    
    // font size
    var fontSize: CGFloat! = Setting.FONT_SIZE_NORMAL {
        didSet {
            for label in self.labels {
                label.fontSize = self.fontSize
            }
        }
    }
    
    // font color
    var fontColor: UIColor! = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) {
        didSet {
            self.labels[0].fontColor = self.fontColor
        }
    }
    
    // border color
    var strokeColor: UIColor! = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0) {
        didSet {
            for (index, label) in self.labels.enumerate() {
                guard index != 0 else {
                    continue
                }

                label.fontColor = self.strokeColor
            }
        }
    }
    
    // border width
    var lineWidth: CGFloat! = 1.5 {
        didSet {
            for (index, label) in self.labels.enumerate() {
                let position = LabelNode.positionMap[index]

                label.position.x = position.x * self.lineWidth
                label.position.y = position.y * self.lineWidth
            }
        }
    }

    /// position map
    private static let positionMap: [CGPoint] = [
        CGPoint.zero,
        CGPoint(x: -1, y:  0),
        CGPoint(x:  1, y:  0),
        CGPoint(x:  0, y: -1),
        CGPoint(x:  0, y:  1),
        CGPoint(x: -1, y: -1),
        CGPoint(x: -1, y:  1),
        CGPoint(x:  1, y:  -1),
        CGPoint(x:  1, y:  1),
    ]

    // text
    private var labels: [SKLabelNode] = []

    /// init
    override init() {
        super.init()

        self.setup()
    }

    /// init with parent and text
    init(text: String) {
        self.text = text

        super.init()

        self.setup()
    }

    /// init with parent and text
    init(parent: SKNode, text: String) {
        self.text = text

        super.init()

        self.setup()
        parent.addChild(self)
    }

    // init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    /// setup function
    private func setup() {
        self.userInteractionEnabled = false
        self.zPosition = 1

        for (index, position) in LabelNode.positionMap.enumerate() {
            let label = SKLabelNode(fontNamed: self.fontName)
            label.userInteractionEnabled = false
            label.verticalAlignmentMode = self.verticalAlignmentMode
            label.horizontalAlignmentMode = self.horizontalAlignmentMode
            label.zPosition = self.zPosition + (index == 0 ? 2 : 1)

            label.text = self.text
            label.fontSize = self.fontSize
            label.fontColor = index == 0 ? self.fontColor : self.strokeColor
            label.position.x = position.x * self.lineWidth
            label.position.y = position.y * self.lineWidth

            self.labels.append(label)
            self.addChild(label)
        }
    }
}