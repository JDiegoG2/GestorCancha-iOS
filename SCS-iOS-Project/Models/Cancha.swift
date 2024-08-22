//
//  Cancha.swift
//  SCS-iOS-Project
//
//  Created by Diego Gatica on 22/08/24.
//

import Foundation

struct Cancha: Codable {
    var estado: Bool
    var id: Int
    var tipoCancha: TipoCancha
    var numero: String
    var precio: Double
    var sedeId: Int
    var disHrInicio: Int
    var disHrFin: Int
}
