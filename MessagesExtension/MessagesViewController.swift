//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by Hanawa Takuro on 2016/06/25.
//  Copyright © 2016年 Hanawa Takuro. All rights reserved.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        
        // Use this method to configure the extension and restore previously stored state.

        transition(conversation: conversation)
    }
    
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
    }
   
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        
        // Use this method to trigger UI updates in response to the message.
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
    }

    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
    
        // Use this to clean up state related to the deleted message.
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.
    
        // Use this method to prepare for the change in presentation style.

        guard let conversation = activeConversation else { return }
        transition(conversation: conversation)
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
    
        // Use this method to finalize any behaviors associated with the change in presentation style.
    }

    private func transition(conversation: MSConversation) {

        if let selectMessage = conversation.selectedMessage {

            if let rpsBattle = RpsBattle(message: selectMessage) where rpsBattle.canBattle {

                guard let viewController = storyboard?
                    .instantiateViewController(withIdentifier: BattleViewController.identifier)
                    as? BattleViewController else { fatalError() }

                viewController.rpsBattle = rpsBattle
                show(viewController, sender: nil)

            } else {

                guard let viewController = storyboard?
                    .instantiateViewController(withIdentifier: SelectViewController.identifier)
                    as? SelectViewController else { fatalError() }

                viewController.message = selectMessage
                viewController.delegate = self
                show(viewController, sender: nil)
            }

        } else {

            guard let viewController = storyboard?
                .instantiateViewController(withIdentifier: SelectViewController.identifier)
                as? SelectViewController else { fatalError() }

            viewController.delegate = self
            show(viewController, sender: nil)
        }
    }
}

extension MessagesViewController: SelectedRps {

    func selectedRps(message: MSMessage) {
        activeConversation?.insert(message, localizedChangeDescription: "Start RPS Battle!", completionHandler: nil)
        dismiss()
    }
}
