import SwiftUI
import Alamofire

class RegisterViewModel: ObservableObject {
    @Published var username = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var registrationSuccessful = false
    @Published var registerAlertMessage = ""
    @Published var registerAlert = false
    @Published var isLoading = false
   func register() {
        if username.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            registerAlertMessage = "Please fill all the fields"
            registerAlert = true
            return
        }

        if password.count < 8 {
            registerAlertMessage = "Password should be at least 8 characters."
            registerAlert = true
            return
        }

        if password != confirmPassword {
            registerAlertMessage = "Passwords do not match."
            registerAlert = true
            return
        }

        registerApi()
    }
    // http://localhost:3000/api/v1/users   register
    // https://run.mocky.io/v3/f7a8587a-924c-4758-bda0-c4462dcc70e1 success apantisi
    //https://run.mocky.io/v3/24c8db7a-4f42-4b11-81f6-3263fd92a7d1 apantisi me error
    func registerApi() {
        isLoading = true 

        let parameters: [String: [String: String]] = [ 
                  "user": [
                      "username": username,
                      "password": password,
                      "password_confirmation": confirmPassword
                  ]
              ]
        
        
        AF.request("http://localhost:3000/api/v1/users", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
            .validate()
            .response { [weak self] response in
                guard let self = self else { return }
                self.isLoading = false

                switch response.result {
                case .success:
                    self.registerAlertMessage = "Registration successful!"
                    self.registerAlert = true
                    self.registrationSuccessful = true
                case .failure(let error):
                    self.registerAlertMessage = error.localizedDescription
                    self.registerAlert = true
                }
            }
    }
}
