//
//  Repository.swift
//  keyboard
//
//  Created by Jorge Sanmartin on 18/07/22.
//

import RxSwift

protocol Repository : AnyObject{
		
	func saveContent(_ content: ContentResponse) -> Observable<ContentResponse>?
	
	func getContent() -> Observable<ContentResponse>?
}

extension Repository {
	
	func getContent() -> Observable<ContentResponse>? {
		preconditionFailure()
	}
	
	func saveContent(_ content: ContentResponse) -> Observable<ContentResponse>? {
		preconditionFailure()
	}
}
