//
//  CanchaResponse.swift
//  SCS-iOS-Project
//
//  Created by Macbook on 20/08/24.
//

import Foundation

struct CanchaResponse {
    var id: Int64
    var TipoCanchaEnum: String
    var numero: String
    var precio: Double
    var sedeId: Int64
    var disHrInicio: Int
    var disHrFin: Int
    var estado: Bool
}


struct CrearCanchaRequest{
    
    var fechaReserva: String
    var horaReserva: Int
    var canchaId: Int64
    var observacion: String
    var importe: Double
    var clienteId: Int64
}
