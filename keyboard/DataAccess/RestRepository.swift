//
//  RestRepository.swift
//  keyboard
//
//  Created by Jorge Sanmartin on 18/07/22.
//

import RxSwift
import Moya
import Alamofire

final class RestRepository: Repository {
	
	private final let provider:MoyaProvider<KeyboardService>
	
	init(){
		self.provider = MoyaProvider<KeyboardService>(
			session:  Alamofire.Session.default,
			plugins: [NetworkLoggerPlugin()])
	}
	
	func getContent() -> Observable<ContentResponse>? {
		return provider.rx
			.request(.getContent(()))
			.filterSuccessfulStatusCodes()
			.map(ContentResponse.self)
			.asObservable()
	}
}
