//
//  KeyboardService.swift
//  keyboard
//
//  Created by Jorge Sanmartin on 18/07/22.
//

import Foundation
import Moya

enum KeyboardService {
	case getContent(Void)
}

extension KeyboardService: TargetType {
	
	var baseURL: URL {		
		guard
			let url = URL(string: "https://frontend-coding-challenge-api.herokuapp.com")
		else {
			fatalError("baseURL could not be configured")
		}
		return url
	}
	
	var path: String {
		switch self {
		case .getContent:
			return "/getContent"
		}
	}
	
	var method: Moya.Method {
		switch self {
		case .getContent:
			return .get
		}
	}
	
	var task: Task {
		switch self {
		case .getContent:
			return .requestPlain
		}
	}
	
	var headers: [String : String]? {
		[:]
	}
}
