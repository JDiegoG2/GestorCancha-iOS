//
//  Cancha.swift
//  SCS-iOS-Project
//
//  Created by Diego Gatica on 22/08/24.
//

import Foundation

struct CanchaResponse: Codable {
    var estado: Bool
    var id: Int
    var tipoCancha: TipoCancha // Usamos el enum aquí
    var numero: String
    var precio: Double
    var sedeId: Int
    var disHrInicio: Int
    var disHrFin: Int

    enum CodingKeys: String, CodingKey {
        case estado
        case id
        case tipoCancha = "tipo_cancha" // Se codifica/decodifica como String
        case numero
        case precio
        case sedeId = "sede_id"
        case disHrInicio = "dis_hr_inicio"
        case disHrFin = "dis_hr_fin"
    }
}

