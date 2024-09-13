import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var orbSpeed: CGFloat = 1.0
    var orbDistance: CGFloat = 100.0
    var numberOfOrbs: Int = 0  // Number of orbs starts at 0
    
    // Enemy-related properties
    var enemySpeed: CGFloat = 100.0 // Speed of enemies moving toward the player
    
    // MARK: - Properties
    private var playerNode: PlayerNode!
    private var orbs: [OrbNode] = []
    
    // MARK: - Scene Lifecycle
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        setupPlayerNode()
        // Start summoning enemies periodically
        startEnemySummoning()
    }
    
    // MARK: - Setup Methods
    private func setupPlayerNode() {
        playerNode = PlayerNode(color: .blue, size: CGSize(width: 50, height: 50))
        playerNode.position = CGPoint(x: frame.midX, y: frame.midY)
        playerNode.zPosition = 1
        playerNode.physicsBody = SKPhysicsBody(rectangleOf: playerNode.size)
        playerNode.physicsBody?.isDynamic = false
        playerNode.physicsBody?.categoryBitMask = 1
        playerNode.physicsBody?.contactTestBitMask = 2
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
    
    // MARK: - Enemy Management
    private func startEnemySummoning() {
        let spawnAction = SKAction.run { [weak self] in
            self?.summonEnemy()
        }
        let waitAction = SKAction.wait(forDuration: 0.001) // Shorter delay for more frequent spawning
        let sequence = SKAction.sequence([spawnAction, waitAction])
        run(SKAction.repeatForever(sequence))
    }
    
    private func summonEnemy() {
        let enemy = EnemyNode(size: CGSize(width: 30, height: 30), color: .green)
        enemy.position = randomOffscreenPosition()
        enemy.physicsBody = SKPhysicsBody(polygonFrom: enemy.path!)
        enemy.physicsBody?.isDynamic = true
        enemy.physicsBody?.categoryBitMask = 2
        enemy.physicsBody?.contactTestBitMask = 1
        enemy.physicsBody?.collisionBitMask = 0 // No collision response
        
        addChild(enemy)
        
        // Move enemy toward player
        let moveAction = SKAction.move(to: playerNode.position, duration: TimeInterval(enemySpeed / 100))
        let removeAction = SKAction.removeFromParent()
        enemy.run(SKAction.sequence([moveAction, removeAction]))
    }
    
    // Generate a random position off the screen
    private func randomOffscreenPosition() -> CGPoint {
        let screenWidth = frame.size.width
        let screenHeight = frame.size.height
        
        // Randomly choose one of four off-screen spawn zones: left, right, top, or bottom
        let side = Int.random(in: 0...3)
        
        switch side {
        case 0: // Left side (completely off-screen)
            let x = -screenWidth
            let y = CGFloat.random(in: -screenHeight...screenHeight) // Random y within the height of the screen
            return CGPoint(x: x, y: y)
            
        case 1: // Right side (completely off-screen)
            let x = screenWidth
            let y = CGFloat.random(in: -screenHeight...screenHeight) // Random y within the height of the screen
            return CGPoint(x: x, y: y)
            
        case 2: // Bottom side (completely off-screen)
            let x = CGFloat.random(in: -screenWidth...screenWidth) // Random x within the width of the screen
            let y = -screenHeight
            return CGPoint(x: x, y: y)
            
        case 3: // Top side (completely off-screen)
            let x = CGFloat.random(in: -screenWidth...screenWidth) // Random x within the width of the screen
            let y = screenHeight
            return CGPoint(x: x, y: y)
            
        default:
            return CGPoint.zero // Default (shouldn't happen)
        }
    }
    
    // MARK: - Collision Detection
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA.node
        let bodyB = contact.bodyB.node
        
        if let enemy = (bodyA as? EnemyNode) ?? (bodyB as? EnemyNode) {
            // If an enemy touches the player, remove it
            enemy.removeFromParent()
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
        orbSpeed = speed
        orbDistance = distance
        updateOrbPositions(elapsedTime: 0)  // Update the positions of all orbs based on new properties
    }
}
