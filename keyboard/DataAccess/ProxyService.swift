//
//  ProxyService.swift
//  keyboard
//
//  Created by Jorge Sanmartin on 18/07/22.
//

protocol ProxyService: AnyObject {
	var repository: Repository { get }
	var localRepository: Repository { get }
}

final class ProxyServiceImpl: ProxyService{
	
	private final let restRepository: Repository
	public private(set) var localRepository: Repository
	private final let reachability: Reachability
	
	var repository: Repository {
		reachability.connection != .unavailable ? restRepository : localRepository
	}

	init(restRepository: Repository, localRepository: Repository) {
		self.restRepository = restRepository
		self.localRepository = localRepository
		self.reachability = try! Reachability()
		
		startReachability()
	}
	
	deinit {
		reachability.stopNotifier()
	}
	
	private func startReachability(){
		do {
			try reachability.startNotifier()
		} catch {
			print("Unable to start notifier")
		}
	}
}
