import UIKit

protocol QuizAppProtocol{
    func setStartScreen(in window: UIWindow?)
    func showQuizzesViewController()
    func startTabBarController()
    func createPageViewController(indexPath: IndexPath)
    func updatequizResult()
    func getResult() -> Int
    func getNumberOfQuestions() -> Int
    func setProgressBarView() -> UIStackView
    
}

class QuizzAppCoordinator: QuizAppProtocol {
    
    private let navigationController: UINavigationController!
    private var pageViewController: QuestionsViewController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func setStartScreen(in window: UIWindow?) {
        let vc = LoginViewController(coordinator: self)
        navigationController.setViewControllers([vc], animated: false)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func showQuizzesViewController() {
        let vc = QuizzesViewController(coordinator: self)
        
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()

    }
    
    func startTabBarController() {
        let vc = createTabBarViewController()
        self.navigationController.setViewControllers([vc], animated: true)
    }
    
    
    func createTabBarViewController() -> UIViewController {
        let imageQuiz = UIImage(named: "stopwatch")?.maskWithColor(color: .purple)
        let imageSettings = UIImage(named: "gear")?.maskWithColor(color: .purple)
        let quizzesViewController = QuizzesViewController(coordinator: self)
        quizzesViewController.tabBarItem = UITabBarItem(title: "Quiz", image: UIImage(systemName: "stopwatch"), selectedImage: imageQuiz)

        let settingsViewController = SettingsViewController(coordinator: self)
        settingsViewController.tabBarItem = UITabBarItem(title: "Settings",image: UIImage(systemName: "gear"),selectedImage: imageSettings)

        let tabBarViewController = UITabBarController()
        tabBarViewController.tabBar.tintColor = .purple
        tabBarViewController.viewControllers = [quizzesViewController, settingsViewController]

        return tabBarViewController
    }
    
    func createPageViewController(indexPath: IndexPath) {
        let pageViewController = QuestionsViewController(coordinator: self, indexPath: indexPath)
        self.pageViewController = pageViewController
        self.navigationController.pushViewController(pageViewController, animated: true)
    }
    
    func updatequizResult(){
        self.pageViewController.updateResult()
    }
    
    func getResult() -> Int {
        return self.pageViewController.getResult()
    }
    
    func getNumberOfQuestions() -> Int {
        return self.pageViewController.getNumberOfQuestions()
    }
    
    func setProgressBarView() -> UIStackView {
        return self.pageViewController.getStackView()
    }
    
}

extension UIImage {

    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!

        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!

        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)

        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }

}
