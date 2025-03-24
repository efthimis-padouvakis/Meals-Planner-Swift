import SwiftUI

struct RegisterView: View {
    @Binding var isRegistering: Bool // back to login
    @StateObject private var viewModel = RegisterViewModel()

    var body: some View {
        VStack {
            Text("Register")
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

            SecureField("Confirm Password", text: $viewModel.confirmPassword)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)

            Button("Register") {
                viewModel.register()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)
            .disabled(viewModel.isLoading) 

            if viewModel.isLoading {
                ProgressView()
            }

            Button("Login") {
                isRegistering = false
            }
            .padding(.top, 10)
            .foregroundColor(.gray)

            .alert(isPresented: $viewModel.registerAlert) {
                Alert(title: Text("Registration"), message: Text(viewModel.registerAlertMessage), dismissButton: .default(Text("OK")) {
                    if viewModel.registrationSuccessful {
                        isRegistering = false
                    }
                })
            }
        }
        .padding()
    }
}
#Preview {
   RegisterView(isRegistering: .constant(true))
}
