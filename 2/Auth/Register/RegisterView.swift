import SwiftUI

struct RegisterView: View {
    @Binding var showRegisterCover: Bool
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
                viewModel.confirmPassword = ""
                viewModel.password = ""
                viewModel.username = ""
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            .disabled(viewModel.isLoading)

            if viewModel.isLoading {
                ProgressView()
            }

            Button(action: {
                showRegisterCover = false
            }) {
                HStack {
                    Image(systemName: "chevron.backward")
                    Text("Back to Login")
                }
            }
            .padding(.top, 10)
            .foregroundColor(.blue)

            .alert(isPresented: $viewModel.registerAlert) {
                Alert(title: Text("Registration"), message: Text(viewModel.registerAlertMessage), dismissButton: .default(Text("OK")) {
                    if viewModel.registrationSuccessful {
                        showRegisterCover = false
                    }
                })
            }
        }
        .padding()
    }
}

#Preview {
    RegisterView(showRegisterCover: .constant(true))
}
