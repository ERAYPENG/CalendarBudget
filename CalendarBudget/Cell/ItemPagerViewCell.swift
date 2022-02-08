//
//  ItemPagerViewCell.swift
//  CalendarBudget
//
//  Created by ERAY on 2021/3/7.
//

import FSPagerView

class ItemPagerViewCell: FSPagerViewCell {

    let textBackView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textBackView.backgroundColor = .hex("ede6ad")
        textBackView.alpha = 0.6
        self.contentView.addSubview(textBackView)
        
        self.imageView?.backgroundColor = .clear
        self.imageView?.contentMode = .scaleAspectFit
        self.imageView?.clipsToBounds = true
        
        self.textLabel?.font = UIFont(name: "Menlo-Bold", size: 16)
        self.textLabel?.textColor = .hex("454545")
        self.textLabel?.backgroundColor = .clear
        self.textLabel?.superview?.backgroundColor = .clear
        
        //9f3849 紅
        //e1e5e8 白
        //667e95 灰藍
        //fd7f59 橘
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func config(imageName: String, title: String) {
        self.imageView?.image = UIImage(named: imageName)
//        cell.textLabel?.textColor = .black
        
        self.textLabel?.text = title
        self.imageView?.snp.makeConstraints({ (make) in
            make.center.equalToSuperview()
            make.height.width.equalTo(50)
        })
        self.textLabel?.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
        })
        
        if let textLabel = self.textLabel {
            textBackView.snp.makeConstraints { (make) in
                make.leading.trailing.equalTo(textLabel).inset(-10)
                make.top.equalTo(textLabel.snp.centerY)
                make.bottom.equalTo(textLabel.snp.bottom)
            }
        }
        self.sendSubviewToBack(textBackView)
    }
}
