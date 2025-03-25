import Foundation
import SwiftUI
import Alamofire


struct LoginResponse: Codable {
    let token: String?
    let error: String?
}

class LoginViewModel: ObservableObject {
    @Published var username = ""
    @Published var password = ""
    @Published var showAlert = false
    @Published var alertMessage = ""

    func login() {
        
        let parameters: [String: String] = [
            "username": username,
            "password": password
        ]
//
        AF.request("http://localhost:3000/api/v1/login", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
            .validate()
            .responseDecodable(of: LoginResponse.self) { response in
                switch response.result {
                case .success(let loginResponse):
                    if let token = loginResponse.token {
                        print("Login successful kai to to token: \(token)")
                    } else if let error = loginResponse.error {
                        self.alertMessage = error
                        self.showAlert = true
                    } else {
                        self.alertMessage = "Unknown error 1."
                        self.showAlert = true
                    }
                case .failure(let error):
                    print("Login error: \(error)")
                    self.alertMessage = error.localizedDescription
                    self.showAlert = true
                }
            }
    }
    
    
    
}
