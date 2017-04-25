//
//  RootUserResponse.swift
//  gitap
//
//  Created by Koichi Sato on 2017/04/23.
//  Copyright © 2017 Koichi Sato. All rights reserved.
//

//struct RootUserResponse<Item: JSONDecodable> : JSONDecodable {
//
//}

struct RootUserResponse<Item: JSONDecodable> : JSONDecodable {
    let totalCount: Int
    let items: [Item]
    
    init(json: Any) throws {
        guard let array = json as? [[String: Any]] else {
            throw JSONDecodeError.invalidResponse(object: json)
        }
        var tmpItems = [Item]()
        for item in array {
            do {
                tmpItems.append(try Item(json: item))
            } catch {
                print(error)
            }
        }
        self.totalCount = 10 // tmp
        self.items = tmpItems
    }
}
