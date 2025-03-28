import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var showRegisterCover = false
    @State private var loginRequirements = false
    var hatView = RotatingIconView()

    var body: some View {
        VStack {
            hatView
            Text("Login")
                .font(.largeTitle)
                .padding(.bottom, 20)

            TextField("Username", text: $viewModel.username)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)

            SecureField("Password", text: $viewModel.password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)

            Button("Login") {
                if viewModel.username.count > 6 && viewModel.password.count > 0 {
                    viewModel.login()
                    viewModel.username = ""
                    viewModel.password = ""
                } else {
                    loginRequirements = true
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)

            .alert(isPresented: $loginRequirements) { 
                Alert(title: Text("Login Requirements"), message: Text("Please fill all fields. Passwords need to be at least 6 characters."), dismissButton: .default(Text("OK")))
            }

            HStack {
                Text("Don't have an account?")
                Button("Register") {
                    showRegisterCover = true
                }
                .foregroundColor(.blue)
            }
            .padding(.top, 10)
            .foregroundColor(.gray)

            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .padding()
        .fullScreenCover(isPresented: $showRegisterCover) {
            RegisterView(showRegisterCover: $showRegisterCover)
        }
        .fullScreenCover(isPresented: $viewModel.isLoggedIn, content: {
            ExploreFoodView()
        })
    }
}

#Preview {
    LoginView()
}
