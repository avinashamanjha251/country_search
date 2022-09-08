//
//  CountryListTableCell.swift
//  CountrySearch
//
//  Created by Avinash Aman on 08/09/22.
//

import UIKit
import SnapKit

class CountryListTableCell: UITableViewCell {
    
    static let cellId: String = "CountryListTableCell"
    
    let lblTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let lblSubTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func setSelected(_ selected: Bool,
                              animated: Bool) {
        super.setSelected(selected,
                          animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)
        setupUIs()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupUIs() {
        lblTitle.text = "Hello"
        lblSubTitle.text = "Hello"
        self.backgroundColor = .lightGray
        self.addSubview(lblTitle)
        self.addSubview(lblSubTitle)
        lblTitle.snp.makeConstraints { (make) -> Void in
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).offset(10)
            make.top.equalTo(10)
            make.bottom.equalTo(lblSubTitle.snp.top)
        }
        lblSubTitle.snp.makeConstraints { (make) -> Void in
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).offset(10)
            make.bottom.equalTo(-10)
        }
    }
    
}
