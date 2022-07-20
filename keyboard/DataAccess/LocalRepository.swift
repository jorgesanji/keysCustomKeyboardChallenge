//
//  LocalRepository.swift
//  keyboard
//
//  Created by Jorge Sanmartin on 18/07/22.
//

import RxSwift
import RealmSwift

final class LocalRepository: Repository {
	
	private lazy var realmDatabase: RealmSwift.Realm = Realm.database()
	
	func getContent() -> Observable<ContentResponse>? {
		let models: [Item] = realmDatabase.objects(ItemEntity.self).map {
			Item(id: $0.id, displayText: $0.displayText, content: Array($0.content))
		}
		return Observable.just(ContentResponse(content: models))
	}
	
	func saveContent(_ content: ContentResponse) -> Observable<ContentResponse>? {
		
		let entities: [ItemEntity] = content.content.map { item -> ItemEntity in
			
			if let entity = realmDatabase.object(ofType: ItemEntity.self, forPrimaryKey: item.id){
				return entity
			} else {
				let entity = ItemEntity()
				entity.id = item.id
				entity.displayText = item.displayText
				entity.content.append(objectsIn: item.content)
				
				return entity
			}
		}
		
		try! realmDatabase.write {
			realmDatabase.add(entities, update: .modified)
		}
		
		return Observable.just(content)
	}
}
