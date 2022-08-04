//
//  GetContent.swift
//  keyboard
//
//  Created by Jorge Sanmartin on 18/07/22.
//

import RxSwift

protocol GetContentUseCase: AnyObject {
	func build() -> BaseUseCase<ContentResponse>
}

final class GetContent: BaseUseCase<ContentResponse>, GetContentUseCase {
	
	/*override func buildUseCaseObservable() -> Observable<ContentResponse>? {
		return fetchLocalContent()!.flatMap { response -> Observable<ContentResponse> in
			// Check if local database has items if not request to API.
			if response.content.count > 0 {
				return Observable.just(response)
			} else {
				return self.fetchApiContent()!
			}
		}
	}*/
	
	override func buildUseCaseObservable() -> Observable<ContentResponse>? {
		Observable.concat(self.fetchLocalContent()!, self.fetchApiContent()!)
	}
	
	private func savingContent(_ content: ContentResponse) -> Observable<ContentResponse>? {
		proxyService!.localRepository.saveContent(content)!
	}
	
	private func fetchLocalContent() -> Observable<ContentResponse>? {
		proxyService!.localRepository.getContent()
	}
	
	private func fetchApiContent() -> Observable<ContentResponse>? {
		proxyService!.repository.getContent()!.flatMap({ response in
			return self.savingContent(response)!
		})
	}
}
