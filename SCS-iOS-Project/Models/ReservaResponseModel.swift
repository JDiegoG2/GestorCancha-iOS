//
//  ReservaResponseModel.swift
//  SCS-iOS-Project
//
//  Created by Macbook on 20/08/24.
//

import Foundation

struct ReservaResponseModel{
    var id: Int64
    var fechaCreacion: String
    var fechaReserva: String
    var horaReserva: Int
    var cancha: String
    var observacion: String
    var importe: Double
    var estado: String
    var cliente: String
    var pdfUrl: String
}
