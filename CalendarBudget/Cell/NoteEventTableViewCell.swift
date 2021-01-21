//
//  NoteEventTableViewCell.swift
//  CalendarBudget
//
//  Created by ERAY on 2021/1/14.
//

import UIKit

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
        //                print(indexPath.row)
        //                cell.backgroundColor = .groupTableViewBackground
        //                cell.textLabel?.textColor = .black
        //                eventTimeLabel.text = noteContent[indexPath.row].timeString
        //                eventTimeLabel.textColor = .black
        //                eventTimeLabel.backgroundColor = .groupTableViewBackground
    }
}

//MARK: private
extension NoteEventTableViewCell {
    
    private func setupUI() {
        self.titleLabel.textColor = .darkText
        self.timeLabel.textColor = .darkGray
    }
}

class TestCell: UITableViewCell {
    
    public static let identifier: String = "TestCell"
    
    let testLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .systemGreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(model: String) {
        self.testLabel.text = model
        self.contentView.backgroundColor = .systemGreen
    }
    
}
