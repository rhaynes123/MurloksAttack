//
//  GameScene.swift
//  MurloksAttack
//
//  Created by richard Haynes on 12/16/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var scoreLabel: SKLabelNode?
    var pauseLabel : SKLabelNode?
    var resumeLabel : SKLabelNode?
    var score : Int = 0
    class func newGameScene() -> GameScene {
        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
            print("Failed to load GameScene.sks")
            abort()
        }
        scene.scaleMode = .aspectFill
        return scene
    }
    
    func setUpScene() {
        
        guard let view = self.view else {
            return
        }
        
        let topRightInView = CGPoint(x: view.bounds.maxX - 20, y: 20)
        let topRight = convertPoint(fromView: topRightInView)
        scoreLabel = self.childNode(withName: "//scoreLabel") as? SKLabelNode
        scoreLabel?.position = topRight
        
        let midUpperRightInView = CGPoint(x: view.bounds.maxX - 20, y: 100)
        let midRight = convertPoint(fromView: midUpperRightInView)
        pauseLabel = childNode(withName: "//pauseLabel") as? SKLabelNode
        pauseLabel?.position = midRight
        
        let leftMostUpperRightInView = CGPoint(x: view.bounds.maxX - 280, y: 100)
        let leftMostRight = convertPoint(fromView: leftMostUpperRightInView)
        resumeLabel = childNode(withName: "//resumeLabel") as? SKLabelNode
        resumeLabel?.position = leftMostRight
    }
    
    func spawnMurloks() {
        run(SKAction.repeatForever(SKAction.sequence([
            SKAction.run(spawnNewMurlok),
            SKAction.wait(forDuration: 0.5, withRange: 0.1)
        ])))
    }
    
    func spawnNewMurlok() {
        let murlokIndex = Int.random(in: 1...7)
        let murlok = SKSpriteNode(imageNamed: "murlok\(murlokIndex)")
        murlok.name = "murlok"
        
        let movesLeftToRight = Bool.random()
        let randomY = CGFloat.random(in: 0...size.height - murlok.size.height)
        let murlokY = randomY - size.height / 2 + murlok.size.height / 2
        
        if movesLeftToRight {
            let murlokX = -size.width / 2 - murlok.size.width / 2
            murlok.position = CGPoint(x: murlokX, y: murlokY)
        } else {
            let murlokX = size.width / 2 + murlok.size.width / 2
            murlok.position = CGPoint(x: murlokX, y: murlokY)
            murlok.xScale = -1
        }
        murlok.zPosition = 1
        addChild(murlok)
        
        let distance = size.width + murlok.size.width
        let speed = CGFloat(100)
        let duration = distance / speed
        
        let directionFactor : CGFloat = movesLeftToRight ? 1 : -1
        let moveAction = SKAction.moveBy(x: distance * directionFactor, y: 0, duration: TimeInterval(duration))
        let removeAction = SKAction.removeFromParent()
        murlok.run(SKAction.sequence([moveAction, removeAction]))
    }
    override func didMove(to view: SKView) {
        self.setUpScene()
        spawnMurloks()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return}
        let location = touch.location(in: self)
        let tappedNode = atPoint(location)
        
        let murlocSound = SKAction.playSoundFileNamed("murloc", waitForCompletion: false)
        if tappedNode.name == "murlok" {
            // TODO the sound effect keeps making an error I'm not able to find any content on
            run(murlocSound)
            tappedNode.removeFromParent()
            score += 5
            scoreLabel?.text = "Current Score: \(score)"
        }
        
        if tappedNode.name == "pauseLabel"{
            self.view?.isPaused = true
        }
        
        if tappedNode.name == "resumeLabel"{
            self.view?.isPaused = false
        }
    }
    
}
