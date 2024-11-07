//
//  MessageCell.swift
//  UIKitAnimations
//
//  Created by Coder ACJHP on 7.11.2024.
//

import UIKit

class MessageCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: MessageCell.self)
    
    // Constraint referansları
    private var leadingConstraint: NSLayoutConstraint!
    private var trailingConstraint: NSLayoutConstraint!
    
    var isFromUser: Bool = false {
        didSet {
            updateAlignment()
        }
    }
    
    // Mesajı sarmalayacak UIView
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#F9F9F9")
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Mesaj metnini gösterecek UILabel
    let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = #colorLiteral(red: 0.131020546, green: 0.1417218447, blue: 0.1572332978, alpha: 1)
        label.numberOfLines = 0 // Çok satırlı yapar
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear // Hücre arka planını şeffaf yapıyoruz
        
        contentView.addSubview(containerView)
        containerView.addSubview(messageLabel)
        // containerView için otomatik layout ayarları
        leadingConstraint = containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        trailingConstraint = containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            containerView.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width * 0.75),
            leadingConstraint,
            trailingConstraint
        ])
        
        // messageLabel için padding ayarları
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
            messageLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5)
        ])
        
        // Başlangıç hizalamasını belirle
        updateAlignment()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Mesajın hizalamasını güncelleyen fonksiyon
    private func updateAlignment() {
        if isFromUser {
            // Kullanıcı mesajı ise sağa hizala
            leadingConstraint.isActive = false
            trailingConstraint.isActive = true
            containerView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
        } else {
            // AI mesajı ise sola hizala
            leadingConstraint.isActive = true
            trailingConstraint.isActive = false
            containerView.backgroundColor = UIColor(hexString: "#F9F9F9")
        }
    }
    
    // Mesajı ve göndereni ayarlayan yardımcı fonksiyon
    func configure(with message: Message) {
        messageLabel.attributedText = stylize(text: message.text)
        self.isFromUser = message.isFrom == .user
    }
    
    private func stylize(text: String) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .natural
        paragraphStyle.lineSpacing = 5
        
        let totalRange = NSRange(location: 0, length: text.count)
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: totalRange)
        attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: totalRange)
        return attributedString
    }
}
