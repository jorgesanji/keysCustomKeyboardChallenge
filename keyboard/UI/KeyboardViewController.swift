//
//  KeyboardViewController.swift
//  keyboard
//
//  Created by John Peterson on 5/10/22.
//

import UIKit
import SwiftUI

protocol KeyDelegate: AnyObject {
	func setText(_ text: String)
	func advanceToNextInput()
}

class KeyboardViewController: UIInputViewController {
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
		// Creating view model dependencies.
		
		// Rest repo for retrieving content from API.
		let restRepository = RestRepository()
		
		// Local repo for retrieving content from the local database when the user is offline.
		let localRepository = LocalRepository()
		
		// Handler repos for checking which repo has to be selected depending if the user has an internet connection or not.
		let proxyService = ProxyServiceImpl(restRepository: restRepository, localRepository: localRepository)
		
		// Use case for retrieving the content which will choose to depending of the Proxyservice.
		let getContent = GetContent(proxyService: proxyService)
		
		// this viewModel will be the owner of the data for RootView.
		let viewModel = DefaultKeyboardViewModel(getContent: getContent)
		
        setup(with: RootView(delegate: self, viewModel: viewModel))
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
    }
}

// MARK: - Custom Helpers for rendering SwiftUI (Don't worry about this)

extension KeyboardViewController {
    func setup<Content: View>(with view: Content) {
        self.view.subviews.forEach { $0.removeFromSuperview() }
        let controller = KeyboardHostingController(rootView: view)
        controller.add(to: self)
    }
}

public class KeyboardHostingController<Content: View>: UIHostingController<Content> {
    func add(to controller: KeyboardViewController) {
        controller.addChild(self)
        controller.view.addSubview(view)
        didMove(toParent: controller)
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: controller.view.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: controller.view.trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: controller.view.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: controller.view.bottomAnchor).isActive = true
    }
}

extension KeyboardViewController: KeyDelegate {
	
	func setText(_ text: String) {
		if let word: String = self.textDocumentProxy.documentContextBeforeInput {
			word.forEach { _ in
				self.textDocumentProxy.deleteBackward()
			}
		}
		textDocumentProxy.insertText(text)
	}
	
	func advanceToNextInput(){
		advanceToNextInputMode()
	}

}
