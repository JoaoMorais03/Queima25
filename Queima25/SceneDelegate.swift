import UIKit
import SpriteKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.backgroundColor = UIColor(red: 0.12, green: 0.12, blue: 0.2, alpha: 1.0) // Match app theme
        self.window = window
        let gameViewController = GameViewController()
        window.rootViewController = gameViewController
        window.makeKeyAndVisible()
    }
}