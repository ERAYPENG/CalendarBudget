//
//  NoteEventTableViewCell.swift
//  CalendarBudget
//
//  Created by ERAY on 2021/1/14.
//

import UIKit
import SnapKit

class NoteEventTableViewCell: UITableViewCell {
    
    public static let identifier: String = "NoteEventTableViewCell"
    
    private lazy var titleLabel: UILabel = UILabel()
    
    private lazy var timeLabel: UILabel = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func config(model: AddNoteEventContent) {
        self.titleLabel.text = model.description
        self.timeLabel.text = model.timeString
        titleLabel.textColor = .black
        titleLabel.textColor = .black
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(timeLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        timeLabel.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
    }
}

//MARK: private
extension NoteEventTableViewCell {
    
    private func setupUI() {
        self.titleLabel.textColor = .darkText
        self.timeLabel.textColor = .darkGray
        let separateLine = UIView()
        separateLine.backgroundColor = .hex("454545")
        self.contentView.addSubview(separateLine)
        
        separateLine.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
    }
}



