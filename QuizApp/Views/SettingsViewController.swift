import UIKit
import SnapKit

class SettingsViewController: UIViewController {
    
    private var coordinator: QuizAppProtocol!
    
    convenience init(coordinator: QuizAppProtocol) {
        self.init()
        self.coordinator = coordinator
    }
    
    private let username: UILabel = {
        let username = UILabel()
        username.text = "USERNAME"
        username.textColor = .white
        username.textAlignment = .left
        username.font = UIFont(name:"ArialRoundedMTBold", size: 15)
        return username
    }()
    
    private let myUsername: UILabel = {
        let myUsername = UILabel()
        myUsername.text = "ime i prezime"
        myUsername.textColor = .white
        myUsername.textAlignment = .left
        myUsername.font = UIFont(name:"ArialRoundedMTBold", size: 25)
        return myUsername
    }()
    
    private let logoutButton: UIButton = {
        let logoutButton = UIButton()
        logoutButton.setTitle("Log out", for: .normal)
        logoutButton.titleLabel?.font = UIFont(name:"ArialRoundedMTBold", size: 15.0)
        logoutButton.setTitleColor(.red, for: .normal)
        logoutButton.backgroundColor = .white
        logoutButton.clipsToBounds = true
        logoutButton.layer.cornerRadius = 20
        logoutButton.addTarget(self, action: Selector(("logoutButtonpress:")), for: .touchUpInside)
        return logoutButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildViews()
        addConstraints()
        
        self.view = view
    }
    
    private func buildViews(){
        view.backgroundColor = .purple

        view.addSubview(username)
        view.addSubview(myUsername)
        view.addSubview(logoutButton)
    }
    
    private func addConstraints(){
        
        username.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(100)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.size.equalTo(CGSize(width: 340,height: 40))
        }
        
        myUsername.snp.makeConstraints {
            $0.top.equalTo(username).offset(30)
            $0.leading.equalTo(username)
            $0.size.equalTo(CGSize(width: 340,height: 40))
        }
        
        logoutButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
            $0.size.equalTo(CGSize(width: 340,height: 40))
        }
    }
    
    @objc func logoutButtonpress(_ sender: UIButton){
        coordinator.setStartScreen(in: UIApplication.shared.windows.first)
    }
    
}
