//
//  SedeRequestModel.swift
//  SCS-iOS-Project
//
//  Created by Macbook on 20/08/24.
//

import Foundation

struct SedeRequestModel {
    var id: Int64
    var nombre: String
    var direccion: String
    var estado: Bool
    var departamento: String?
    var provincia: String?
    var distrito: String
    var ubigeo: Int
}
