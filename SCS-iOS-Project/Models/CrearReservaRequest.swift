//
//  CrearReservaRequest.swift
//  SCS-iOS-Project
//
//  Created by Macbook on 20/08/24.
//

import Foundation

struct CrearReservaRequest{
    
    var fechaReserva: String
    var horaReserva: Int
    var canchaId: Int64
    var observacion: String
    var importe: Double
    var clienteId: Int64
}
