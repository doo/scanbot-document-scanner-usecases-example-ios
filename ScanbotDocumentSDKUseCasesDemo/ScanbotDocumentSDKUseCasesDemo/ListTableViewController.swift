//
//  ListTableViewController.swift
//  Scanbot Document Usecases
//
//  Created by Rana Sohaib on 24.08.23.
//

import UIKit

final class ListTableViewController: UITableViewController {
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            SinglePageScanning.present(on: self)
            
        } else if indexPath.row == 1 {
            MultiPageScanning.present(on: self)
            
        } else if indexPath.row == 2 {
            
            
        }
    }
}
