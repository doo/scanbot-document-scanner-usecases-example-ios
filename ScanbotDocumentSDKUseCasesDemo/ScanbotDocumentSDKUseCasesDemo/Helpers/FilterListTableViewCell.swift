//
//  FilterListTableViewCell.swift
//  ScanbotDocumentSDKUseCasesDemo
//
//  Created by Rana Sohaib on 24.08.23.
//

import ScanbotSDK

final class FilterListTableViewCell: UITableViewCell {

    @IBOutlet private var filterName: UILabel!
    @IBOutlet private var isFilterSelected: UIButton!
    
    func setup(filter: SBSDKImageFilterType, selected: Bool) {
        filterName.text = filter.name
        isFilterSelected.isHidden = !selected
    }
}
