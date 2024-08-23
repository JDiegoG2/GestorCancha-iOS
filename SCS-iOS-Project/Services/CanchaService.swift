//
//  CanchaService.swift
//  SCS-iOS-Project
//
//  Created by Diego Gatica on 22/08/24.
//

import Foundation
import Alamofire

class CanchaService {
    static let shared = CanchaService()
    private let apiUrl = "\(Constants.baseUrl)cancha"
    
    private init() {}
    
    private func getHeaders() -> HTTPHeaders? {
        if let token = AuthService.shared.getToken() {
            return ["Authorization": "Bearer \(token)"]
        }
        return nil
    }
    
    // Método para actualizar el estado de una cancha
    func actualizarEstado(id: Int, estado: Bool, completion: @escaping (Result<Void, AFError>) -> Void) {
        let estadoValue = estado ? 1 : 0
        let parameters: [String: Any] = ["estado": estadoValue]
        NetworkManager.shared.session.request("\(apiUrl)/estado/\(id)", method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: getHeaders())
            .response { response in
                switch response.result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    // Método para guardar una cancha
    func guardarCancha(cancha: Cancha, completion: @escaping (Result<CanchaResponse, AFError>) -> Void) {
           let parameters: [String: Any] = [
               "tipo_cancha": cancha.tipoCancha.rawValue,
               "numero": cancha.numero,
               "precio": cancha.precio,
               "sede_id": cancha.sedeId,
               "dis_hr_inicio": cancha.disHrInicio,
               "dis_hr_fin": cancha.disHrFin,
               "estado": cancha.estado
           ]
           
           NetworkManager.shared.session.request("\(apiUrl)/guardar", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: getHeaders())
               .responseDecodable(of: CanchaResponse.self) { response in
                   NetworkManager.shared.handleResponse(response: response, completion: completion)
               }
       }
    
    // Método para consultar una cancha por ID
    func consultarCancha(id: Int, completion: @escaping (Result<CanchaResponse, AFError>) -> Void) {
        NetworkManager.shared.session.request("\(apiUrl)/\(id)", headers: getHeaders())
            .responseDecodable(of: CanchaResponse.self) { response in
                NetworkManager.shared.handleResponse(response: response, completion: completion)
            }
    }
    
    // Método para eliminar una cancha
    func eliminarCancha(id: Int, completion: @escaping (Result<Void, AFError>) -> Void) {
        NetworkManager.shared.session.request("\(apiUrl)/\(id)", method: .delete, headers: getHeaders())
            .response { response in
                switch response.result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    // Método para actualizar una cancha
    func actualizarCancha(id: Int, cancha: Cancha, completion: @escaping (Result<CanchaResponse, AFError>) -> Void) {
        guard let parameters = convertToParameters(cancha) else {
            let encodingError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error al codificar los parámetros."])
            completion(.failure(AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: encodingError))))
            return
        }
        
        NetworkManager.shared.session.request("\(apiUrl)/\(id)", method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: getHeaders())
            .responseDecodable(of: CanchaResponse.self) { response in
                NetworkManager.shared.handleResponse(response: response, completion: completion)
            }
    }
    
    // Método para listar todas las canchas
    func listarCanchas(completion: @escaping (Result<[CanchaResponse], AFError>) -> Void) {
        NetworkManager.shared.session.request("\(apiUrl)/listar", headers: getHeaders())
            .responseDecodable(of: [CanchaResponse].self) { response in
                NetworkManager.shared.handleResponse(response: response, completion: completion)
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
