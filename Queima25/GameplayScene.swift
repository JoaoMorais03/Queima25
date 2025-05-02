import SpriteKit
import UIKit

class GameplayScene: SKScene {
    private let gameModel: GameModel
    private var phraseLabel: SKLabelNode!
    private var categoryLabel: SKLabelNode!
    private var phraseBubble: SKShapeNode!
    private var backButton: SKSpriteNode!
    private var timerLabel: SKLabelNode!
    private var startTimerButton: SKShapeNode!
    private var isLayoutDone = false
    private var currentTimedDuration: Double?
    
    // Modern color scheme (matching MainMenuScene)
    private let primaryColor = UIColor(red: 0.95, green: 0.3, blue: 0.4, alpha: 1.0)
    private let buttonColor = UIColor(red: 0.2, green: 0.6, blue: 0.9, alpha: 1.0)
    private let accentColor = UIColor(red: 0.9, green: 0.7, blue: 0.2, alpha: 1.0)
    private let darkColor = UIColor(red: 0.15, green: 0.15, blue: 0.25, alpha: 1.0)
    private let sceneBackgroundColor = UIColor(red: 0.12, green: 0.12, blue: 0.2, alpha: 1.0)
    
    // Darker variants for category backgrounds
    private let darkerSystemRed = UIColor.systemRed.adjust(by: -0.3) ?? .systemRed // Fallback
    private let darkerSystemGreen = UIColor.systemGreen.adjust(by: -0.3) ?? .systemGreen // Fallback
    
    init(size: CGSize, gameModel: GameModel) {
        self.gameModel = gameModel
        
        // Always create in landscape orientation
        let landscapeSize = CGSize(
            width: max(size.width, size.height),
            height: min(size.width, size.height)
        )
        super.init(size: landscapeSize)
        backgroundColor = self.sceneBackgroundColor
        print("GameplayScene initialized with landscape size: \(self.size)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        print("GameplayScene didMove to view with size: \(self.size)")
        
        // Remove any existing subviews
        view.subviews.forEach { if $0 is UITextField { $0.removeFromSuperview() } }
        
        // Use resizeFill to avoid stretching
        self.scaleMode = .aspectFill
        
        // Switch to landscape mode
        NotificationCenter.default.post(name: NSNotification.Name("SwitchToLandscapeMode"), object: nil)
        
        // We'll wait for the layout to finish with proper bounds
        setupSceneWithDelay()
    }
    
    private func setupSceneWithDelay() {
        // Delay setup to ensure the bounds are properly set after rotation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self = self, !self.isLayoutDone, let view = self.view else { return }
            
            print("Setting up GameplayScene after orientation change, view size: \(view.bounds.size)")
            
            // Only setup once
            self.isLayoutDone = true
            
            // Setup the scene with current view bounds
            self.setupBackground()
            self.setupBasicUI()
            self.displayPhrase()
        }
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        print("GameplayScene size changed from \(oldSize) to \(size)")
        
        // Re-layout UI if size changed significantly
        if !isLayoutDone || abs(oldSize.width - size.width) > 100 || abs(oldSize.height - size.height) > 100 {
            isLayoutDone = false
            setupSceneWithDelay()
        }
    }
    
    private func setupBackground() {
        // Removed dotted background for full-screen color effect
        // The scene's background color is set in init and updated in displayPhrase
    }
    
