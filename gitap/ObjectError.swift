//
//  ObjectError.swift
//  gitap
//
//  Created by Koichi Sato on 2017/05/07.
//  Copyright © 2017 Koichi Sato. All rights reserved.
//

enum ObjectError: Error {
    case initializationError(object: Any)
}
