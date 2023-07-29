import ProjectDescription
import ProjectDescriptionHelpers

// MARK: - Project Factory
protocol ProjectFactory {
    var projectName: String { get }
    var dependencies: [TargetDependency] { get }
    
    func generateTarget() -> [Target]
    func generateConfigurations() -> Settings
}

// MARK: - Base Project Factory
class BaseProjectFactory: ProjectFactory {
    let projectName: String = "DevReels"
    
    let deploymentTarget: ProjectDescription.DeploymentTarget = .iOS(targetVersion: "16.0", devices: [.iphone])
    
    let dependencies: [TargetDependency] = [
        .external(name: "RxSwift"),
        .external(name: "RxCocoa"),
        .external(name: "RxKeyboard"),
        .external(name: "RxDataSources"),
        .external(name: "SnapKit"),
        .external(name: "Then"),
        .external(name: "FirebaseAuth"),
        .external(name: "FirebaseDatabase"),
        .external(name: "FirebaseFirestore"),
        .external(name: "FirebaseStorage"),
        .external(name: "FirebaseMessaging"),
        .external(name: "Swinject"),
        .external(name: "PryntTrimmerView"),
        .target(name: "RxDevReelsYa"),
        .target(name: "DRVideoController")
    ]
    
    let infoPlist: [String: InfoPlist.Value] = [
        "CFBundleShortVersionString": "1.0.1",
        "CFBundleVersion": "1",
        "UILaunchStoryboardName": "LaunchScreen",
        "UIApplicationSceneManifest": [
            "UIApplicationSupportsMultipleScenes": false,
            "UISceneConfigurations": [
                "UIWindowSceneSessionRoleApplication": [
                    [
                        "UISceneConfigurationName": "Default Configuration",
                        "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                    ],
                ]
            ]
        ],
        "NSAppTransportSecurity": [
            "NSAllowsArbitraryLoads": true
        ],
        "UIUserInterfaceStyle": "Dark"
    ]
    
    let baseSettings: [String: SettingValue] = [
        "OTHER_LDFLAGS": "-ObjC"
    ]
    
    let releaseSetting: [String: SettingValue] = [:]
    
    let debugSetting: [String: SettingValue] = [:]
    
    func generateConfigurations() -> Settings {
        return Settings.settings(
            base: baseSettings,
            configurations: [
              .release(
                name: "Release",
                settings: releaseSetting
              ),
              .debug(
                name: "Debug",
                settings: debugSetting
              )
            ],
            defaultSettings: .recommended
          )
    }
    
    func generateTarget() -> [Target] {
        [
            Target(
                name: projectName,
                platform: .iOS,
                product: .app,
                bundleId: "com.team.\(projectName)",
                deploymentTarget: deploymentTarget,
                infoPlist: .extendingDefault(with: infoPlist),
                sources: ["\(projectName)/Sources/**"],
                resources: "\(projectName)/Resources/**",
                entitlements: "\(projectName).entitlements",
                scripts: [.pre(path: "Scripts/SwiftLintRunScript.sh", arguments: [], name: "SwiftLint")],
                dependencies: dependencies
            ),
            Target(
                name: "RxDevReelsYa",
                platform: .iOS,
                product: .framework,
                bundleId: "com.team.\(projectName).RxDevReelsYa",
                deploymentTarget: deploymentTarget,
                infoPlist: .default,
                sources: ["RxDevReelsYa/Sources/**"],
                dependencies: [
                    .external(name: "Alamofire")
                ]
            ),
            Target(
                name: "DRVideoController",
                platform: .iOS,
                product: .framework,
                bundleId: "com.team.\(projectName).DRVideoController",
                deploymentTarget: deploymentTarget,
                infoPlist: .default,
                sources: ["DRVideoController/Sources/**"],
                dependencies: [
                    .external(name: "RxSwift"),
                    .external(name: "RxCocoa")
                ]
            )
        ]
    }
}

// MARK: - Project
let factory = BaseProjectFactory()

let project: Project = .init(
    name: factory.projectName,
    organizationName: factory.projectName,
    settings: factory.generateConfigurations(),
    targets: factory.generateTarget()
)

