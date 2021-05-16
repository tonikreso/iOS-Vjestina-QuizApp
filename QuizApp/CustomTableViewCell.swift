//
//  CustomTableViewCell.swift
//  QuizApp
//
//  Created by Kompjuter on 01/05/2021.
//

import UIKit
import PureLayout

class CustomTableViewCell: UITableViewCell {
    private var gradientColor1 = UIColor(red: 58/255, green: 55/255, blue: 129/255, alpha: 1)
    
    private var quizImage : UIImageView!
    private var quizDescription: UILabel!
    private var headline: UILabel!
    private var grade: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        buildViews()
        styleViews()
        defineLayoutForViews()
        
        contentView.backgroundColor = UIColor(red: 137/255, green: 123/255, blue: 178/255, alpha: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildViews() {
        quizImage = UIImageView()
        contentView.addSubview(quizImage)
        
        quizDescription = UILabel()
        contentView.addSubview(quizDescription)
        
        headline = UILabel()
        contentView.addSubview(headline)
        
        grade = UILabel()
        contentView.addSubview(grade)
    }
    
    func setMyValues(imageUrl: String, title: String, descriptionText: String, level: String) {
        let tmpImage = UIImage(named: "football-strategy")
        quizImage.image = tmpImage
        quizImage.contentMode = .scaleAspectFill
        quizImage.clipsToBounds = true
        quizDescription.text = descriptionText
        headline.text = title
        grade.text = level
    }
    
    private func styleViews() {
        quizImage.layer.cornerRadius = 8
        
        headline.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        headline.textColor = .white
        
        quizDescription.font = UIFont.systemFont(ofSize: 13)
        quizDescription.textColor = .white
        
        grade.font = UIFont.systemFont(ofSize: 15)
        grade.textColor = .white
    }
    
    private func defineLayoutForViews() {
        quizImage.autoPinEdge(toSuperviewSafeArea: .left, withInset: 15)
        quizImage.autoPinEdge(toSuperviewSafeArea: .top, withInset: 15)
        quizImage.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 15)
        quizImage.autoSetDimension(.width, toSize: 100)
        quizImage.autoAlignAxis(toSuperviewAxis: .horizontal)
        
        headline.autoPinEdge(.left, to: .right, of: quizImage, withOffset: 10)
        headline.autoPinEdge(toSuperviewSafeArea: .top, withInset: 23)
        headline.autoPinEdge(toSuperviewSafeArea: .right, withInset: 10)
        
        quizDescription.autoPinEdge(.left, to: .right, of: quizImage, withOffset: 10)
        quizDescription.autoPinEdge(.top, to: .bottom, of: headline, withOffset: 15)
        quizDescription.autoPinEdge(toSuperviewSafeArea: .right, withInset: 10)
        quizDescription.numberOfLines = 0
        
        grade.autoPinEdge(toSuperviewSafeArea: .top, withInset: 10)
        grade.autoPinEdge(toSuperviewSafeArea: .right, withInset: 10)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        super.backgroundColor = UIColor.white.withAlphaComponent(0)
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        contentView.layer.cornerRadius = 8
    }
    
    
}
