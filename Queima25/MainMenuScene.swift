import SpriteKit
import UIKit

class MainMenuScene: SKScene, UITextFieldDelegate {
    private let gameModel: GameModel
    private var titleLabel: SKLabelNode!
    private var playerNameTextField: UITextField?
    private var addPlayerButton: SKShapeNode!
    private var startGameButton: SKShapeNode!
    private var playerListNode: SKNode!
    private var playerListBackground: SKShapeNode!
    private var playerLabels: [SKLabelNode] = []
    
    // Modern color scheme
    private let titleColor = UIColor(red: 0.95, green: 0.3, blue: 0.4, alpha: 1.0)
    private let buttonColor = UIColor(red: 0.2, green: 0.6, blue: 0.9, alpha: 1.0)
    private let accentColor = UIColor(red: 0.9, green: 0.7, blue: 0.2, alpha: 1.0)
    private let darkColor = UIColor(red: 0.15, green: 0.15, blue: 0.25, alpha: 1.0)
    private let sceneBackgroundColor = UIColor(red: 0.12, green: 0.12, blue: 0.2, alpha: 1.0)
    
    private let fontName = "AvenirNext-Bold"
    private var isLayoutDone = false

    init(size: CGSize, gameModel: GameModel = GameModel()) {
        self.gameModel = gameModel
        super.init(size: size)
        self.backgroundColor = sceneBackgroundColor
        self.scaleMode = .aspectFill
        print("MainMenuScene initialized with size: \(size)")
    }

    required init?(coder aDecoder: NSCoder) {
        self.gameModel = GameModel()
        super.init(coder: aDecoder)
    }

    override func didMove(to view: SKView) {
        print("MainMenuScene didMove to view with size: \(size)")
        
        // Remove any existing text fields from previous instances
        view.subviews.forEach { if $0 is UITextField { $0.removeFromSuperview() } }
        
        // Create scene after a short delay to ensure proper size
        setupSceneWithDelay()
    }
    
    private func setupSceneWithDelay() {
        // Delay setup to ensure the bounds are properly set
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self, !self.isLayoutDone else { return }
            
            // Only setup once
            self.isLayoutDone = true
            
            // Create UI
            self.createUI()
        }
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        print("MainMenuScene size changed from \(oldSize) to \(size)")
        