    private func setupBasicUI() {
        // Remove any existing UI
        self.removeAllChildren()
        
        // Add background elements
        setupBackground()
        
        // Create a speech bubble using SKShapeNode for rounded corners
        let bubbleSize = CGSize(width: size.width * 0.8, height: size.height * 0.5)
        let bubblePath = CGPath(roundedRect: CGRect(origin: CGPoint(x: -bubbleSize.width/2, y: -bubbleSize.height/2), 
                                                    size: bubbleSize), 
                                cornerWidth: 20, cornerHeight: 20, transform: nil)
        
        phraseBubble = SKShapeNode(path: bubblePath)
        phraseBubble.fillColor = darkColor
        phraseBubble.strokeColor = darkColor.withAlphaComponent(0.6)
        phraseBubble.lineWidth = 1
        phraseBubble.position = CGPoint(x: size.width/2, y: size.height/2)
        phraseBubble.zPosition = 5
        
        addChild(phraseBubble)
        
        // Create a large label in the center of the bubble
        phraseLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        phraseLabel.numberOfLines = 0
        // Adjust preferredMaxLayoutWidth based on the SKShapeNode's frame if needed, but direct size should work
        phraseLabel.preferredMaxLayoutWidth = bubbleSize.width * 0.85 
        phraseLabel.fontSize = 36
        phraseLabel.fontColor = .white
        phraseLabel.position = CGPoint(x: 0, y: -10) // Move down to make space
        phraseLabel.horizontalAlignmentMode = .center
        phraseLabel.verticalAlignmentMode = .center
        phraseLabel.zPosition = 10 // Ensure label is above bubble shape
        phraseBubble.addChild(phraseLabel)
        
        // Add category label (initially hidden/empty)
        categoryLabel = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        categoryLabel.fontSize = 18
        categoryLabel.fontColor = UIColor.white.withAlphaComponent(0.8)
        categoryLabel.position = CGPoint(x: 0, y: phraseBubble.frame.height/2 - 25) // Position near the top
        categoryLabel.horizontalAlignmentMode = .center
        categoryLabel.verticalAlignmentMode = .top
        categoryLabel.zPosition = 11 // Above phrase label
        categoryLabel.text = ""
        categoryLabel.isHidden = true
        phraseBubble.addChild(categoryLabel)
        
        // Add timer label (initially hidden)
        timerLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        timerLabel.fontSize = 60
        timerLabel.fontColor = accentColor // Use accent color for timer
        timerLabel.position = CGPoint(x: size.width / 2, y: size.height - 80) // Position at top of screen
        timerLabel.horizontalAlignmentMode = .center
        timerLabel.zPosition = 10
        timerLabel.isHidden = true
        addChild(timerLabel)
        
        // Add start timer button (initially hidden)
        let startButtonSize = CGSize(width: 180, height: 60) // Increased size
        let startButtonPath = CGPath(roundedRect: CGRect(origin: CGPoint(x: -startButtonSize.width/2, y: -startButtonSize.height/2),
                                                       size: startButtonSize),
                                   cornerWidth: 12, cornerHeight: 12, transform: nil)
        
        startTimerButton = SKShapeNode(path: startButtonPath)
        startTimerButton.fillColor = accentColor
        startTimerButton.strokeColor = .clear
        startTimerButton.position = CGPoint(x: size.width - 110, y: 50) // Bottom right corner
        startTimerButton.name = "startTimerButton"
        startTimerButton.zPosition = 10
        startTimerButton.isHidden = true
        
        // Add shadow for start button
        let startButtonShadowPath = CGPath(roundedRect: CGRect(origin: CGPoint(x: -startButtonSize.width/2, y: -startButtonSize.height/2),
                                                             size: startButtonSize),
                                         cornerWidth: 12, cornerHeight: 12, transform: nil)
        let startButtonShadow = SKShapeNode(path: startButtonShadowPath)
        startButtonShadow.fillColor = UIColor.black
        startButtonShadow.strokeColor = .clear
        startButtonShadow.alpha = 0.3
        startButtonShadow.position = CGPoint(x: size.width - 110 + 3, y: 50 - 3) // Adjusted shadow position
        startButtonShadow.zPosition = 9
        startButtonShadow.isHidden = true
        startButtonShadow.name = "startTimerButtonShadow"
        
        addChild(startButtonShadow)
        addChild(startTimerButton)
        
        let startLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        startLabel.text = "INICIAR TEMPO"
        startLabel.fontSize = 22 // Slightly larger font
        startLabel.fontColor = .white
        startLabel.verticalAlignmentMode = .center
        startTimerButton.addChild(startLabel)
        
        // Add a styled menu button with rounded corners
        let backButtonSize = CGSize(width: 120, height: 44)
        let backButtonPath = CGPath(roundedRect: CGRect(origin: CGPoint(x: -backButtonSize.width/2, y: -backButtonSize.height/2),
                                                        size: backButtonSize),
                                    cornerWidth: 12, cornerHeight: 12, transform: nil)
        
        let backButtonShape = SKShapeNode(path: backButtonPath)
        backButtonShape.fillColor = primaryColor
        backButtonShape.strokeColor = .clear
        backButtonShape.position = CGPoint(x: 80, y: size.height - 40)
        backButtonShape.name = "backButton"
        backButtonShape.zPosition = 10
        
        // Fix shadow for back button - position it correctly underneath
        let backButtonShadowPath = CGPath(roundedRect: CGRect(origin: CGPoint(x: -backButtonSize.width/2, y: -backButtonSize.height/2),
                                                        size: backButtonSize),
                                    cornerWidth: 12, cornerHeight: 12, transform: nil)
        let backButtonShadow = SKShapeNode(path: backButtonShadowPath)
        backButtonShadow.fillColor = UIColor.black
        backButtonShadow.strokeColor = .clear
        backButtonShadow.alpha = 0.3
        backButtonShadow.position = CGPoint(x: 80 + 3, y: size.height - 40 - 3) // Absolute position
        backButtonShadow.zPosition = 9
        
        addChild(backButtonShadow)
        addChild(backButtonShape)
        
        let backLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        backLabel.text = "MENU"
        backLabel.fontSize = 20
        backLabel.fontColor = .white
        backLabel.verticalAlignmentMode = .center
        backButtonShape.addChild(backLabel)
        
        // Add a simple, subtle tap instruction text without any container
        let tapLabel = SKLabelNode(fontNamed: "AvenirNext-Medium")
        tapLabel.text = "carrega para continuar seu estúpido"
        tapLabel.fontSize = 18
        tapLabel.fontColor = UIColor.white.withAlphaComponent(0.7)
        tapLabel.position = CGPoint(x: size.width/2, y: 60)
        tapLabel.horizontalAlignmentMode = .center
        tapLabel.zPosition = 10
        addChild(tapLabel)
        
        print("UI setup complete with scene size: \(size)")
    }
    
