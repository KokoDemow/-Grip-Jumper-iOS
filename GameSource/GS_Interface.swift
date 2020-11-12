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

extension GameScene {
    
    /** Set interface nodes.*/
    func setInterface() {
        ///Settings node
        coinsIndicator.setInterfaceSize()
        labelCoins.horizontalAlignmentMode = .left
        buttonRestart.removeFromViewedPoint()
        buttonMenu.removeFromViewedPoint()
        buttonContinue.removeFromViewedPoint()
        
        ///Add nodes to scene
        addChild([background, interfaceHolder])
        
        interfaceHolder.addChild(labelScore)
        if SettingsGlobal.Skins.on { interfaceHolder.addChild([coinsIndicator, labelCoins])}
        
        if SettingsGlobal.Pause.on { interfaceHolder.addChild(buttonPause)}
        else { buttonPause.removeFromViewedPoint()}
    }
    
    //MARK: - Change scene
    func loadSceneEndWithDelay() {
        Timer.scheduledTimer(timeInterval: SettingsGameProcess.delayLoadSceneIfLose, target: self, selector: #selector(loadSceneEnd), userInfo: nil, repeats: false)
    }
    
    @objc fileprivate func loadSceneEnd() {
        loadScene(.end, withTransitionName: .pushLeft)
    }
}
