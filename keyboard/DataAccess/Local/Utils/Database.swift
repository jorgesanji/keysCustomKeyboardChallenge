//
//  Database.swift
//  keysCustomKeyboardChallenge
//
//  Created by Jorge Sanmartin on 20/07/22.
//

import RealmSwift

extension Realm {
	
	/// The current version of the database schema.
	///
	/// We used to increment this by 1 every time changes in Realm entities were made. We don't support migrations
	/// and simply can wipe the DB if the schema does not match, which is fine in our case where Realm is used
	/// only to cache easily restorable data.
	///
	/// The increment part is error-prone though: it's too easy to forget to change it or let it be incremented both
	/// on a "hotfix" causing 2 releases having the same schema.
	///
	/// To avoid the issue we are using the app's build number just in case, which is guaranteed to be unique
	/// for every public build. (It's shifted, so you can still can increment the whole version during development,
	/// if needed, without changing the build number.)
	private static var schemaVersion: UInt64 = Bundle.main.buildNumber! * 1000 + 17

	// Realm properties
	private static var objectTypes = [
		ItemEntity.self,
	]
	
	// MARK: - Helpers
	
	private static let fileName: String = "KeysProducts"
	private static let fileExtension: String = "realm"
	
	// File url on the phone documents directory
	private static func documentsDirectoryUrl(withSuffix suffix: String = "") -> URL {
		
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		let documentsDirectory = paths[0]

		return documentsDirectory.appendingPathComponent("\(fileName).\(fileExtension)\(suffix)")
	}
	
	// Check if the database fire is already in phone documents directory
	private static var foundDatabaseInDocumentsDirectory: Bool {
		return FileManager.default.fileExists(atPath: documentsDirectoryUrl().relativePath)
	}
	
	private static var schemaVersionInUse: UInt64? {
		try? schemaVersionAtURL(documentsDirectoryUrl())
	}
	
	// MARK: - Actions
	
	public static func database() -> RealmSwift.Realm {
		
		wipeDatabaseIfNeeded()

		if let size = try? FileManager.default.attributesOfItem(atPath: documentsDirectoryUrl().path)[FileAttributeKey.size] as? Int64 {
			NSLog("size = %d", size)
		}

		let config = RealmSwift.Realm.Configuration(
			fileURL: documentsDirectoryUrl(),
			schemaVersion: schemaVersion,
			migrationBlock: { (migration, oldSchemaVersion) in
				assertionFailure(
					"""
					Trying to migrate from version \(oldSchemaVersion) while it's assumed that versions older \
					than \(schemaVersion) are simply deleted
					"""
				)
			},
			objectTypes: objectTypes
		)
		
		do {
			return try RealmSwift.Realm(configuration: config)
		} catch {
			preconditionFailure(error.localizedDescription)
		}
	}
	
	private static func wipeDatabaseIfNeeded() {

		guard let schemaVersionInUse = self.schemaVersionInUse else {
			NSLog("No previous database yet or it cannot be opened", "")
			return
		}

		guard (schemaVersionInUse != schemaVersion) && self.foundDatabaseInDocumentsDirectory else {
			NSLog("Using the existing database", "")
			return
		}
				
		NSLog("Wiping the database due to schema mismatch (found %d, expected: %d,", [schemaVersionInUse, schemaVersion])
		
		try? FileManager.default.removeItem(at: documentsDirectoryUrl())
		try? FileManager.default.removeItem(at: documentsDirectoryUrl(withSuffix: ".lock"))
		try? FileManager.default.removeItem(at: documentsDirectoryUrl(withSuffix: ".management"))
		
		NSLog("Done", "")
	}
}

extension Bundle {
	
	public var shortVersionString: String {
		guard let currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else {
			assertionFailure()
			return ""
		}
		return currentVersion
	}

	public var buildNumber: UInt64? {
		(Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String).flatMap(UInt64.init)
	}
}
