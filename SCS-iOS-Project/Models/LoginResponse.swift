//
//  LoginResponse.swift
//  SCS-iOS-Project
//
//  Created by Diego Gatica on 21/08/24.
//

import Foundation

struct LoginResponse: Decodable {
    let token: String
    let userId: Int
    let perfil: String
}
