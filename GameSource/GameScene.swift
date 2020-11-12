/*
 
 Created by TapTapStudio (Alice Vinnik).
 Copyright ©2020 TapTapStudio. All rights reserved.

 ▀▀█▀▀ ░█▀▀█ ▒█▀▀█ ▀▀█▀▀ ░█▀▀█ ▒█▀▀█
 ░▒█░░ ▒█▄▄█ ▒█▄▄█ ░▒█░░ ▒█▄▄█ ▒█▄▄█
 ░▒█░░ ▒█░▒█ ▒█░░░ ░▒█░░ ▒█░▒█ ▒█░░░

 ▒█▀▀▀█ ▀▀█▀▀ ▒█░▒█ ▒█▀▀▄ ▀█▀ ▒█▀▀▀█
 ░▀▀▀▄▄ ░▒█░░ ▒█░▒█ ▒█░▒█ ▒█░ ▒█░░▒█
 ▒█▄▄▄█ ░▒█░░ ░▀▄▄▀ ▒█▄▄▀ ▄█▄ ▒█▄▄▄█
 
 If you want reskin write me.
 Here you can see reskin examples 🌅: https://alicevinnik.wixsite.com/taptapstudio
 Subscribe to my instagram 📷: https://www.instagram.com/taptap_studio/
 Write to my mail 💌: taptap.main@gmail.com
 
*/

import SpriteKit

class GameScene: GlobalScene {
    
    //MARK: Values
    enum SwipePlayer {
        case left
        case right
        case up
    }
    
    var changeSceneToMenuInPauseMenu = true
    var gameIsPlay = false
    var isFirstSwipe = true
    var increaseCoinAfterMoves = SettingsGameProcess.Coin.increseCoinAfterMoves
    var score = 0
    
    var cameraSpeed = SettingsGameProcess.Camera.Speed.start
    var enemyPositionLineY = SettingsScenes.Game.Position.player.y + (SettingsScenes.Game.Size.player.height / 2) + (SettingsScenes.Game.Size.enemy.height / 2)
    
    var arrayWithEnemys = [[EnemyNode]]()
    
    var swipeLeft: UISwipeGestureRecognizer?
    var swipeRight: UISwipeGestureRecognizer?
    var swipeDown: UISwipeGestureRecognizer?
    var swipeUp: UISwipeGestureRecognizer?
    
    //MARK: Nodes
    var currentCamera: SKCameraNode = SKCameraNode()
    
    var background = BackgroundNode()
    var pauseBackground = SimpleNode(texture: GraphicPreloadsGame.preload.pauseBackground, size: SettingsScenes.Game.Size.pauseBackground, position: SettingsScenes.Game.Position.pauseBackground, zPosition: SettingsScenes.Game.ZPosition.pauseBackground)
    var interfaceHolder = TransparentNode(size: SettingsScenes.Game.Size.interfaceHolder, position: SettingsScenes.Game.Position.interfaceHolder, zPosition: SettingsScenes.Game.ZPosition.interfaceHolder)

    var coinsIndicator = SimpleNode(texture: GraphicPreloadsInterface.preload.coinsIndicator, size: SettingsScenes.Game.Size.coinsIndicator, position: SettingsScenes.Game.Position.coinsIndicator, zPosition: SettingsScenes.Game.ZPosition.coinsIndicator)
    
    var buttonPause = ButtonNode(texture: GraphicPreloadsInterface.preload.button_Pause, size: SettingsScenes.Game.Size.buttonPause, position: SettingsScenes.Game.Position.buttonPause, zPosition: SettingsScenes.Game.ZPosition.buttonPause)
    var buttonRestart = ButtonNode(texture: GraphicPreloadsInterface.preload.button_Restart, size: SettingsScenes.Game.Size.buttonRestart, zPosition: SettingsScenes.Game.ZPosition.buttonRestart)
    var buttonMenu = ButtonNode(texture: GraphicPreloadsInterface.preload.button_Menu, size: SettingsScenes.Game.Size.buttonMenu, zPosition: SettingsScenes.Game.ZPosition.buttonMenu)
    var buttonContinue = ButtonNode(texture: GraphicPreloadsInterface.preload.button_Continue, size: SettingsScenes.Game.Size.buttonContinue, zPosition: SettingsScenes.Game.ZPosition.buttonContinue)
    
    var labelScore = SimpleLabel(text: "0", fontSize: SettingsScenes.Game.FontSize.labelScore, fontColorHex: SettingsScenes.Game.FontColor.labelScore, position: SettingsScenes.Game.Position.labelScore, zPosition: SettingsScenes.Game.ZPosition.labelScore)
    var labelCoins = SimpleLabel(text: String(UserDefaults.standard.integer(forKey: "Coins")), fontSize: SettingsScenes.Game.FontSize.labelCoins, fontColorHex: SettingsScenes.Game.FontColor.labelCoins, position: SettingsScenes.Game.Position.labelCoins, zPosition: SettingsScenes.Game.ZPosition.labelCoins)
    
