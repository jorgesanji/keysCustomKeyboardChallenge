//
//  DefaultKeyboardViewModel.swift
//  keyboard
//
//  Created by Jorge Sanmartin on 19/07/22.
//

import Combine

class DefaultKeyboardViewModel: ObservableObject, KeyboardViewModel {
	
	private var getContent: GetContentUseCase
	
	private var arrayItems: [[String]] = []
		
	@Published var state: State = .idle

	var content: [String] = []
		
	var items: [String] = []
	
	init(getContent: GetContentUseCase){
		self.getContent = getContent
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
		self.items = arrayItems[index]
		self.state = .showItem
	}
	
	func hideItems() {
		self.state = .success
	}
	
	func fetchContent(){
		self.state = .syncing
		getContent.build().subscribe {[weak self] response in
			self?.handleContentResponse(response)
		} onError: {[weak self] error in
			self?.handleContentError(error)
		}
	}
}
