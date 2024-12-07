import SpriteKit


// contains sprite animations and logic for choosing character
class GameScene: SKScene {
    var gender: String
    var playerName: String
    var nameLabel: SKLabelNode!
    var playerBoy: SKSpriteNode!
    var playerGirl: SKSpriteNode!
    
    init(size: CGSize, playerName: String, gender: String) {
        self.playerName = playerName
        self.gender = gender
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Texture atlas for all characters
    var playerAtlas: SKTextureAtlas {
        return SKTextureAtlas(named: "Sprites")
    }
    
    // Texture for boy idle animation
    var playerIdleTexturesBoy: [SKTexture] {
        return (1...15).map { playerAtlas.textureNamed("Idle (\($0))") }
    }
    
    // Texture for girl idle animation
    var playerIdleTexturesGirl: [SKTexture] {
        return (2...16).map { playerAtlas.textureNamed("Girl (\($0))") }
    }
    
    func configureCharacter(name: String, gender:String) {
        self.gender = gender
        self.playerName = name
        setUpPlayers()
    }
    // Initial player texture and position
    func setUpPlayers() {
        // Setting up Boy Character Sprite
        playerBoy = SKSpriteNode(imageNamed: "maleSprite")
        playerBoy.position = CGPoint(x: size.width/2 + 32, y:size.height/2)
       // playerBoy.setScale(0.8)
        addChild(playerBoy)
        
        
        playerGirl = SKSpriteNode(imageNamed: "femaleSprite")
        playerGirl.position = CGPoint(x: size.width/2 - 5, y:size.height/2)
        playerGirl.setScale(0.7)
        addChild(playerGirl)
        
        nameLabel = SKLabelNode(text:playerName)
        nameLabel.fontSize = 35
        nameLabel.fontColor = .black
        nameLabel.position = CGPoint(x:size.width/2, y:size.height/2 + 75)
        addChild(nameLabel)
        
        if gender == "Male" {
            playerBoy.isHidden = false
            playerGirl.isHidden = true
        } else {
            playerBoy.isHidden = true
            playerGirl.isHidden = false
        }
        startIdleAnimations()
    }
    
    // Called when scene appears
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.white
        setUpPlayers()
    }
    
    
    // Animating sprites
    func startIdleAnimations() {
        let boyIdleAnimation = SKAction.animate(with: playerIdleTexturesBoy, timePerFrame: 0.05)
        playerBoy.run(SKAction.repeatForever(boyIdleAnimation), withKey: "playerIdleAnimationBoy")
        
        let girlIdleAnimation = SKAction.animate(with: playerIdleTexturesGirl, timePerFrame: 0.05)
        playerGirl.run(SKAction.repeatForever(girlIdleAnimation), withKey: "playerIdleAnimationGirl")
    }
    
}
