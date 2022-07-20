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
	
	override func buildUseCaseObservable() -> Observable<ContentResponse>? {
		return proxyService!.repository.getContent()
	}
}
