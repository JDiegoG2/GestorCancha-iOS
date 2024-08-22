//
//  SedeViewController.swift
//  SCS-iOS-Project
//
//  Created by Diego Gatica on 21/08/24.
//

import UIKit

class SedeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var sedes: [Sede] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchSedes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchSedes() // Recargar la lista de sedes
    }

    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func fetchSedes() {
        SedeService.shared.listarSedes { [weak self] result in
            switch result {
            case .success(let sedes):
                self?.sedes = sedes
                self?.tableView.reloadData()
            case .failure(let error):
                print("Error al listar las sedes: \(error)")
                self?.showAlert(message: "Ocurrió un error al obtener las sedes. Inténtalo nuevamente.")
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
    
    // Activar/Desactivar sede
    func toggleSedeState(sede: Sede) {
        let newState = !sede.estado
        SedeService.shared.actualizarEstado(id: sede.id, estado: newState) { [weak self] result in
            switch result {
            case .success(let updatedSede):
                print("Estado de la sede actualizado: \(updatedSede.estado ? "Activo" : "Inactivo")")
                self?.fetchSedes() // Actualiza la lista después de cambiar el estado
            case .failure(let error):
                print("Error al actualizar el estado de la sede: \(error)")
                self?.showAlert(message: "Ocurrió un error al actualizar el estado de la sede. Inténtalo nuevamente.")
            }
        }
    }
    
    // Eliminar sede
    func deleteSede(id: Int) {
        let alert = UIAlertController(title: "Confirmar Eliminación", message: "¿Estás seguro de que deseas eliminar esta sede?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Eliminar", style: .destructive, handler: { [weak self] _ in
            SedeService.shared.eliminarSede(id: id) { result in
                switch result {
                case .success:
                    print("Sede eliminada correctamente")
                    self?.fetchSedes() // Actualiza la lista después de eliminar
                case .failure(let error):
                    print("Error al eliminar la sede: \(error)")
                    self?.showAlert(message: "Ocurrió un error al eliminar la sede. Inténtalo nuevamente.")
                }
            }
        }))
        present(alert, animated: true, completion: nil)
    }
}

extension SedeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sedes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SedeTableViewCell", for: indexPath) as? SedeTableViewCell else {
            return UITableViewCell()
        }
        
        let sede = sedes[indexPath.row]
        cell.idSedesLabel.text = "ID: \(sede.id)"
        cell.SedeLabel.text = sede.nombre
        cell.direccionSedeLabel.text = sede.direccion
        cell.telefonoSedeLabel.text = sede.telefono
        cell.estadoLabel.text = sede.estado ? "Activo" : "Inactivo"
        
        return cell
    }
    
    // Configurar las acciones al deslizar la celda utilizando UIContextualAction
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let sede = sedes[indexPath.row]
        
        // Acción de Editar
        let editAction = UIContextualAction(style: .normal, title: "Editar") { [weak self] _, _, completionHandler in
            self?.navigateToEditSedeViewController(sede: sede)
            completionHandler(true)
        }
        editAction.backgroundColor = .blue
        
        // Acción de Activar/Desactivar
        let toggleStateAction = UIContextualAction(style: .normal, title: sede.estado ? "Desactivar" : "Activar") { [weak self] _, _, completionHandler in
            self?.toggleSedeState(sede: sede)
            completionHandler(true)
        }
        toggleStateAction.backgroundColor = .orange
        
        // Acción de Eliminar
        let deleteAction = UIContextualAction(style: .destructive, title: "Eliminar") { [weak self] _, _, completionHandler in
            self?.deleteSede(id: sede.id)
            completionHandler(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, toggleStateAction, editAction])
        return configuration
    }
}
