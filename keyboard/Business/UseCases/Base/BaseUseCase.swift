//
//  BaseUseCase.swift
//  keyboard
//
//  Created by Jorge Sanmartin on 18/07/22.
//

import RxSwift

class BaseUseCase<K> {

	private final let subscriberScheduler: SchedulerType
	private final let observableScheduler: SerialDispatchQueueScheduler
	private var disposable: Disposable!
	var proxyService: ProxyService?
	
	init(proxyService: ProxyService) {
		self.proxyService = proxyService
		self.subscriberScheduler = ConcurrentDispatchQueueScheduler(qos: .default)
		self.observableScheduler = MainScheduler.instance
	}
	
	func subscribe(_ onNext:@escaping (K)-> Void, onError:((Swift.Error) -> Void)? = nil) {
		self.disposable = buildUseCaseObservable()?
			.subscribe(on: subscriberScheduler)
			.observe(on: observableScheduler)
			.bindNext(onNext, onError: onError)
	}
	
	func buildUseCaseObservable() -> Observable<K>? {
		preconditionFailure("please override this method and build your observable")
	}
	
	func unsubscribe() {
		if disposable != nil {
			disposable.dispose()
		}
		disposable = nil
	}
	
	func isUnsubscribe() -> Bool {
		disposable != nil
	}
	
	func build() -> BaseUseCase<K> {
		return self
	}
}