    private func displayPhrase() {
        // Stop any existing timer
        stopTimer()
        
        // Get a random phrase, its category, and optional duration
        guard let (phraseText, phraseCategory, duration) = gameModel.getNextPhrase() else {
            phraseLabel.text = "No more phrases!"
            print("No more phrases available.")
            return
        }
        
        // Set the label directly, resetting font size first
        phraseLabel.fontSize = 36 // Reset to default size
        phraseLabel.text = phraseText
        
        var bubbleColor = darkColor // Reintroduce bubbleColor
        var categoryText = ""
        var isCategoryHidden = true

        switch phraseCategory {
        case .normal:
            self.backgroundColor = sceneBackgroundColor // Default background
            bubbleColor = darkColor // Default bubble color
            categoryText = "ALCOLISMO PESADO"
            isCategoryHidden = false
        case .warning:
            self.backgroundColor = darkerSystemRed // Darker Red background for warning
            bubbleColor = .systemRed // Standard Red for bubble
            categoryText = "JA TE FODESTE"
            isCategoryHidden = false
        case .game:
            self.backgroundColor = darkerSystemGreen // Darker Green background for game
            bubbleColor = .systemGreen // Standard Green for bubble
            categoryText = "2 ou 1"
            isCategoryHidden = false
        case .never:
            self.backgroundColor = UIColor.systemIndigo // Darker Green background for game
            bubbleColor = UIColor.systemIndigo // Standard Green for bubble
            categoryText = "EU NUNCA"
            isCategoryHidden = false
        case .timedChallenge:
            self.backgroundColor = UIColor.systemOrange.adjust(by: -0.3) ?? UIColor.systemOrange // Darker Orange background
            bubbleColor = UIColor.systemOrange // Standard Orange for bubble
            categoryText = "RAPIDO SEU NABO"
            isCategoryHidden = false
        }

        // Update category label
        categoryLabel.text = categoryText
        categoryLabel.isHidden = isCategoryHidden
        
        // --- Dynamic Font Size Adjustment ---
        let defaultFontSize: CGFloat = 36
        let minimumFontSize: CGFloat = 16
        let verticalPadding: CGFloat = 40 // Total top/bottom padding inside bubble
        let categoryLabelHeight: CGFloat = isCategoryHidden ? 0 : (categoryLabel.frame.height + 10) // Height + spacing if visible
        
        let availableHeight = phraseBubble.frame.height - verticalPadding - categoryLabelHeight
        
        // Ensure label calculates its frame correctly before checking
        // Accessing frame might be needed to trigger layout calculation in SpriteKit
        _ = phraseLabel.frame 

        // Adjust font size if needed
        while phraseLabel.frame.height > availableHeight && phraseLabel.fontSize > minimumFontSize {
            phraseLabel.fontSize -= 1
            _ = phraseLabel.frame // Recalculate frame
        }
        // Final check in case minimum font size is still too large
        if phraseLabel.frame.height > availableHeight && phraseLabel.fontSize == minimumFontSize {
            print("Warning: Text might still overflow slightly even at minimum font size.")
        }
        // --- End Dynamic Font Size Adjustment ---
        
        // Set bubble color directly
        phraseBubble.fillColor = bubbleColor
        
        // --- Timer Handling for timedChallenge ---
        if phraseCategory == .timedChallenge, let timeLimit = duration {
            prepareTimerChallenge(duration: timeLimit)
        } else {
            hideTimerUI()
        }
        // --- End Timer Handling ---
        
        // Print for debugging
        print("Displaying phrase: \(phraseText) (Category: \(phraseCategory), Duration: \(duration ?? -1))")
    }
    
    private func prepareTimerChallenge(duration: Double) {
        // Store duration for later use
        currentTimedDuration = duration
        
        // Reset and show timer
        timerLabel.isHidden = false
        timerLabel.text = "\(Int(duration))"
        timerLabel.run(SKAction.scale(to: 1.0, duration: 0.1)) // Reset scale
        
        // Show start button
        startTimerButton.isHidden = false
        childNode(withName: "startTimerButtonShadow")?.isHidden = false
    }
    
