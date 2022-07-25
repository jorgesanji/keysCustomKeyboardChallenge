//
//  keysCustomKeyboardChallengeTests.swift
//  keysCustomKeyboardChallengeTests
//
//  Created by Jorge Sanmartin on 20/07/22.
//

import XCTest
import RxSwift

@testable import keyboard

class keysCustomKeyboardChallengeTests: XCTestCase {
	
	var disposeBag: DisposeBag!
	var localRepository: LocalRepository!
	var restRepository: RestRepository!
	var getContentTest: GetContent!
	var mockGetContent: MockGetContent!
	var mockViewModel: MockViewModel!

	override func tearDown() {
		disposeBag = nil
		localRepository = nil
		restRepository = nil
		getContentTest = nil
		mockGetContent = nil
		mockViewModel = nil
		
		super.tearDown()
	}
	
	override func setUp() {
		super.setUp()
		
		continueAfterFailure = false
		
		self.disposeBag = DisposeBag()

		self.localRepository = LocalRepository()
		self.restRepository = RestRepository()
		
		let proxy = ProxyServiceImpl(restRepository: restRepository, localRepository: localRepository)
		
		self.getContentTest = .init(proxyService: proxy)
		
		self.mockGetContent = .init(proxyService: proxy)
		self.mockViewModel = .init(getContent: mockGetContent)
	}
	
	// Get content using rest repository.
	func testRestRepository() {
		
		let mainScheduler = MainScheduler.instance
		let subscriberScheduler = ConcurrentDispatchQueueScheduler(qos: .default)
				
		let expected = expectation(description: "getting content using rest repository")
		
		var responseCallback: ContentResponse? = nil
		var errorCallback :Error? = nil
				
		restRepository.getContent()?.subscribe(on: subscriberScheduler).observe(on: mainScheduler).bindNext({ response in
			
			responseCallback = response
			expected.fulfill()
			
		}, onError: { error in
			
			errorCallback = error
			expected.fulfill()
			
		}).disposed(by: disposeBag)
		
		wait(for: [expected], timeout: 40)
		
		XCTAssertTrue(responseCallback != nil)
		XCTAssertTrue(errorCallback == nil)
	}
	
	// Get content using use case.
	func testGetContentUseCase(){
		
		let expected = expectation(description: "getting content using useCase")
		
		var responseCallback: ContentResponse? = nil
		var errorCallback :Error? = nil

		getContentTest.build().subscribe { response in
			
			responseCallback = response
			expected.fulfill()
			
		} onError: { error in
			errorCallback = error
			expected.fulfill()
		}
		
		wait(for: [expected], timeout: 40)
		
		XCTAssertTrue(responseCallback != nil)
		XCTAssertTrue(errorCallback == nil)
	}
	
	func testLocalRepository(){
		
		let mainScheduler = MainScheduler.instance
		let subscriberScheduler = ConcurrentDispatchQueueScheduler(qos: .default)
		
		let expected = expectation(description: "getting content using local repository")

		let item1 = Item(id: "test1", displayText: "test1_dt", content: ["t1", "t2", "t3"])
		let item2 = Item(id: "test2", displayText: "test2_dt", content: ["c1", "c2", "c3"])
		let item3 = Item(id: "test3", displayText: "test3_dt", content: ["d1", "d2", "d3"])
		
		let content = ContentResponse(content: [item1, item2, item3])
		
		var responseCallback: ContentResponse? = nil
		var errorCallback :Error? = nil
		
		localRepository.saveContent(content)?.subscribe(on: subscriberScheduler).observe(on: mainScheduler).bindNext({ response in
			
			responseCallback = response
			expected.fulfill()
			
		}, onError: { error in
			
			errorCallback = error
			expected.fulfill()
			
		}).disposed(by: disposeBag)
		
		wait(for: [expected], timeout: 40)
		
		XCTAssertTrue(responseCallback != nil)
		XCTAssertTrue(responseCallback?.content.count == 3)
		XCTAssertTrue(errorCallback == nil)
	}

	func testViewModelStates(){
				
		do{
			mockViewModel.mockState = .syncing
			mockViewModel.fetchContent()
		
			XCTAssertTrue(mockViewModel.state == .syncing)
		}
		
		do{
			mockViewModel.mockState = .idle
			mockViewModel.fetchContent()
		
			XCTAssertTrue(mockViewModel.state == .idle)
		}
		
		do{
			mockViewModel.mockState = .success
			mockViewModel.fetchContent()
		
			XCTAssertTrue(mockViewModel.state == .success)
		}
		
		do{
			mockViewModel.mockState = .showItem
			mockViewModel.fetchContent()
		
			XCTAssertTrue(mockViewModel.state == .showItem)
		}
		
		do{
			mockViewModel.mockState = .error
			mockViewModel.fetchContent()
		
			XCTAssertTrue(mockViewModel.state == .error)
		}
	}
	
	func testViewModelRequestSuccess() {
		
		let expected = expectation(description: "checkig success result from use case")

		let proxy = ProxyServiceImpl(restRepository: restRepository, localRepository: localRepository)
		
		let mockGetContent: MockGetContent = .init(proxyService: proxy)
		let mockViewModel: MockViewModelRequest = .init(mockGetContent: mockGetContent)
		
		mockViewModel.expected = expected
		
		mockGetContent.response = ContentResponse(content: [])
		
		mockViewModel.fetchContent()
		
		wait(for: [expected], timeout: 10)
		
		XCTAssertTrue(mockViewModel.state == .success)
	}
	
	func testViewModelRequestError() {
		
		let expected = expectation(description: "checkig error result from use case")

		let proxy = ProxyServiceImpl(restRepository: restRepository, localRepository: localRepository)
		
		let mockGetContent: MockGetContent = .init(proxyService: proxy)
		let mockViewModel: MockViewModelRequest = .init(mockGetContent: mockGetContent)
		
		mockViewModel.expected = expected
		
		mockViewModel.fetchContent()
		
		wait(for: [expected], timeout: 20)
		
		XCTAssertTrue(mockViewModel.state == .error)
	}
	
	final class MockViewModelRequest: DefaultKeyboardViewModel {
		
		var expected: XCTestExpectation?
		
		private var mockGetContent: GetContentUseCase
		
		init(mockGetContent: MockGetContent) {
			self.mockGetContent = mockGetContent
			
			super.init(getContent: mockGetContent)
		}
		
		override func fetchContent() {
			mockGetContent.build().subscribe { response in
				self.state = .success
				
				self.expected?.fulfill()
			} onError: { error in
				
				self.state = .error
				
				self.expected?.fulfill()
			}
		}
	}
	
	final class MockViewModel: DefaultKeyboardViewModel {
		
		var mockState: State = .idle

		override func fetchContent() {
			state = mockState
		}
	}

	final class MockGetContent: BaseUseCase<ContentResponse>, GetContentUseCase {
		
		var response: ContentResponse?
		
		override func buildUseCaseObservable() -> Observable<ContentResponse>? {
			if let response = response {
				return Observable.just(response)
			}
			return Observable.error(NSError(domain: "", code: -1, userInfo: nil))
		}
	}
}
