//
//  ItemEntity.swift
//  keysCustomKeyboardChallenge
//
//  Created by Jorge Sanmartin on 20/07/22.
//

import RealmSwift

class ItemEntity: Object {
	@Persisted(primaryKey: true) var id: String
	@Persisted var displayText: String
	@Persisted var content = List<String>()
}
