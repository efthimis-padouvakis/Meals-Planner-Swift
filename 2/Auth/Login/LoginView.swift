import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var isRegistering = false

    var body: some View {
        NavigationStack {
            VStack {
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
                    viewModel.login()
                   
             
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)

                Button("Register if you don't have an account") {
                    isRegistering = true
                }
                .padding(.top, 10)
                .foregroundColor(.gray)

                .alert(isPresented: $viewModel.showAlert) {
                    Alert(title: Text("Error"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
                }
            }
            .padding()
            .navigationDestination(isPresented: $isRegistering) {
                RegisterView(isRegistering: $isRegistering)
            }
        }
    }
}

#Preview {
    LoginView()
}
