//
//  Sede.swift
//  SCS-iOS-Project
//
//  Created by Diego Gatica on 21/08/24.
//

import Foundation

struct Sede: Codable {
    var id: Int
    var nombre: String
    var direccion: String
    var telefono: String
    var estado: Bool
    var departamento: String?
    var provincia: String?
    var distrito: String?
    var ubigeo: Ubigeo
}
