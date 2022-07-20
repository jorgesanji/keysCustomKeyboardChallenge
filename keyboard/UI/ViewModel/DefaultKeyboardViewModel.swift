//
//  DefaultKeyboardViewModel.swift
//  keyboard
//
//  Created by Jorge Sanmartin on 19/07/22.
//

import Combine

final class DefaultKeyboardViewModel: ObservableObject, KeyboardViewModel {
	
	private final let getConten: GetContentUseCase
	
	@Published private var currentIndex: Int = -1
	
	@Published var state: State = .idle
	
	var content: [String] = []
	
	private var arrayItems: [[String]] = []
	
	var items: [String] {
		arrayItems[currentIndex]
	}
	
	init(getContent: GetContentUseCase){
		self.getConten = getContent
	}
	
	private func handleContentResponse(_ response: ContentResponse) {
		self.content = response.content.map({ $0.displayText })
		self.arrayItems = response.content.map({ $0.content })
		self.state = .success
	}
	
	private func handleContentError(_ error: Error) {
		self.state = .error
	}
		
	func showItemsAtContentIndex(_ index: Int) {
		self.state = .showItem
		self.currentIndex = index
	}
	
	func hideItems() {
		self.state = .success
	}
	
	func fetchContent(){
		self.state = .syncing
		getConten.build().subscribe {[weak self] response in
			self?.handleContentResponse(response)
		} onError: {[weak self] error in
			self?.handleContentError(error)
		}
	}
}
