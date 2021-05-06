import UIKit

class SelectIconHeaderViewCell: UICollectionViewCell {

    internal let mainView = UIView()
    internal var title = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func initializeUI() {

        self.backgroundColor = UIColor.clear
        self.addSubview(mainView)
        mainView.backgroundColor = UIColor.clear

        mainView.addSubview(title)
        title.text = ""
        title.font = UIFont(name:"ArialRoundedMTBold", size: 17.0)
        title.textAlignment = .left
        title.textColor = .white
        title.numberOfLines = 1

    }


    internal func createConstraints() {

        mainView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }

        title.snp.makeConstraints { (make) in
            make.centerY.equalTo(mainView.snp.centerY)
            make.leading.equalTo(mainView).offset(10)
            make.trailing.equalTo(mainView).offset(-10)
        }
    }


    func setTitle(title: String)  {

        self.title.text = title
    }


    static var reuseId: String {
        return NSStringFromClass(self)
    }
    
}
