import UIKit
import SnapKit

class CustomCell: UICollectionViewCell {
    
    private let tit: UILabel = {
        let ti = UILabel()
        ti.numberOfLines = 1
        ti.textColor = .white
        ti.font = UIFont(name:"ArialRoundedMTBold", size: 13.0)
        return ti
    }()
    
    private let desc: UILabel = {
        let ti = UILabel()
        ti.numberOfLines = 2
        ti.textColor = .white
        ti.font = UIFont(name:"ArialRoundedMTBold", size: 10.0)
        return ti
    }()
    
    private let imU: UIImageView = {
        let ti = UIImageView(frame: CGRect(x:10, y:0, width: 100, height: 100))
        ti.contentMode = .scaleAspectFit
        ti.clipsToBounds = true
        return ti
    }()
    
    private let lvl: UIStackView = {
        let ti = UIStackView(frame: CGRect(x:0, y:0, width: 50, height: 15))
        ti.axis = .horizontal
        return ti
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        let imView = UIView(frame: CGRect(x:0, y:0, width: 30, height: 30))
        imView.addSubview(imU)
        
        contentView.addSubview(imView)
        contentView.addSubview(tit)
        contentView.addSubview(desc)
        contentView.addSubview(lvl)
        
        
        tit.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(145)
            $0.top.equalToSuperview().offset(30)
        }
        
        desc.snp.makeConstraints {
            $0.leading.equalTo(tit)
            $0.top.equalTo(tit).offset(20)
        }
        
        lvl.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(5)
            $0.top.equalToSuperview().offset(5)
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }

        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.imU.image = image
                
            }
        }
    }
    
    private func setLevel(_ level: Int){
        let img = UIImage(systemName: "star.fill")
        var image = UIImageView()
        let maxLevel = 3
        if (lvl.arrangedSubviews.count != 0){
            lvl.subviews.forEach({ $0.removeFromSuperview() })
        }
        for number in 1...maxLevel{
            if (number <= level){
                image = UIImageView(image: img!.withTintColor(.yellow, renderingMode: .alwaysOriginal))
                lvl.addArrangedSubview(image)
            } else {
                image = UIImageView(image : img!.withTintColor(.darkGray, renderingMode: .alwaysOriginal))
                lvl.addArrangedSubview(image)
            }
        }
    }
    
    func set(viewModel: QuizViewModel) {
        tit.text = viewModel.title
        desc.text = viewModel.description
        setLevel(viewModel.level)
        setImage(from: viewModel.imageUrl)
    }
}
