import SwiftUI

struct ContentView: View {
    @State private var isHovering = false
    @State private var isLaunching = false
    @State private var showSuccess = false
    
    var body: some View {
        ZStack {
            // 1. Fond dégradé dynamique
            LinearGradient(
                colors: [
                    showSuccess ? Color.green.opacity(0.15) : Color.blue.opacity(0.15),
                    Color.purple.opacity(0.1)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                // 2. LOGO SCALEWAY M2 (Visible uniquement au début)
                if !showSuccess {
                    Image("ScalewayLogo") // Assure-toi que le nom correspond dans tes Assets
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200) // Taille augmentée pour plus de visibilité
                        .saturation(1.2) // Couleurs plus vives
                        .shadow(color: Color.black.opacity(0.2), radius: 12, x: 0, y: 8) // Ombre pour le relief
                        .transition(.asymmetric(
                            insertion: .scale.combined(with: .opacity),
                            removal: .opacity.combined(with: .scale(scale: 0.5))
                        ))
                }
                
                // 3. ICÔNE DE SUCCÈS OU NAVETTE
                Image(systemName: showSuccess ? "checkmark.seal.fill" : "shuttle.fill")
                    .font(.system(size: 70))
                    .foregroundStyle(showSuccess ? AnyShapeStyle(.green) : AnyShapeStyle(LinearGradient(colors: [.blue, .cyan], startPoint: .top, endPoint: .bottom)))
                    .symbolEffect(.bounce, value: isHovering || isLaunching)
                    .shadow(color: showSuccess ? .green.opacity(0.3) : .blue.opacity(0.3), radius: 10)

                // 4. TEXTES PRINCIPAUX
                VStack(spacing: 10) {
                    Text(showSuccess ? "Successful take off !" : "Welcome to a Swift app !")
                        .font(.system(size: 36, weight: .black, design: .rounded))
                        .multilineTextAlignment(.center)

                    Text(showSuccess
                         ? "This Swift application is working."
                         : "Built on a \(Text("Scaleway Apple Silicon").foregroundColor(.scaleway)) server !")
                        .font(.system(size: 18, weight: .black, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal)
                    
                // 5. BOUTON D'ACTION
                Button(action: { startDemoSequence() }) {
                    HStack {
                        if isLaunching {
                            ProgressView()
                                .controlSize(.small)
                                .padding(.trailing, 5)
                        }
                        Text(buttonText)
                            .fontWeight(.bold)
                    }
                    .frame(width: 200, height: 40)
                }
                .buttonStyle(.borderedProminent)
                .tint(showSuccess ? .green : .blue)
                .disabled(isLaunching)
                .scaleEffect(isHovering ? 1.05 : 1.0)
                .onHover { isHovering = $0 }
            }
            .padding(50)
        }
        // Taille de fenêtre adaptée au contenu
        .frame(minWidth: 800, minHeight: 600)
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showSuccess)
        .animation(.easeInOut, value: isLaunching)
    }
    
    // Libellé dynamique du bouton
    var buttonText: String {
        if isLaunching { return "Loading..." }
        return showSuccess ? "Reset" : "Start the demo"
    }
    
    // Logique de simulation du lancement
    func startDemoSequence() {
        if showSuccess {
            showSuccess = false
            return
        }
        isLaunching = true
        // Délai de 2 secondes pour simuler une action
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLaunching = false
            showSuccess = true
        }
    }
}

// Extension pour définir le violet Scaleway
extension Color {
    static let scaleway = Color(red: 191/255, green: 149/255, blue: 249/255)
}

#Preview {
    ContentView()
}
