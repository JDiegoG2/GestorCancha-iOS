//
//  CrearReservaRequest.swift
//  SCS-iOS-Project
//
//  Created by Diego Gatica on 26/08/24.
//

import Foundation

struct CrearReservaRequest: Codable {
    let fechaReserva: String
    let horaReserva: Int
    let canchaId: Int
    let observacion: String
    let importe: Double
    let clienteId: Int

    enum CodingKeys: String, CodingKey {
        case fechaReserva = "fecha_reserva"
        case horaReserva = "hora_reserva"
        case canchaId = "cancha_id"
        case observacion
        case importe
        case clienteId = "cliente_id"
    }
}
