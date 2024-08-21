//
//  Register.swift
//  SCS-iOS-Project
//
//  Created by Diego Gatica on 21/08/24.
//

import Foundation

struct Register: Codable {
    let password: String
    let nroDocumento: String
    let nombres: String
    let apellidos: String
    let telefono: String
    let email: String
}