    var textPause = SimpleNode(texture: GraphicPreloadsInterface.preload.textPause, size: SettingsScenes.Game.Size.textPause, position: SettingsScenes.Game.Position.textPause, zPosition: SettingsScenes.Game.ZPosition.textPause)
    
    var player = PlayerNode()
    
    //MARK: - Scene life cycle
    override func didMove(to view: SKView) {
        ///Init game components
        currentCamera = SKCameraNode()
        camera = currentCamera
        currentCamera.position = CGPoint(x: SettingsGlobal.width / 2, y: SettingsGlobal.height / 2)
        addChild(currentCamera)
        
        //Init gestures
        swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(inputSwipeLeft))
        swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(inputSwipeRight))
        swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(inputSwipeDown))
        swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(inputSwipeUp))
        swipeLeft?.direction = UISwipeGestureRecognizer.Direction.left
        swipeRight?.direction = UISwipeGestureRecognizer.Direction.right
        swipeDown?.direction = UISwipeGestureRecognizer.Direction.down
        swipeUp?.direction = UISwipeGestureRecognizer.Direction.up
        view.addGestureRecognizer(swipeLeft!)
        view.addGestureRecognizer(swipeRight!)
        view.addGestureRecognizer(swipeDown!)
        view.addGestureRecognizer(swipeUp!)
        
        ///Set game
        setInterface()
        
        ///Start game
        startGame()
    }
    
    //MARK: - Game progress
    /** Start game object. Prepare your game object here*/
    fileprivate func startGame() {
        gameIsPlay = true
        setPlayer()
        generateEnemysLineAtStart()
        moveCamera()
    }
    
    /** End game method. Save all game results here. */
    func endGame() {
        if gameIsPlay {
            gameIsPlay = false
            saveScore()
            makeScreenshot()
            view?.gestureRecognizers?.forEach((view?.removeGestureRecognizer)!)
            
            loadSceneEndWithDelay()
        }
    }
    
    //MARK: - Update
    override func update(_ currentTime: TimeInterval) {
        ///Follow interface to camera
        if SettingsGameProcess.followCameraToPlayer {
            //camera!.position = CGPoint(x: player.position.x, y: player.position.y + ((SettingsGlobal.height / 2) - SettingsScenes.Game.Position.player.y))
            interfaceHolder.position = CGPoint(x: currentCamera.position.x - SettingsGlobal.width / 2, y: currentCamera.position.y - SettingsGlobal.height / 2)
            background.position = camera!.position
        }
        
        ///End game if camera higher than player
        if currentCamera.position.y - SettingsGlobal.height / 2 >= player.position.y {
            endGame()
        }
    }
    
    //MARK: - Inputs
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameIsPlay {
            for touch in touches {
                //let location = touch.location(in: self)
                let locationInterfaceHolder = touch.location(in: interfaceHolder)
                
                ///Game inputs
                if !buttonPause.contains(locationInterfaceHolder) && !buttonMenu.contains(locationInterfaceHolder) && !buttonRestart.contains(locationInterfaceHolder) && !buttonContinue.contains(locationInterfaceHolder) {
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            ///let location = touch.location(in: self)
            let locationInterfaceHolder = touch.location(in: interfaceHolder)
            
            ///Interface
            ///Change button state to simple
            touchUpAllButtons()
            if buttonPause.contains(locationInterfaceHolder) {
                pauseGame()
            }
            if scene?.view?.isPaused == true {
                if buttonMenu.contains(locationInterfaceHolder) {
                    continueGame()
                    changeSceneAfterPause(toMenu: true)
                }
                if buttonRestart.contains(locationInterfaceHolder) {
                    continueGame()
                    changeSceneAfterPause(toMenu: false)
                }
                if buttonContinue.contains(locationInterfaceHolder) {
                    continueGame()
                }
            }
        }
    }
    
    //MARK: Swipe inputs
    
    @objc func inputSwipeLeft() {
        if gameIsPlay {
            swipePlayer(toDestination: .left)
        }
    }
    
    @objc func inputSwipeRight() {
        if gameIsPlay {
            swipePlayer(toDestination: .right)
        }
    }
    
    @objc func inputSwipeDown() {
        if gameIsPlay {
        }
    }
    
    @objc func inputSwipeUp() {
        if gameIsPlay {
            swipePlayer(toDestination: .up)
        }
    }
}
