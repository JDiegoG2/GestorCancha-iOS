//
//  CanchaRequest.swift
//  SCS-iOS-Project
//
//  Created by Diego Gatica on 25/08/24.
//

import Foundation

struct CrearCanchaRequest: Codable {
    var tipoCancha: TipoCancha
    var numero: String
    var precio: Double
    var sedeId: Int
    var disHrInicio: Int
    var disHrFin: Int
    var estado: Bool = true
    
    enum CodingKeys: String, CodingKey {
        case tipoCancha = "tipo_cancha"
        case numero
        case precio
        case sedeId = "sede_id"
        case disHrInicio = "dis_hr_inicio"
        case disHrFin = "dis_hr_fin"
        case estado
    }
}
