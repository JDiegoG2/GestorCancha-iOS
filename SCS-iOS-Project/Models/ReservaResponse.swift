//
//  ReservaResponse.swift
//  SCS-iOS-Project
//
//  Created by Diego Gatica on 26/08/24.
//

import Foundation

struct ReservaResponse: Codable {
    let id: Int
    let fechaCreacion: String
    let fechaReserva: String
    let horaReserva: Int
    let cancha: String
    let observacion: String
    let importe: Double
    let estado: String
    let cliente: String
    let pdfUrl: String?

    enum CodingKeys: String, CodingKey {
        case id
        case fechaCreacion = "fecha_creacion"
        case fechaReserva = "fecha_reserva"
        case horaReserva = "hora_reserva"
        case cancha
        case observacion
        case importe
        case estado
        case cliente
        case pdfUrl = "pdf_url"
    }
}