    private func hideTimerUI() {
        currentTimedDuration = nil
        timerLabel.isHidden = true
        startTimerButton.isHidden = true
        childNode(withName: "startTimerButtonShadow")?.isHidden = true
    }
    
    private func startTimer(duration: Double) {
        // Hide the start button
        startTimerButton.isHidden = true
        childNode(withName: "startTimerButtonShadow")?.isHidden = true
        
        // Show and configure timer
        timerLabel.isHidden = false
        var remainingTime = Int(duration)
        timerLabel.text = "\(remainingTime)"
        
        // Create the sequence of actions for the countdown
        let waitAction = SKAction.wait(forDuration: 1.0)
        let updateAction = SKAction.run { [weak self] in
            guard let self = self else { return }
            remainingTime -= 1
            self.timerLabel.text = "\(remainingTime)"
            if remainingTime <= 0 {
                self.stopTimer(finished: true)
            }
        }
        
        let sequence = SKAction.sequence([waitAction, updateAction])
        let repeatAction = SKAction.repeat(sequence, count: Int(duration))
        
        // Assign a key to the action so we can remove it later
        timerLabel.run(repeatAction, withKey: "countdownTimer")
        
        // Add a visual pulse effect to the timer
        let scaleUp = SKAction.scale(to: 1.2, duration: 0.3)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.3)
        let pulseSequence = SKAction.sequence([scaleUp, scaleDown])
        let pulseForever = SKAction.repeatForever(pulseSequence)
        timerLabel.run(pulseForever, withKey: "timerPulse")
    }

    private func stopTimer(finished: Bool = false) {
        timerLabel.removeAction(forKey: "countdownTimer")
        timerLabel.removeAction(forKey: "timerPulse")
        timerLabel.run(SKAction.scale(to: 1.0, duration: 0.1)) // Reset scale
        
        // Hide both timer label and start button
        if finished {
             timerLabel.text = "TEMPO!!" // Indicate time's up
             // Optionally hide after a short delay
             let wait = SKAction.wait(forDuration: 1.5)
             let hide = SKAction.run { 
                 self.timerLabel.isHidden = true 
                 self.startTimerButton.isHidden = true
                 self.childNode(withName: "startTimerButtonShadow")?.isHidden = true
             }
             timerLabel.run(SKAction.sequence([wait, hide]))
        } else {
            hideTimerUI()
        }
        print("Timer stopped. Finished: \(finished)")
    }
    
    private func returnToMainMenu() {
        gameModel.resetCurrentGame()
        stopTimer() // Stop timer before returning
        
        // First, hide all visible elements to prevent the blurry text effect
        self.children.forEach { $0.alpha = 0 }
        
        // Optional: add a background color overlay to match the main menu color
        let backgroundOverlay = SKSpriteNode(color: sceneBackgroundColor, size: self.size)
        backgroundOverlay.position = CGPoint(x: size.width/2, y: size.height/2)
        backgroundOverlay.zPosition = 100
        addChild(backgroundOverlay)
        
        // Switch back to portrait mode
        NotificationCenter.default.post(name: NSNotification.Name("SwitchToPortraitMode"), object: nil)
        
        // Delay transition slightly to allow orientation change
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            print("Returning to main menu")
            
            // Use portrait size when creating MainMenuScene
            let portraitSize = CGSize(
                width: min(self.size.width, self.size.height),
                height: max(self.size.width, self.size.height)
            )
            
            let mainMenu = MainMenuScene(size: portraitSize, gameModel: self.gameModel)
            mainMenu.scaleMode = .aspectFill
            
            // Simple fade transition
            let transition = SKTransition.fade(withDuration: 0.3)
            self.view?.presentScene(mainMenu, transition: transition)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        
        print("Touch at: \(location), touched nodes: \(touchedNodes.map { $0.name ?? "unnamed" })")
        
        if touchedNodes.contains(where: { $0.name == "backButton" }) {
            returnToMainMenu()
        } else if touchedNodes.contains(where: { $0.name == "startTimerButton" }) {
            // Start the timer when the button is clicked
            if let duration = currentTimedDuration {
                startTimer(duration: duration)
            }
        } else {
            // Display a new phrase on touch (only if not a timer button)
            displayPhrase()
        }
    }
    
    override func willMove(from view: SKView) {
        print("GameplayScene willMove from view")
    }
}

// Helper extension to adjust color brightness
extension UIColor {
    func adjust(by percentage: CGFloat) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(max(red + percentage, 0), 1),
                           green: min(max(green + percentage, 0), 1),
                           blue: min(max(blue + percentage, 0), 1),
                           alpha: alpha)
        }
        return nil
    }
}