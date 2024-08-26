//
//  ReservaSede.swift
//  SCS-iOS-Project
//
//  Created by Diego Gatica on 26/08/24.
//

import Foundation
import Alamofire

class ReservaService {
    static let shared = ReservaService()
    private let apiUrl = "\(Constants.baseUrl)reserva"
    
    private init() {}
    
    private func getHeaders() -> HTTPHeaders? {
        if let token = AuthService.shared.getToken() {
            return ["Authorization": "Bearer \(token)"]
        }
        return nil
    }
    
    // Método para listar canchas por sede
    func listarCanchas(sedeId: Int, completion: @escaping (Result<[CanchaResponse], AFError>) -> Void) {
        NetworkManager.shared.session.request("\(apiUrl)/listar_canchas/\(sedeId)", headers: getHeaders())
            .responseDecodable(of: [CanchaResponse].self) { response in
                NetworkManager.shared.handleResponse(response: response, completion: completion)
            }
    }
    
    // Método para listar horarios por cancha y fecha
    func listarHorarios(canchaId: Int, fecha: String, completion: @escaping (Result<[Int], AFError>) -> Void) {
        NetworkManager.shared.session.request("\(apiUrl)/listar_horario/\(canchaId)/\(fecha)", headers: getHeaders())
            .responseDecodable(of: [Int].self) { response in
                NetworkManager.shared.handleResponse(response: response, completion: completion)
            }
    }
    
    // Método para crear una reserva
    func crearReserva(request: CrearReservaRequest, completion: @escaping (Result<ReservaResponse, AFError>) -> Void) {
        guard let parameters = convertToParameters(request) else {
            let encodingError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error al codificar los parámetros."])
            completion(.failure(AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: encodingError))))
            return
        }
        
        NetworkManager.shared.session.request(apiUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: getHeaders())
            .responseDecodable(of: ReservaResponse.self) { response in
                NetworkManager.shared.handleResponse(response: response, completion: completion)
            }
    }
    
    // Método para obtener una reserva por ID
    func obtenerReserva(reservaId: Int, completion: @escaping (Result<ReservaResponse, AFError>) -> Void) {
        NetworkManager.shared.session.request("\(apiUrl)/\(reservaId)", headers: getHeaders())
            .responseDecodable(of: ReservaResponse.self) { response in
                NetworkManager.shared.handleResponse(response: response, completion: completion)
            }
    }
    
    // Método para eliminar una reserva por ID
    func eliminarReserva(reservaId: Int, completion: @escaping (Result<Void, AFError>) -> Void) {
        NetworkManager.shared.session.request("\(apiUrl)/\(reservaId)", method: .delete, headers: getHeaders())
            .response { response in
                switch response.result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    private func convertToParameters<T: Encodable>(_ encodable: T) -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(encodable),
              let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            return nil
        }
        return json
    }
}
