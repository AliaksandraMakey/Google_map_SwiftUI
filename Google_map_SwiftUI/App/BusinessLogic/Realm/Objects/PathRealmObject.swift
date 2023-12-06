//
//  PathRealmObject.swift
//  Google_map_SwiftUI
//
//  Created by Александра Макей on 23.11.2023.
//

import RealmSwift
import CoreLocation

class PathRealmObject: Object {
    //MARK: - Properties
    @objc dynamic var name = ""
    @objc dynamic var created = NSDate()
    let path = List<LocationRealmObject>()
}
