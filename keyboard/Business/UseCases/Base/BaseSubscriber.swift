//
//  BaseSubscriber.swift
//  keyboard
//
//  Created by Jorge Sanmartin on 18/07/22.
//

import RxSwift

extension ObservableType{
	
	func bindNext(_ onNext:@escaping (Element)-> Void, onError:((Swift.Error) -> Void)? = nil)-> Disposable{
		
		return subscribe(onNext: onNext, onError: { (error) in
			onError!(error) }, onCompleted: {}, onDisposed: {}
		)
	}
}

