import UIKit
import SpriteKit
import CoreData
import iAd
import AVFoundation

class SceneHandler {
    
    // current scene
    var currentScene: BaseScene?
    
    // controller
    var controller: GameViewController!
    
    // the view
    lazy var view: SKView = { return self.controller.view as! SKView }()

    /// init with controller
    init(controller: GameViewController) {
        self.controller = controller
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        self.view.ignoresSiblingOrder = true
        
        // react on AdHandler global events
        EventManager.sharedEventManager().addListeners([
            AdHandler.EventType.AdViewWillPresentScreen: {
                guard let scene = self.currentScene else {
                    return
                }
                
                scene.paused = true
            },
            AdHandler.EventType.AdViewDidDismissScreen: {
                guard let scene = self.currentScene else {
                    return
                }
                
                scene.paused = false
            }
        ], self)
    }
    
    // deinit
    deinit {
        EventManager.sharedEventManager().removeListener(self)
    }
    
    // remove current
    func removeCurrentScene() -> SceneHandler {
        if (self.currentScene != nil) {
            self.currentScene!.removeFromParent()
            self.currentScene = nil
        }
        
        return self
    }
    
    // set current
    func updateCurrentScene(sceneType: BaseScene.Type, data: Any? = nil) -> SceneHandler {
        self.removeCurrentScene()
        
        let scene = sceneType.init(fileNamed: "BaseScene")!
        scene.controller = self.controller
        if (data != nil) {
            scene.setData(data!)
        }
        self.currentScene = scene

        self.view.presentScene(scene, transition: SKTransition.flipVerticalWithDuration(1))
        
        return self
    }
    
    // present the scene as overlay
    func presentAsOverlay(sceneType: BaseScene.Type, data: Any? = nil) -> BaseScene {
        if (self.currentScene != nil) {
            self.currentScene!.paused = true
        }
        
        let scene = sceneType.init(fileNamed: "BaseScene")!
        scene.controller = self.controller
        if (data != nil) {
            scene.setData(data!)
        }

        let view = SKView(frame: UIScreen.mainScreen().bounds)
        view.opaque = false
        view.presentScene(scene)
        
        // bring all together
        self.controller.view.addSubview(view)
        self.controller.view.bringSubviewToFront(view)
        
        return scene
    }
}
