import UIKit
import SnapKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    private var titleLabel: UILabel!
    private var username: UITextField! { didSet { username.delegate = self } }
    private var password: UITextField! { didSet { password.delegate = self } }
    private var loginbutton: UIButton!
    private let eyeImage = UIImage(systemName: "eye.fill")!.withTintColor(.white, renderingMode: .alwaysOriginal)
    private var eyeButton: UIButton!
    private var iconClick = true
    private var coordinator: QuizAppProtocol!
    
    convenience init(coordinator: QuizAppProtocol) {
        self.init()
        self.coordinator = coordinator
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildViews()
        addConstraints()
        

        if username.text!.isEmpty && password.text!.isEmpty{
            loginbutton.isUserInteractionEnabled = false
            loginbutton.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        }
        
    }
    
    private func buildViews() {
        view.backgroundColor = customDesign().mycolor
        
        titleLabel = UILabel()
        titleLabel.text = "PopQuiz"
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name:"ArialRoundedMTBold", size: 30.0)
        
        
        //username = UITextField()
        username = buildTextField(string: "Username")
        
        //password = UITextField()
        password = buildTextField(string: "Password")
        password.isSecureTextEntry.toggle()

        
        
        loginbutton = UIButton(type: .system)
        loginbutton.addTarget(self, action: Selector(("buttonPress:")), for: .touchUpInside)
        loginbutton = customDesign().styleButton(button: loginbutton, title: "Login", width: 335)
        
        eyeButton = UIButton(type: .custom)
        eyeButton.addTarget(self, action: Selector(("iconAction:")), for: UIControl.Event.touchUpInside)
        eyeButton.setImage(eyeImage, for: .normal)
        password.rightView = eyeButton
        password.rightViewMode = .always
        
        view.addSubview(titleLabel)
        view.addSubview(username)
        view.addSubview(password)
        view.addSubview(loginbutton)

    }
    
    private func addConstraints(){
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(200)
            //$0.size.equalTo(CGSize(width: 340, height: 40))
        }

        username.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(password).offset(password.frame.height/2 - 50)
            $0.leadingMargin.equalTo(view.safeAreaInsets).offset(30)
        }

        password.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leadingMargin.equalTo(view.safeAreaInsets).offset(30)
        }
        
        loginbutton.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(password).offset(password.frame.height/2 + 50)
            //$0.size.equalTo(CGSize(width: 340, height: 40))
        }
    }
    
    func buildTextField(string: String) -> UITextField {
        let textField : UITextField! = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        textField.attributedPlaceholder = NSAttributedString(string: string,
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        textField.clipsToBounds = true
        textField.textColor = .white
        textField.layer.cornerRadius = 20
        textField.backgroundColor = UIColor(white: 1, alpha: 0.5)
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10, height: 0))
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.autocapitalizationType = .none
        return textField
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       // textField.borderStyle = .line
        textField.layer.borderColor = UIColor.white.cgColor //your color
        textField.layer.borderWidth = 2.0
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0.0
    }
    
    
    @objc func buttonPress(_ sender: UIButton) {
        let login_username = username.text!
        let login_password = password.text!
        print(login_username)
        print(login_password)
        DispatchQueue.global(qos: .userInitiated).sync {
            customLogin()
        }
    }
    
    @objc func iconAction(_ sender: UIButton) {
        password.isSecureTextEntry.toggle()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string) as String

        if !text.isEmpty{
            loginbutton.isUserInteractionEnabled = true
            loginbutton.backgroundColor = UIColor.white
        } else {
            loginbutton.isUserInteractionEnabled = false
            loginbutton.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        }
        return true
    }
    
    func customLogin(){
        guard let user = username.text else { return }
        guard let pass = password.text else { return }
        guard let url = URL(string: "https://iosquiz.herokuapp.com/api/session?username=\(user)&password=\(pass)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        NetworkService().executeUrlRequest(request) { (result: Result< Session, RequestError>) in
            switch result {
            case .failure( _):
                print("error")
            case .success(let value):
                let defaults = UserDefaults.standard
                defaults.set(value.token, forKey: "token")
                defaults.set(value.user_id, forKey: "user_id")
                
                DispatchQueue.main.async {
                    self.coordinator.startTabBarController()
                }
        }
        }
    }
}
