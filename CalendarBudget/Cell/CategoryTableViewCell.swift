//
//  CategoryTableViewCell.swift
//  CalendarBudget
//
//  Created by ERAY on 2021/1/26.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    public static var identifier: String = "CategoryTableViewCell"
    private var rowNum: Int = 0
    private var slotView: UIView = {
        let view = UIView()
        return view
    }()
    private var categoryLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func config(row: Int) {
        self.slotView.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        self.categoryLabel.text = budgetTitles[row]
        self.slotView.addSubview(self.categoryLabel)
        self.categoryLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.height.equalTo(44)
        }
    }
    
}

//MARK:- private
extension CategoryTableViewCell {
    private func setupUI() {
        self.backgroundColor = .groupTableViewBackground
        self.contentView.addSubview(self.slotView)
        
        self.slotView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(8)
        }
    }
}
