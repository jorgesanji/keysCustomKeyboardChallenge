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
	var getContent: GetContent!

	override func tearDown() {
		disposeBag = nil
		localRepository = nil
		restRepository = nil
		getContent = nil
		
		super.tearDown()
	}
	
	override func setUp() {
		super.setUp()
		
		self.disposeBag = DisposeBag()

		self.localRepository = LocalRepository()
		self.restRepository = RestRepository()
		
		let proxy = ProxyServiceImpl(restRepository: restRepository, localRepository: localRepository)
		
		self.getContent = GetContent(proxyService: proxy)
	}
	
	// Get content using rest repository.
	func testRestRepository() {
		
		let mainScheduler = MainScheduler.instance
				
		let expected = expectation(description: "getting content using rest repository")
		
		var responseCallback: ContentResponse? = nil
		var errorCallback :Error? = nil
				
		restRepository.getContent()?.subscribe(on: mainScheduler).observe(on: mainScheduler).bindNext({ response in
			
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

		getContent.build().subscribe { response in
			
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
		
		let expected = expectation(description: "getting content using local repository")

		let item1 = Item(id: "test1", displayText: "test1_dt", content: ["t1", "t2", "t3"])
		let item2 = Item(id: "test2", displayText: "test2_dt", content: ["c1", "c2", "c3"])
		let item3 = Item(id: "test3", displayText: "test3_dt", content: ["d1", "d2", "d3"])
		
		let content = ContentResponse(content: [item1, item2, item3])
		
		var responseCallback: ContentResponse? = nil
		var errorCallback :Error? = nil
		
		localRepository.saveContent(content)?.subscribe(on: mainScheduler).observe(on: mainScheduler).bindNext({ response in
			
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

	
}
