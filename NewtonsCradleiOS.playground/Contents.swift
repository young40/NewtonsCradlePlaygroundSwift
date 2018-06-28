import UIKit
import PlaygroundSupport

public class NewtonsCradle: UIView {
    private let colors: [UIColor]
    private var balls: [UIView] = []
    
    private var animator: UIDynamicAnimator?
    private var ballsToAttachmentBehaviors: [UIView:UIAttachmentBehavior] = [:]
    private var snapBehaviors: UISnapBehavior?
    
    public let collisionBehavior: UICollisionBehavior
    public let gravityBehavior: UIGravityBehavior
    public let itemBehavior: UIDynamicItemBehavior
    
    public init(colors: [UIColor]) {
        self.colors = colors
        
        collisionBehavior = UICollisionBehavior(items: [])
        gravityBehavior = UIGravityBehavior(items: [])
        itemBehavior = UIDynamicItemBehavior(items: [])
        
        super.init(frame: CGRect(x: 0, y: 0, width: 480, height: 320))
        
        backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        animator = UIDynamicAnimator(referenceView: self)
        animator?.addBehavior(collisionBehavior)
        animator?.addBehavior(gravityBehavior)
        animator?.addBehavior(itemBehavior)

        self.createBallViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.colors = []
        collisionBehavior = UICollisionBehavior(items: [])
        gravityBehavior = UIGravityBehavior(items: [])
        itemBehavior = UIDynamicItemBehavior(items: [])

        super.init(coder: aDecoder)
    }

    deinit {
        for ball in balls {
            ball.removeObserver(self, forKeyPath: "center")
        }
    }

    func createBallViews() {
        for color in self.colors {
            let ball = UIView(frame: CGRect.zero)

            ball.addObserver(self, forKeyPath: "center", options: NSKeyValueObservingOptions.init(rawValue: 0), context: nil)

            ball.backgroundColor = color

            addSubview(ball)

            balls.append(ball)

            layoutBalls()
        }
    }

    public var attachmentBehaviors:[UIAttachmentBehavior] {
        get {
            var attachmentBehaviors: [UIAttachmentBehavior] = []
            for ball in balls {
                guard let attachmentBehavior = ballsToAttachmentBehaviors[ball] else {
                    fatalError("ball not found")
                }

                attachmentBehaviors.append(attachmentBehavior)
            }

            return attachmentBehaviors
        }
    }

    public var useSquaresInsteadOfBalls:Bool = false {
        didSet {
            for ball in balls {
                if useSquaresInsteadOfBalls {
                    ball.layer.cornerRadius = 0
                }
                else {
                    ball.layer.cornerRadius = ball.bounds.width / 2.0
                }
            }
        }
    }

    public var ballSize: CGSize = CGSize(width: 50, height: 50) {
        didSet {
            layoutBalls()
        }
    }

    public var ballPadding: Double = 0.0 {
        didSet {
            layoutBalls()
        }
    }

    private func layoutBalls() {
        let requiredWidth = CGFloat(balls.count) * (ballSize.width + CGFloat(ballPadding))

        for (index, ball) in balls.enumerated() {
            if let attachmentBehavior = ballsToAttachmentBehaviors[ball] {
                animator?.removeBehavior(attachmentBehavior)
            }

            collisionBehavior.removeItem(ball)
            gravityBehavior.removeItem(ball)
            itemBehavior.removeItem(ball)

            let ballXOrigin = ((bounds.width - requiredWidth) / 2.0) + (CGFloat(index)) * (ballSize.width + CGFloat(ballPadding))

            ball.frame = CGRect(x: ballXOrigin, y: bounds.midY, width: ballSize.width, height: ballSize.height)

            let attachmentBehavior = UIAttachmentBehavior(item: ball, attachedToAnchor: CGPoint(x: ball.frame.midY, y: bounds.midY - 50))
            ballsToAttachmentBehaviors[ball] = attachmentBehavior
            animator?.addBehavior(attachmentBehavior)

            collisionBehavior.addItem(ball)
            gravityBehavior.addItem(ball)
            itemBehavior.addItem(ball)
        }
    }

    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "center") {
            setNeedsDisplay()
        }
    }
    
    public override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context!.saveGState()

        for ball in balls {
            guard let attachemntBehiveor = ballsToAttachmentBehaviors[ball] else {
                fatalError("not found ball")
            }

            let anchorPoint = attachemntBehiveor.anchorPoint

            context?.move(to: anchorPoint)
            context?.addLine(to: ball.center)
            context?.setStrokeColor(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1).cgColor)

            context?.setLineWidth(4.0)
            context?.strokePath()

            let attachmentDotWidth: CGFloat = 10.0
            let attachmentDotOrigin = CGPoint(x: anchorPoint.x - (attachmentDotWidth/2), y: anchorPoint.y - (attachmentDotWidth/2))

            let attachmentDotRect = CGRect(x: attachmentDotOrigin.x, y: attachmentDotOrigin.y, width: attachmentDotWidth, height: attachmentDotWidth)

            context?.setFillColor(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1).cgColor)
            context?.fillEllipse(in: attachmentDotRect)
        }
        context?.restoreGState()
    }
}

let newtonsCradle = NewtonsCradle(colors: [#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)])

PlaygroundPage.current.liveView = newtonsCradle
