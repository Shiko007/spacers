import SpriteKit

class GameScene: SKScene {
    
    // MARK: - Properties
    private var playerSquare: PlayerNode!
    private var orbs: [OrbNode] = []
    
    var orbSpeed: CGFloat = 1.0
    var orbDistance: CGFloat = 100.0
    var numberOfOrbs: Int = 1

    // MARK: - Scene Lifecycle
    override func didMove(to view: SKView) {
        setupPlayerSquare()
        setupOrbs()
    }
    
    // MARK: - Setup Methods
    private func setupPlayerSquare() {
        playerSquare = PlayerNode(color: .blue, size: CGSize(width: 50, height: 50))
        playerSquare.position = CGPoint(x: frame.midX, y: frame.midY)
        playerSquare.zPosition = 1
        addChild(playerSquare)
    }
    
    private func setupOrbs() {
        removeExistingOrbs()
        createOrbs()
        runOrbOrbitAction()
    }
    
    // MARK: - Orb Management
    private func createOrbs() {
        for i in 0..<numberOfOrbs {
            let orb = OrbNode(color: .red, size: CGSize(width: 30, height: 30))
            positionOrb(orb, atIndex: i)
            orbs.append(orb)
            addChild(orb)
            orb.runRotationAction(duration: 1.0)
        }
    }
    
    private func positionOrb(_ orb: OrbNode, atIndex index: Int) {
        let angle = CGFloat(index) * (2 * CGFloat.pi / CGFloat(numberOfOrbs))
        let x = frame.midX + orbDistance * cos(angle)
        let y = frame.midY + orbDistance * sin(angle)
        orb.position = CGPoint(x: x, y: y)
    }
    
    private func removeExistingOrbs() {
        for orb in orbs {
            orb.removeFromParent()
        }
        orbs.removeAll()
    }
    
    private func runOrbOrbitAction() {
        let rotationAction = SKAction.customAction(withDuration: TimeInterval(orbSpeed)) { [weak self] node, elapsedTime in
            guard let self = self else { return }
            self.updateOrbPositions(elapsedTime: elapsedTime)
        }
        let repeatAction = SKAction.repeatForever(rotationAction)
        run(repeatAction)
    }
    
    private func updateOrbPositions(elapsedTime: TimeInterval) {
        let angle = CGFloat(elapsedTime) * (2 * CGFloat.pi / CGFloat(orbSpeed))
        for (index, orb) in orbs.enumerated() {
            let currentAngle = CGFloat(index) * (2 * CGFloat.pi / CGFloat(numberOfOrbs)) + angle
            let x = frame.midX + orbDistance * cos(currentAngle)
            let y = frame.midY + orbDistance * sin(currentAngle)
            orb.position = CGPoint(x: x, y: y)
        }
    }
    
    // MARK: - Public Methods
    func changePlayerSquareShape(to size: CGSize, color: UIColor) {
        playerSquare.size = size
        playerSquare.color = color
    }
    
    func changeOrbProperties(numberOfOrbs: Int, speed: CGFloat, distance: CGFloat) {
        self.numberOfOrbs = numberOfOrbs
        self.orbSpeed = speed
        self.orbDistance = distance
        setupOrbs()
    }
}
