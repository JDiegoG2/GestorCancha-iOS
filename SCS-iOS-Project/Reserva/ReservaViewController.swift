//
//  ReservaViewController.swift
//  SCS-iOS-Project
//
//  Created by Diego Gatica on 21/08/24.
//

import UIKit

class ReservaViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var reserva: [ReservaResponse] = []
    var sedes: [Int: Sede] = [:]
    var cancha: [Int: CanchaResponse] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func navigateToEditSedeViewController(reserva: ReservaResponse) {
        let storyboard = UIStoryboard(name: "Sede", bundle: nil)
        if let formRegisterViewController = storyboard.instantiateViewController(withIdentifier: "FormularioRegisterViewController") as? FormularioReservaViewController {
            formRegisterViewController.reserva = reserva
            self.navigationController?.pushViewController(formRegisterViewController, animated: true)
        }
    }
    
}

extension ReservaViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reserva.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
