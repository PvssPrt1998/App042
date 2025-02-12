import SpriteKit
import GameplayKit

class ChartScene: SKScene {
    
    let array: Array<Int>
    var step: CGFloat
    var yStep: CGFloat
    
    var background: SKSpriteNode?
    
    init(array: Array<Int>, size: CGSize, divs: Int) {
        self.array = array
        self.step = size.width / CGFloat(divs - 1)
        if let max = array.max(), let min = array.min() {
            if max == min {
                self.yStep = 0
            } else {
                self.yStep = size.height / CGFloat(max - min)
            }
        } else {
            self.yStep = 1
        }
        super.init(size: size)
        self.backgroundColor = .c252525
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupBackground()
        setupLines()
    }
    
    private func setupBackground() {
        let background = SKSpriteNode()
        background.color = UIColor.clear
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.size = CGSize(width: size.width, height: size.height)
        background.zPosition = 0
        self.background = background
        self.addChild(background)
    }
    
    private func setupLines() {
        var stepLocal = step
        let line = SKShapeNode()
        guard !array.isEmpty else { return }
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: chartValue(array[0])))
        //path.addLine(to: CGPoint(x: step, y: chartValue(array[1])))
        if array.count == 1 {
            let node = SKSpriteNode()
            node.zPosition = 2
            node.position = CGPoint(x: 0, y: chartValue(array[0]))
            node.size = CGSize(width: 4, height: 4)
            node.color = SKColor.cPrimary
            self.addChild(node)
            return
        }
        if array.max() == array.min() {
            print("max = min")
            path.move(to: CGPoint(x: 0, y: size.height / 2))
            path.addLine(to: CGPoint(x: step, y: size.height / 2))
            line.path = path
            line.position = .zero
            line.strokeColor = SKColor.cPrimary
            line.zPosition = 2
            line.lineWidth = 2
            self.addChild(line)
            return
        }
        for i in 1..<array.count {
            path.addLine(to: CGPoint(x: stepLocal, y: chartValue(array[i])))
            stepLocal += step
        }
        line.path = path
        line.position = .zero
        line.strokeColor = SKColor.cPrimary
        line.zPosition = 2
        line.lineWidth = 2
        
        self.addChild(line)
    }
    
    private func chartValue(_ arrayValue: Int) -> CGFloat {
        guard let min = array.min() else { return 0 }
        return yStep * CGFloat(arrayValue) - yStep * CGFloat(min)
    }
}
