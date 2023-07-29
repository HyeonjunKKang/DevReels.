import UIKit
import Firebase
//import DevReelsKit
//import DevReelsUI
import FirebaseStorage

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        
        DIContainer.shared.inject()
        FirebaseApp.configure()
        //        DevReelsKit.hello()
        //        DevReelsUI.hello()
//        self.window?.overrideUserInterfaceStyle = .dark
        appearance()
        
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return true
    }
    
    private func appearance() {
        navigationBarAppearance()
        tabBarAppearance()
    }

    private func navigationBarAppearance() {
        let navigationBarAppearance = UINavigationBarAppearance()

        navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.devReelsColor.neutral500 ?? UIColor.white]
        navigationBarAppearance.backgroundColor = .devReelsColor.backgroundDefault
        
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
    }

    private func tabBarAppearance() {
        UITabBar.appearance().tintColor = .devReelsColor.primary70
        UITabBar.appearance().barTintColor = .devReelsColor.neutral30
    }
}
