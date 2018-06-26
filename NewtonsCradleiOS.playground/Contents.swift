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
        
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        animator = UIDynamicAnimator(referenceView: self)
        animator?.addBehavior(collisionBehavior)
        animator?.addBehavior(gravityBehavior)
        animator?.addBehavior(itemBehavior)

        self.createBallViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func createBallViews() {
        for color in self.colors {
            let ball = UIView(frame: CGRect.zero)

            ball.addObserver(self, forKeyPath: "center", options: NSKeyValueObservingOptions.init(rawValue: 0), context: nil)

            ball.backgroundColor = color

            addSubview(ball)

            balls.append(ball)
        }
    }
    
    public override func draw(_ rect: CGRect) {
        
    }
}

let newtonsCradle = NewtonsCradle(colors: [#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)])

PlaygroundPage.current.liveView = newtonsCradle
