import SwiftUI

struct RotatingIconView: View {
    @State private var rotationAngle: Double = 0
    @State private var xOffset: CGFloat = 0
    @State private var yOffset: CGFloat = 0

    var body: some View {
        Image("skroutz")
            .resizable()
            .frame(width: 50, height: 50)
            .rotationEffect(.degrees(rotationAngle))
            .offset(x: xOffset, y: yOffset) 
            .onAppear {
                withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
                    rotationAngle = 360
                }
            }
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.5)) {
                    xOffset = CGFloat.random(in: -100...100)
                    yOffset = CGFloat.random(in: -100...100)
                }
            }
    }
}

#Preview {
    RotatingIconView()
}
