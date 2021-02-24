//
//  Models.swift
//  IamQatar
//
//  Created by anuroop kanayil on 06/09/19.
//  Copyright © 2019 alisons. All rights reserved.
//

import Foundation


//MARK: - GIFT HOME
struct GiftHomeResponse: Codable {
    let code, text: String?
    let value: [GiftCategory]?
    let banner: [Banner]?
    let occasion: [Occasion]?
    let shop: [Store]?
    let featured: [Product]?
    let newitems: [Product]?
}

//MARK: - GIFT LIST
struct GiftListResponse: Codable {
    let code, text: String?
    let values: [Product]?
    let category: [GiftCategory]?
    let banner: [Banner]?
    let occasion: [Occasion]?
    let shop : [Store]?
    let time: [Time]?
    let filters : [GiftFilter]?
}


// MARK: - Product
struct Product: Codable {
    let productID: Int?
    let productName, sku, featuredDescription: String?
    let price, quantity: Int?
    let stockAvailability, imgDefault: String?
    let saleTagText : String?
    
    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case productName = "product_name"
        case sku
        case featuredDescription = "description"
        case price, quantity
        case stockAvailability = "stock_availability"
        case imgDefault = "default"
        case saleTagText = "sale_tag_text"
    }
}

// MARK: - Image
struct Image: Codable {
    let imagepath: String?
}
// MARK: - Time
struct Time: Codable {
    let timeID,status : Int
    let startTime, expiryTime : String?
    
    enum CodingKeys: String, CodingKey {
        case timeID = "time_id"
        case startTime = "start_time"
        case expiryTime = "expiry_time"
        case status
    }
}

// MARK: - Product
//struct Product: Codable {
//    let productID, productName, sku, description : String?
//    let price, quantity, stockAvailability: String?
//    let image: String?
//    let images: [Image]?
//    let imgDefault: String?
//
//    enum CodingKeys: String, CodingKey {
//        case productID = "product_id"
//        case productName = "product_name"
//        case sku
//        case description
//        case price, quantity
//        case stockAvailability = "stock_availability"
//        case image = "default"
//
//    }
//}
// MARK: - Banner
struct Banner: Codable {
    let banID, bannerpage: Int?
    let title, banner, bannerDescription, itemBanner: String?
    let mallID: Int?
    let pagelink, linkType: String?
    let productID: Int?
    let status: String?
    let itemCategoryID: Int?
    
    enum CodingKeys: String, CodingKey {
        case banID = "ban_id"
        case bannerpage, title, banner
        case bannerDescription = "description"
        case itemBanner = "item_banner"
        case mallID = "mall_id"
        case pagelink
        case linkType = "link_type"
        case productID = "product_id"
        case status
        case itemCategoryID = "item_category_id"
    }
}

// MARK: - Occasion
struct Occasion: Codable {
    let occaID: Int?
    let name, occaSlug, image: String?
    let status: Int?
    
    enum CodingKeys: String, CodingKey {
        case occaID = "occa_id"
        case name
        case occaSlug = "occa_slug"
        case image, status
    }
}

// MARK: - Shop
struct Store: Codable {
    let storeID: Int?
    let name, storeSlug, image: String?
    let status: Int?
    
    enum CodingKeys: String, CodingKey {
        case storeID = "store_id"
        case name
        case storeSlug = "store_slug"
        case image, status
    }
}

// MARK: - Gift category
struct GiftCategory: Codable {
    let catID: Int?
    let name, catSlug, valueDescription, image: String?
    let status: Int?
    
    enum CodingKeys: String, CodingKey {
        case catID = "cat_id"
        case name
        case catSlug = "cat_slug"
        case valueDescription = "description"
        case image, status
    }
}
// MARK: - Gift Filter
struct GiftFilter: Codable {
//    let first : GiftFilterFirst?
    let id : Int?
    let filter_name : String?
    let values : [GiftFilterValue]?
//    enum CodingKeys: String, CodingKey {
//        case id = "id"
//        case filter_name = "filter_name"
//        case values
//    }
}
// MARK: - Gift Filter Values
struct GiftFilterValue: Codable {
    let id : Int?
    let filter_id : Int?
    let name : String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case filter_id = "filter_id"
        case name = "name"
    }
    
}
// MARK: - Gift Filter First
struct GiftFilterFirst {
    let id : Int?
    let filter_name : String?
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case filter_name = "filter_name"
    }
}
