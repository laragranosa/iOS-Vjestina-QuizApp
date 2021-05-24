import UIKit

protocol QuizAppProtocol{
    func setStartScreen(in window: UIWindow?)
    func showQuizzesViewController()
    func startTabBarController()
    func createQuizViewController(data: Quiz)
    func setResultViewController(time: Double, quizId: Int, quizResult: String)
    
}

class QuizzAppCoordinator: QuizAppProtocol {
    
    private let navigationController: UINavigationController!
    
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
        
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
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
    
    func createQuizViewController(data: Quiz) {
        let vc = QuizViewController(coordinator: self, quizData: data)
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func setResultViewController(time: Double, quizId: Int, quizResult: String){
        let vc = QuizResultViewController(coordinator: self, time: time, quizId: quizId, quizResult: quizResult)
        self.navigationController.pushViewController(vc, animated: true)
    }
    
}
