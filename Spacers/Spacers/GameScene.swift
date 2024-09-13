import SpriteKit

class GameScene: SKScene {
    
    // MARK: - Properties
    private var playerNode: PlayerNode!
    private var orbs: [OrbNode] = []
    
    var orbSpeed: CGFloat = 1.0
    var orbDistance: CGFloat = 100.0
    var numberOfOrbs: Int = 0  // Number of orbs starts at 0
    
    // MARK: - Scene Lifecycle
    override func didMove(to view: SKView) {
        setupPlayerNode()
        // No orbs are created initially
    }
    
    // MARK: - Setup Methods
    private func setupPlayerNode() {
        playerNode = PlayerNode(color: .blue, size: CGSize(width: 50, height: 50))
        playerNode.position = CGPoint(x: frame.midX, y: frame.midY)
        playerNode.zPosition = 1
        addChild(playerNode)
    }
    
    // MARK: - Orb Management
    private func createOrb() {
        numberOfOrbs += 1 // Increment the number of orbs
        let orb = OrbNode(color: .red, size: CGSize(width: 30, height: 30))
        positionOrb(orb, atIndex: numberOfOrbs - 1)
        orbs.append(orb)
        addChild(orb)
        orb.runRotationAction(duration: 1.0) // Orbs rotate around themselves at constant speed
        runOrbOrbitAction()
    }
    
    private func positionOrb(_ orb: OrbNode, atIndex index: Int) {
        let angle = CGFloat(index) * (2 * CGFloat.pi / CGFloat(numberOfOrbs))
        let x = frame.midX + orbDistance * cos(angle)
        let y = frame.midY + orbDistance * sin(angle)
        orb.position = CGPoint(x: x, y: y)
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
    
    // MARK: - Touch Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        createOrb()  // Add a new orb with each touch
    }
    
    // MARK: - Public Methods
    func changePlayerNodeShape(to size: CGSize, color: UIColor) {
        playerNode.size = size
        playerNode.color = color
    }
    
    func changeOrbProperties(speed: CGFloat, distance: CGFloat) {
        self.orbSpeed = speed
        self.orbDistance = distance
        updateOrbPositions(elapsedTime: 0)  // Update the positions of all orbs based on new properties
    }
}
