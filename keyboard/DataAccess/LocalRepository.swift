//
//  LocalRepository.swift
//  keyboard
//
//  Created by Jorge Sanmartin on 18/07/22.
//

import RxSwift

final class LocalRepository: Repository {
	
	func getContent() -> Observable<ContentResponse>? {
		preconditionFailure()
	}
}
