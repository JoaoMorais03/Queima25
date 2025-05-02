import UIKit
import SpriteKit

class GameViewController: UIViewController {
    private var isInGameplayMode = false
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        print("GameViewController initialized")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("GameViewController initialized from storyboard")
    }
    
    override func loadView() {
        // Force a new SKView instead of using the one from storyboard
        let frame = UIScreen.main.bounds
        let skView = SKView(frame: frame)
        skView.backgroundColor = UIColor(red: 0.12, green: 0.12, blue: 0.2, alpha: 1.0)
        self.view = skView
        print("GameViewController loadView created new SKView")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Explicit debug print
        print("GameViewController viewDidLoad")
        
        // Add notification observers for orientation changes
        NotificationCenter.default.addObserver(self, selector: #selector(handleLandscapeChange), name: NSNotification.Name("SwitchToLandscapeMode"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handlePortraitChange), name: NSNotification.Name("SwitchToPortraitMode"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func handleLandscapeChange() {
        print("Switching to landscape mode")
        isInGameplayMode = true
        
        if #available(iOS 16.0, *) {
            if let windowScene = view.window?.windowScene {
                let preferredOrientation = UIInterfaceOrientationMask.landscape
                let geometryPreferences = UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: preferredOrientation)
                windowScene.requestGeometryUpdate(geometryPreferences)
            }
        } else {
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        }
        
        DispatchQueue.main.async {
            UIViewController.attemptRotationToDeviceOrientation()
        }
    }
    
    @objc private func handlePortraitChange() {
        print("Switching to portrait mode")
        isInGameplayMode = false
        
        if #available(iOS 16.0, *) {
            if let windowScene = view.window?.windowScene {
                let preferredOrientation = UIInterfaceOrientationMask.portrait
                let geometryPreferences = UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: preferredOrientation)
                windowScene.requestGeometryUpdate(geometryPreferences)
            }
        } else {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        }
        
        DispatchQueue.main.async {
            UIViewController.attemptRotationToDeviceOrientation()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("GameViewController viewWillLayoutSubviews with bounds: \(view.bounds)")
        
        // Only setup once
        if let skView = view as? SKView, skView.scene == nil {
            print("Setting up SKView...")
            
            // Configure SKView with better rendering quality
            skView.ignoresSiblingOrder = true
            skView.allowsTransparency = true
            
            // Always disable debug info
            skView.showsFPS = false
            skView.showsNodeCount = false
            skView.showsDrawCount = false
            
            // Create the main menu scene with current view size
            let mainMenuScene = MainMenuScene(size: view.bounds.size)
            
            // Add a smooth transition
            let transition = SKTransition.fade(withDuration: 0.3)
            
            // Present it
            print("Presenting main menu scene with size: \(mainMenuScene.size)")
            skView.presentScene(mainMenuScene, transition: transition)
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return isInGameplayMode ? .landscape : .portrait
    }
}