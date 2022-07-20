//
//  Item.swift
//  keyboard
//
//  Created by Jorge Sanmartin on 18/07/22.
//

import Foundation

struct Item: Decodable {
	let id: String
	let displayText: String
	let content: [String]
}
