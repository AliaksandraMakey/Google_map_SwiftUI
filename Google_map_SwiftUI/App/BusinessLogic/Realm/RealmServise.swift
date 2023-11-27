//
//  RealmServise.swift
//  Google_map_SwiftUI
//
//  Created by Александра Макей on 23.11.2023.
//

import Foundation
import RealmSwift
import CoreLocation


final public class RealmDataBase: DataBaseLocationProtocol {
    let defaultPathName: String = "default"

    private var realm: Realm {
        do {
            let realm = try Realm()
            return realm
        } catch let error as NSError {
            fatalError("Failed to access Realm database: \(error.localizedDescription)")
        }
    }

    private func write(writeClosure: () throws -> Void) throws {
        do {
            try realm.write {
                try writeClosure()
            }
        } catch {
            throw RealmError.writeError(error: error as NSError)
        }
    }

    func deletePath(name: String) throws {
        do {
            let objects = realm.objects(LocationRealmObject.self)
            try realm.write {
                realm.delete(objects)
            }
        } catch {
            throw RealmError.writeError(error: error as NSError)
        }
    }

    func savePath(name: String, path: [CLLocationCoordinate2D]) throws {
        for location in path {
            try self.addPoint(path: name, coordinate: location)
        }
    }

    func loadPath(name: String) throws -> [CLLocationCoordinate2D] {
        let locationPath = realm.objects(LocationRealmObject.self)
        var arr: [CLLocationCoordinate2D] = []
        for loc in locationPath {
            arr.append(loc.coordinate)
        }
        return arr
    }

    func addPoint(path name: String, coordinate: CLLocationCoordinate2D) throws {
        let realmLocation = LocationRealmObject(coordinate: coordinate)
        do {
            try write {
                realm.add(realmLocation)
            }
        } catch {
            throw RealmError.writeError(error: error as NSError)
        }
    }
}
