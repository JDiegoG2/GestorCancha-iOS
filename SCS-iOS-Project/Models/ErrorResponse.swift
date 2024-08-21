//
//  ErrorResponse.swift
//  SCS-iOS-Project
//
//  Created by Diego Gatica on 21/08/24.
//

import Foundation

struct ErrorResponse: Codable {
    let tipo: String
    let campo: String
    let mensaje: String
}
