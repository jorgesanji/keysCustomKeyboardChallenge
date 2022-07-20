//
//  Repository.swift
//  keyboard
//
//  Created by Jorge Sanmartin on 18/07/22.
//

import RxSwift

protocol Repository : AnyObject{
		
	func getContent() -> Observable<ContentResponse>?
}
