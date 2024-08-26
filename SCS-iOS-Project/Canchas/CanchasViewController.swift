//
//  CanchasViewController.swift
//  SCS-iOS-Project
//
//  Created by Diego Gatica on 21/08/24.
//

import UIKit

class CanchasViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var canchas: [CanchaResponse] = []
    var sedes: [Int: Sede] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchSedes() // Recargar la lista de sedes
        fetchCanchas()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func fetchSedes() {
        SedeService.shared.listarSedesActivas { [weak self] result in
            switch result {
            case .success(let sedes):
                for sede in sedes {
                    self?.sedes[sede.id] = sede  // Guardamos las sedes en el diccionario
                }
                self?.fetchCanchas()  // Una vez tenemos las sedes, obtenemos las canchas
            case .failure(let error):
                print("Error al listar las sedes: \(error)")
                self?.showAlert(message: "Ocurrió un error al obtener las sedes. Inténtalo nuevamente.")
            }
        }
    }
    
    func fetchCanchas() {
        CanchaService.shared.listarCanchas { [weak self] result in
            switch result {
            case .success(let canchaResponses):
                self?.canchas = canchaResponses.map { cancha in
                    var canchaModificada = cancha
                    // Verificar el estado de la sede asociada
                    if let sede = self?.sedes[cancha.sedeId] {
                        // Si la sede está inactiva, la cancha también debe estar "No Disponible"
                        canchaModificada.estado = sede.estado && cancha.estado
                    } else {
                        // Si no se encontró la sede, consideramos la cancha como no disponible
                        canchaModificada.estado = false
                    }
                    return canchaModificada
                }
                self?.tableView.reloadData()
            case .failure(let error):
                print("Error al listar las canchas: \(error)")
                self?.showAlert(message: "Ocurrió un error al obtener las canchas. Inténtalo nuevamente.")
            }
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // Navegar a la vista de edición
    func navigateToEditSedeViewController(sede: Sede) {
        let storyboard = UIStoryboard(name: "Sede", bundle: nil)
        if let formSedeViewController = storyboard.instantiateViewController(withIdentifier: "AddSedeViewController") as? FormularioSedeViewController {
            formSedeViewController.sede = sede
            self.navigationController?.pushViewController(formSedeViewController, animated: true)
        }
    }
    
}

extension CanchasViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return canchas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CanchasTableViewCell", for: indexPath) as? CanchasTableViewCell else {
            return UITableViewCell()
        }
        
        let cancha = canchas[indexPath.row]
        
        cell.tipoCanchaLabel.text = "\(cancha.tipoCancha.rawValue)"
        cell.numeroDeCanchaLabel.text = "\(cancha.numero)"
        cell.precioCanchaLabel.text = String(format: "%.2f", cancha.precio)
        cell.disponibilidadCanchaLabel.text = " \(cancha.disHrInicio):00 - \(cancha.disHrFin):00 horas"
        
        // Estado de la cancha
        cell.estadoLabel.text = cancha.estado ? "Disponible" : "No Disponible"
        
        if let sede = sedes[cancha.sedeId] {
            cell.sedeCanchaLabel.text = "Sede: \(sede.nombre)"
        } else {
            cell.sedeCanchaLabel.text = "No disponible"
        }
        
        return cell
    }
}
