import UIKit

protocol QuizAppProtocol{
    
    func setStartScreen(in window: UIWindow?)
    func createQuizzesViewController() -> QuizzesViewController
    func startTabBarController()
    func createQuizViewController(data: QuizViewModel)
    func setResultViewController(time: Double, quizId: Int, quizResult: String)
    func createPresenter() -> QuizzesPresenter
    func createRepository() -> QuizRepository
    
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
    
    func createPresenter() -> QuizzesPresenter {
        let quizzesDataRepository = createRepository()
        let quizUseCase = QuizzesUseCase(quizzesRepository: quizzesDataRepository)
        let presenter = QuizzesPresenter(quizUseCase: quizUseCase, coordinator: self)
        return presenter
    }
    
    func createRepository() -> QuizRepository {
        let coreDataContext = CoreDataStack(modelName: "QuizDatabaseModel").managedContext
        return QuizRepository(
            jsonDataSource: QuizNetworkDataSource(),
            coreDataSource: QuizDatabaseDataSource(coreDataContext: coreDataContext))
    }
    
    func createQuizzesViewController() -> QuizzesViewController {
        let coreDataContext = CoreDataStack(modelName: "QuizDatabaseModel").managedContext
        let quizzesDataRepository = QuizRepository(
            jsonDataSource: QuizNetworkDataSource(),
            coreDataSource: QuizDatabaseDataSource(coreDataContext: coreDataContext))
        let presenter = createPresenter()
        let vc = QuizzesViewController(coordinator: self, presenter: presenter, quizRepository: quizzesDataRepository)
        
        return vc

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
        let imageSearch = UIImage(named: "magnifyingglass")?.maskWithColor(color: .purple)
        let presenter = createPresenter()
        let repository = createRepository()
        let quizzesViewController =
            createQuizzesViewController()
        quizzesViewController.tabBarItem = UITabBarItem(title: "Quiz", image: UIImage(systemName: "stopwatch"), selectedImage: imageQuiz)
        
        let searchVC = SearchQuizViewController(coordinator: self, presenter: presenter, repository: repository)
        searchVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), selectedImage: imageSearch)

        let settingsViewController = SettingsViewController(coordinator: self)
        settingsViewController.tabBarItem = UITabBarItem(title: "Settings",image: UIImage(systemName: "gear"),selectedImage: imageSettings)

        let tabBarViewController = UITabBarController()
        tabBarViewController.tabBar.tintColor = .purple
        tabBarViewController.viewControllers = [quizzesViewController, searchVC, settingsViewController]

        return tabBarViewController
    }
    
    func createQuizViewController(data: QuizViewModel) {
        let vc = QuizViewController(coordinator: self, quizData: data)
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func setResultViewController(time: Double, quizId: Int, quizResult: String){
        let vc = QuizResultViewController(coordinator: self, time: time, quizId: quizId, quizResult: quizResult)
        self.navigationController.pushViewController(vc, animated: true)
    }
    
}
