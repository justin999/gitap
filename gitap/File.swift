//
//  File.swift
//  gitap
//
//  Created by Koichi Sato on 1/5/17.
//  Copyright © 2017 Koichi Sato. All rights reserved.
//


import Foundation
// TODO: use struct instead of class
class File: NSObject, NSCoding{
    var filename: String?
    var raw_url: String?
    var content: String?
    
    required init?(json: [String: Any]) {
        self.filename = json["filename"] as? String
        self.raw_url = json["raw_url"] as? String
    }
    
    init?(aName: String?, aContent: String?) {
        self.filename = aName
        self.content = aContent
    }
    
    // MARK: NSCoding
    @objc func encode(with aCoder: NSCoder) {
        aCoder.encode(self.filename, forKey: "filename")
        aCoder.encode(self.raw_url, forKey: "raw_url")
        aCoder.encode(self.content, forKey: "content")
    }
    
    @objc required convenience init?(coder aDecoder: NSCoder) {
        let filename = aDecoder.decodeObject(forKey: "filename") as? String
        let content = aDecoder.decodeObject(forKey: "content") as? String
        // use the existing init function
        self.init(aName: filename, aContent: content)
        self.raw_url = aDecoder.decodeObject(forKey: "raw_url") as? String
    }
}
