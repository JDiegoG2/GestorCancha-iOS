//
//  SesionManager.swift
//  SCS-iOS-Project
//
//  Created by Diego Gatica on 21/08/24.
//

import Foundation
import UIKit

class SessionManager {
    static let shared = SessionManager()
    private var inactivityTimer: Timer?
    
    private init() {}
    
    func startInactivityTimer() {
        resetInactivityTimer()
    }
    
    func resetInactivityTimer() {
        inactivityTimer?.invalidate()
        inactivityTimer = Timer.scheduledTimer(timeInterval: 300, target: self, selector: #selector(logoutUser), userInfo: nil, repeats: false)
    }
    
    @objc private func logoutUser() {
        AuthService.shared.logout()
        
        // Obtén la ventana principal para la escena activa
        if let topViewController = getTopViewController() {
            showAlert(on: topViewController)
        }
        
        print("Sesión cerrada por inactividad.")
    }
    
    private func showAlert(on viewController: UIViewController) {
        let alert = UIAlertController(title: "Sesión Expirada", message: "Tu sesión ha expirado debido a la inactividad. Por favor, inicia sesión de nuevo.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                loginViewController.modalPresentationStyle = .fullScreen
                viewController.present(loginViewController, animated: true, completion: nil)
            }
        })
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    // Método para obtener el controlador de vista superior
    private func getTopViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return nil
        }
        
        guard let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
            return nil
        }
        
        return getTopViewController(from: rootViewController)
    }
    
    // Recursivo para encontrar el controlador de vista más alto
    private func getTopViewController(from viewController: UIViewController) -> UIViewController? {
        if let presentedViewController = viewController.presentedViewController {
            return getTopViewController(from: presentedViewController)
        }
        
        if let navigationController = viewController as? UINavigationController {
            return getTopViewController(from: navigationController.visibleViewController ?? viewController)
        }
        
        if let tabBarController = viewController as? UITabBarController {
            return getTopViewController(from: tabBarController.selectedViewController ?? viewController)
        }
        
        return viewController
    }
}