        // Re-layout UI if size changed significantly
        if !isLayoutDone || abs(oldSize.width - size.width) > 100 || abs(oldSize.height - size.height) > 100 {
            isLayoutDone = false
            setupSceneWithDelay()
        }
    }
    
    private func createUI() {
        // Remove any existing UI
        self.removeAllChildren()
        
        // Add background elements
        setupBackground()
        
        // Create a centered title with shadow
        titleLabel = SKLabelNode(fontNamed: fontName)
        titleLabel.text = "QUEIMA 25"
        titleLabel.fontSize = 52
        titleLabel.fontColor = titleColor
        titleLabel.position = CGPoint(x: size.width/2, y: size.height - 100)
        
        // Add simple shadow effect
        let titleShadow = SKLabelNode(fontNamed: fontName)
        titleShadow.text = "QUEIMA 25"
        titleShadow.fontSize = 52
        titleShadow.fontColor = UIColor.black.withAlphaComponent(0.4)
        titleShadow.position = CGPoint(x: 3, y: -3)
        titleShadow.zPosition = -1
        titleLabel.addChild(titleShadow)
        
        addChild(titleLabel)
        
        // Add the player input UI
        setupPlayerInput()
        
        // Setup player list section with background
        setupPlayerList()
        
        // Add a visually appealing start button
        setupStartButton()
        
        // Update player list display
        updatePlayerList()
        updateUIState()
        
        print("MainMenuScene UI setup complete with size: \(size)")
    }
    
    private func setupBackground() {
        // Add subtle background pattern
        for i in 0...10 {
            for j in 0...20 {
                let dot = SKShapeNode(circleOfRadius: 1.5)
                dot.fillColor = UIColor.white.withAlphaComponent(0.1)
                dot.strokeColor = .clear
                dot.position = CGPoint(
                    x: size.width/10 * CGFloat(i),
                    y: size.height/20 * CGFloat(j)
                )
                addChild(dot)
            }
        }
    }
    
    private func setupPlayerInput() {
        guard let view = self.view else { return }
        
        // Create a styled textfield container with rounded corners
        let containerSize = CGSize(width: size.width * 0.8, height: 50)
        let containerPath = CGPath(roundedRect: CGRect(origin: CGPoint(x: -containerSize.width/2, y: -containerSize.height/2),
                                                      size: containerSize),
                                  cornerWidth: 12, cornerHeight: 12, transform: nil)
        
        let textFieldContainer = SKShapeNode(path: containerPath)
        textFieldContainer.fillColor = darkColor
        textFieldContainer.strokeColor = .clear
        textFieldContainer.position = CGPoint(x: size.width/2, y: size.height - 180)
        textFieldContainer.zPosition = 5
        addChild(textFieldContainer)
        
        // Convert to view coordinates for TextField positioning
        let containerPosition = convertPoint(toView: textFieldContainer.position)
        
        // Create and position the text field
        let textFieldFrame = CGRect(
            x: containerPosition.x - (size.width * 0.8 / 2),
            y: containerPosition.y - 22,
            width: size.width * 0.8,
            height: 44
        )
        
        playerNameTextField = UITextField(frame: textFieldFrame)
        playerNameTextField?.backgroundColor = UIColor.white
        playerNameTextField?.textColor = UIColor(white: 0.2, alpha: 1.0)
        playerNameTextField?.layer.cornerRadius = 10
        playerNameTextField?.layer.borderWidth = 0
        playerNameTextField?.layer.shadowColor = UIColor.black.cgColor
        playerNameTextField?.layer.shadowOffset = CGSize(width: 0, height: 2)
        playerNameTextField?.layer.shadowOpacity = 0.2
        playerNameTextField?.layer.shadowRadius = 3
        playerNameTextField?.placeholder = "Enter player name"
        playerNameTextField?.textAlignment = .center
        playerNameTextField?.font = UIFont(name: "AvenirNext-Medium", size: 18)
        playerNameTextField?.autocorrectionType = .no
        playerNameTextField?.returnKeyType = .done
        playerNameTextField?.delegate = self
        view.addSubview(playerNameTextField!)
        
        // Add player button with better styling using SKShapeNode for rounded corners
        let addButtonSize = CGSize(width: size.width * 0.8, height: 44)
        let addButtonPath = CGPath(roundedRect: CGRect(origin: CGPoint(x: -addButtonSize.width/2, y: -addButtonSize.height/2),
                                                      size: addButtonSize),
                                  cornerWidth: 10, cornerHeight: 10, transform: nil)
        
        addPlayerButton = SKShapeNode(path: addButtonPath)
        addPlayerButton.fillColor = buttonColor
        addPlayerButton.strokeColor = .clear
        addPlayerButton.position = CGPoint(x: size.width/2, y: size.height - 240)
        addPlayerButton.name = "addPlayerButton"
        addPlayerButton.zPosition = 5
        
        // Add shadow effect - Positioned absolutely
        let addButtonShadow = SKShapeNode(path: addButtonPath)
        addButtonShadow.fillColor = UIColor.black
        addButtonShadow.strokeColor = .clear
        addButtonShadow.alpha = 0.3
        // Calculate absolute position based on button position + offset
        addButtonShadow.position = CGPoint(x: addPlayerButton.position.x + 3, y: addPlayerButton.position.y - 3)
        addButtonShadow.zPosition = 4
        
        addChild(addButtonShadow)
        addChild(addPlayerButton)
        
        let addLabel = SKLabelNode(fontNamed: fontName)
        addLabel.text = "Add Player"
        addLabel.fontSize = 18
        addLabel.fontColor = .white
        addLabel.verticalAlignmentMode = .center
        addPlayerButton.addChild(addLabel)
    }
    
    private func setupPlayerList() {
        // Create a background container for the player list with rounded corners
        let listContainerHeight = size.height * 0.3
        let listContainerSize = CGSize(width: size.width * 0.8, height: listContainerHeight)
        let listContainerPath = CGPath(roundedRect: CGRect(origin: CGPoint(x: -listContainerSize.width/2, y: -listContainerSize.height/2),
                                                          size: listContainerSize),
                                      cornerWidth: 15, cornerHeight: 15, transform: nil)
        
        playerListBackground = SKShapeNode(path: listContainerPath)
        playerListBackground.fillColor = darkColor
        playerListBackground.strokeColor = .clear
        playerListBackground.position = CGPoint(x: size.width/2, y: size.height/2)
        playerListBackground.zPosition = 10
        
        // addChild(listShadow)
        addChild(playerListBackground)
        
        // Add player list header with accent color
        let headerSize = CGSize(width: listContainerSize.width, height: 40)
        let headerPath = CGPath(roundedRect: CGRect(origin: CGPoint(x: -headerSize.width/2, y: -headerSize.height/2),
                                                   size: headerSize),
                               cornerWidth: 15, cornerHeight: 15, transform: nil)
        
        let listHeaderBackground = SKShapeNode(path: headerPath)
        listHeaderBackground.fillColor = accentColor
        listHeaderBackground.strokeColor = .clear
        listHeaderBackground.position = CGPoint(x: 0, y: listContainerHeight/2 - 20)
        listHeaderBackground.zPosition = 1
        playerListBackground.addChild(listHeaderBackground)
        
        let listTitle = SKLabelNode(fontNamed: fontName)
        listTitle.text = "Players"
        listTitle.fontSize = 24
        listTitle.fontColor = .white
        listTitle.verticalAlignmentMode = .center
        listHeaderBackground.addChild(listTitle)
        
        // Player list container
        playerListNode = SKNode()
        playerListNode.position = CGPoint(x: 0, y: listHeaderBackground.position.y - 40)
        playerListBackground.addChild(playerListNode)
    }
    
    private func setupStartButton() {
        // Create a larger, more appealing start button with rounded corners
        let startButtonSize = CGSize(width: 220, height: 60)
        let startButtonPath = CGPath(roundedRect: CGRect(origin: CGPoint(x: -startButtonSize.width/2, y: -startButtonSize.height/2),
                                                        size: startButtonSize),
                                    cornerWidth: 12, cornerHeight: 12, transform: nil)
        
        startGameButton = SKShapeNode(path: startButtonPath)
        startGameButton.fillColor = titleColor
        startGameButton.strokeColor = .clear
        startGameButton.position = CGPoint(x: size.width/2, y: 100)
        startGameButton.name = "startGameButton"
        startGameButton.zPosition = 20
        
        // Add shadow effect - Positioned absolutely
        let startButtonShadow = SKShapeNode(path: startButtonPath)
        startButtonShadow.fillColor = UIColor.black
        startButtonShadow.strokeColor = .clear
        startButtonShadow.alpha = 0.4
        // Calculate absolute position based on button position + offset
        startButtonShadow.position = CGPoint(x: startGameButton.position.x + 4, y: startGameButton.position.y - 4)
        startButtonShadow.zPosition = 19
        
        addChild(startButtonShadow)
        addChild(startGameButton)
        
        let startLabel = SKLabelNode(fontNamed: fontName)
        startLabel.text = "START GAME"
        startLabel.fontSize = 26
        startLabel.fontColor = .white
        startLabel.verticalAlignmentMode = .center
        startGameButton.addChild(startLabel)
    }
    
    private func updatePlayerList() {
        // Clear existing entries
        playerListNode.removeAllChildren()
        playerLabels.removeAll()
        
        
        // Add each player with better styling
        for (index, player) in gameModel.players.enumerated() {
            let yPos = -CGFloat(index * 36)
            
            // Player entry background for alternating rows with rounded corners
            let rowSize = CGSize(width: playerListBackground.frame.width - 20, height: 32)
            let rowPath = CGPath(roundedRect: CGRect(origin: CGPoint(x: -rowSize.width/2, y: -rowSize.height/2),
                                                    size: rowSize),
                                cornerWidth: 6, cornerHeight: 6, transform: nil)
            
            let rowColor = index % 2 == 0 ? 
                UIColor.white.withAlphaComponent(0.05) : 
                UIColor.white.withAlphaComponent(0.1)
            
            let rowBackground = SKShapeNode(path: rowPath)
            rowBackground.fillColor = rowColor
            rowBackground.strokeColor = .clear
            rowBackground.position = CGPoint(x: 0, y: yPos)
            rowBackground.zPosition = 1
            playerListNode.addChild(rowBackground)
            
            // Player name with nicer styling
            let nameLabel = SKLabelNode(fontNamed: "AvenirNext-Medium")
            nameLabel.text = "\(index + 1). \(player)"
            nameLabel.fontSize = 20
            nameLabel.fontColor = .white
            nameLabel.horizontalAlignmentMode = .center
            nameLabel.verticalAlignmentMode = .center
            nameLabel.position = CGPoint(x: 0, y: 0)
            rowBackground.addChild(nameLabel)
            playerLabels.append(nameLabel)
            
            // Add stylish delete button for each player
            let deleteButton = SKShapeNode(circleOfRadius: 12)
            deleteButton.fillColor = UIColor(red: 0.95, green: 0.3, blue: 0.3, alpha: 1.0)
            deleteButton.strokeColor = .white
            deleteButton.lineWidth = 1
            deleteButton.position = CGPoint(x: rowSize.width/2 - 20, y: 0)
            deleteButton.name = "deletePlayer-\(index)"
            
            let xmark = SKLabelNode(fontNamed: "AvenirNext-Bold")
            xmark.text = "×"
            xmark.fontSize = 20
            xmark.fontColor = .white
            xmark.verticalAlignmentMode = .center
            xmark.horizontalAlignmentMode = .center
            deleteButton.addChild(xmark)
            
            rowBackground.addChild(deleteButton)
            
            print("Added player: \(player)")
        }
    }
    
    private func updateUIState() {
        let canStart = gameModel.canStartGame()
        startGameButton.alpha = canStart ? 1.0 : 0.5
        print("Can start game: \(canStart)")
    }
    
    private func addPlayer() {
        guard let name = playerNameTextField?.text, !name.isEmpty else { return }
        
        if gameModel.addPlayer(name) {
            playerNameTextField?.text = ""
            updatePlayerList()
            updateUIState()
            
            // Show stylish feedback
            let feedback = SKLabelNode(fontNamed: "AvenirNext-Bold")
            feedback.text = "Added \(name)!"
            feedback.fontSize = 22
            feedback.fontColor = accentColor
            feedback.position = CGPoint(x: size.width/2, y: size.height - 280)
            addChild(feedback)
            
            // Remove after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                feedback.removeFromParent()
            }
        }
    }

    private func startGame() {
        if gameModel.canStartGame() {
            playerNameTextField?.removeFromSuperview()
            
            print("Starting gameplay scene...")
            
            // Create gameplay scene with landscape orientation
            let landscapeSize = CGSize(
                width: max(size.width, size.height),
                height: min(size.width, size.height)
            )
            
            let gameplayScene = GameplayScene(size: landscapeSize, gameModel: gameModel)
            gameplayScene.scaleMode = .aspectFill
            
            // Simple fade transition
            let transition = SKTransition.fade(withDuration: 0.3)
            view?.presentScene(gameplayScene, transition: transition)
        } else {
            // Visual indicator that we need more players
            startGameButton.run(SKAction.sequence([
                SKAction.scale(to: 1.1, duration: 0.1),
                SKAction.scale(to: 1.0, duration: 0.1)
            ]))
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        
        print("Touch at: \(location), nodes: \(touchedNodes.map { $0.name ?? "unnamed" })")
        
        // Check for button touches
        if touchedNodes.contains(where: { $0.name == "startGameButton" }) {
            startGame()
        } else if touchedNodes.contains(where: { $0.name == "addPlayerButton" }) {
            addPlayer()
        } else {
            // Check for delete player buttons
            for node in touchedNodes {
                if let name = node.name, name.starts(with: "deletePlayer-"), 
                   let indexString = name.split(separator: "-").last, 
                   let index = Int(indexString) {
                    
                    if gameModel.removePlayer(at: index) {
                        updatePlayerList()
                        updateUIState()
                    }
                    return
                }
            }
            
            // If no button was touched, dismiss keyboard
            view?.endEditing(true)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        // Add player when return is pressed if text field isn't empty
        if let text = textField.text, !text.isEmpty {
            addPlayer()
        }
        
        return true
    }

    override func willMove(from view: SKView) {
        playerNameTextField?.removeFromSuperview()
        print("MainMenuScene willMove from view")
    }
}
