//
//  KeyboardViewModel.swift
//  keyboard
//
//  Created by Jorge Sanmartin on 19/07/22.
//

typealias KeyboardViewModel = Keyboard_ViewModel

protocol Keyboard_ViewModel {
		
	var state: State { get }
	
	var content: [String] { get }
	
	var items: [String] { get }
		
	func showItemsAtContentIndex(_ index: Int)
	
	func hideItems()
	
	func fetchContent()
}

enum State: Int{
	case error
	case success
	case idle
	case syncing
	case showItem
}
