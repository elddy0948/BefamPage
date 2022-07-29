//
//  CDProduct+CoreDataProperties.swift
//  Befam
//
//  Created by 김호준 on 2022/07/29.
//
//

import Foundation
import CoreData


extension CDProduct {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDProduct> {
        return NSFetchRequest<CDProduct>(entityName: "CDProduct")
    }

    @NSManaged public var trackName: String?
    @NSManaged public var sellerName: String?
    @NSManaged public var userRatingCount: Int16
    @NSManaged public var averageUserRating: Double
    @NSManaged public var trackContentRating: String?
    @NSManaged public var artworkUrl60: String?
    @NSManaged public var artworkUrl512: String?
    @NSManaged public var artworkUrl100: String?
    @NSManaged public var currentVersionReleaseDate: String?
    @NSManaged public var releaseNotes: String?
    @NSManaged public var fileSizeBytes: String?
    @NSManaged public var version: String?
    @NSManaged public var des: String?
    @NSManaged public var genres: [String]?
    @NSManaged public var screenshotUrls: [String]?
    @NSManaged public var languageCodesISO2A: [String]?

}

extension CDProduct : Identifiable {

}
