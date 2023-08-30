//
//  UsecasesListTableViewController.swift
//  Scanbot Document Usecases
//
//  Created by Rana Sohaib on 24.08.23.
//

import UIKit

final class UsecasesListTableViewController: UITableViewController {
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            
            // Present Normal Document Scanner on this table view controller
            NormalDocumentScanning.present(presenter: self)
            
        } else if indexPath.row == 1 {
            
            // Present Single Page Scanner with Finder Overlay on this table view controller
            SinglePageFinderOverlayScanning.present(presenter: self)
            
        } else if indexPath.row == 2 {
            
            // Navigate to Detection on image view controller
            navigationController?.pushViewController(DetectionOnImageViewController.make(),
                                                     animated: true)
        }
    }
}
