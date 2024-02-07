import Foundation

public protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}

final class WebViewPresenter: WebViewPresenterProtocol {
    func code(from url: URL) -> String? {
//        if
//            //let url = navigationAction.request.url,
//            let urlComponents = URLComponents(string: url.absoluteString),
//            urlComponents.path == "/oauth/authorize/native",
//            let items = urlComponents.queryItems,
//            let codeItem = items.first(where: { $0.name == "code" })
//        {
//            return codeItem.value
//        } else {
//            return nil
//        }
        authHelper.code(from: url)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
                
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
    
    func viewDidLoad() {
        let request = authHelper.authRequest()
        view?.load(request: request)
        
//        var urlComponents = URLComponents(string: ApiConstants.unsplashAuthorizeURLString)!
//        urlComponents.queryItems = [
//            URLQueryItem(name: "client_id", value: ApiConstants.accessKey),
//            URLQueryItem(name: "redirect_uri", value: ApiConstants.redirectURI),
//            URLQueryItem(name: "response_type", value: "code"),
//            URLQueryItem(name: "scope", value: ApiConstants.accessScope)
//         ]
//        let url = urlComponents.url!
//
//        let request = URLRequest(url: url)
//        view?.load(request: request)
    }
    
    weak var view: WebViewViewControllerProtocol?
    var authHelper: AuthHelperProtocol
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
}
