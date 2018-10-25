//
//  RMBIOS.swift
//  Provenance
//
//  Created by Joseph Mattiello on 3/11/18.
//  Copyright © 2018 James Addyman. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers
public final class RMBIOS: Object, BIOSFileProvider {
    dynamic public var system: PVSystem!

	dynamic public var descriptionText: String = ""
	dynamic public var regions: RegionOptions = .unknown
	dynamic public var version: String = ""
    dynamic public var optional: Bool = false

    dynamic public var expectedMD5: String = ""
    dynamic public var expectedSize: Int = 0
    dynamic public var expectedFilename: String = ""

    dynamic public var file: RMLocalFile?

    public convenience init(withSystem system: PVSystem, descriptionText: String, optional: Bool = false, expectedMD5: String, expectedSize: Int, expectedFilename: String) {
        self.init()
        self.system = system
        self.descriptionText = descriptionText
        self.optional = optional
        self.expectedMD5 = expectedMD5.uppercased()
        self.expectedSize = expectedSize
        self.expectedFilename = expectedFilename
    }

    override public static func primaryKey() -> String? {
        return "expectedFilename"
    }
}

public extension RMBIOS {
	var expectedPath: URL {
		return system.biosDirectory.appendingPathComponent(expectedFilename, isDirectory: false)
	}
}

extension RMBIOS {
	public var status : BIOSStatus {
		return BIOSStatus(withBios: self)
	}
}

// MARK: - Conversions
fileprivate extension BIOS {
	init(with bios : RMBIOS) {
		descriptionText = bios.descriptionText
		optional = bios.optional
		expectedMD5 = bios.expectedMD5
		expectedSize = bios.expectedSize
		expectedFilename = bios.expectedFilename
		status = bios.status
		file = bios.file?.asDomain()
		regions = bios.regions
		version = bios.version
	}
}

extension RMBIOS: DomainConvertibleType {
	public typealias DomainType = BIOS

	func asDomain() -> BIOS {
		return BIOS(with: self)
	}
}

extension BIOS: RealmRepresentable {
	var uid: String {
		return expectedFilename
	}

	func asRealm() -> RMBIOS {
		return RMBIOS.build({ object in
			object.descriptionText = descriptionText
			object.optional = optional
			object.expectedMD5 = expectedMD5
			object.expectedSize = expectedSize
			object.expectedFilename = expectedFilename
		})
	}
}

