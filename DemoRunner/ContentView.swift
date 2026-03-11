import SwiftUI

struct ContentView: View {
    @State private var isHovering = false
    @State private var isLaunching = false
    @State private var showSuccess = false
    
    var body: some View {
        ZStack {
            // Fond dégradé compatible
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
                
                // Icône avec gestion de version pour symbolEffect
                Image(systemName: showSuccess ? "checkmark.seal.fill" : "shuttle.fill")
                    .font(.system(size: 70))
                    // Correction Gradient : On applique le style directement
                    .foregroundStyle(showSuccess ? AnyShapeStyle(.green) : AnyShapeStyle(LinearGradient(colors: [.blue, .cyan], startPoint: .top, endPoint: .bottom)))
                    // On utilise bounce qui est plus largement supporté
                    .symbolEffect(.bounce, value: isHovering || isLaunching)
                    .shadow(color: showSuccess ? .green.opacity(0.3) : .blue.opacity(0.3), radius: 10)

                VStack(spacing: 8) {
                    Text(showSuccess ? "Décollage réussi !" : "DemoRunner")
                        .font(.system(size: 36, weight: .black, design: .rounded))
                    
                    Text(showSuccess ? "L'application est prête." : "Prêt pour le test de compilation ?")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }

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
                    .frame(width: 180, height: 35)
                }
                .buttonStyle(.borderedProminent)
                .tint(showSuccess ? .green : .blue)
                .disabled(isLaunching)
                .scaleEffect(isHovering ? 1.05 : 1.0)
                .onHover { isHovering = $0 }
            }
            .padding(50)
        }
        .frame(minWidth: 500, minHeight: 400)
        .animation(.spring(), value: showSuccess)
        .animation(.easeInOut, value: isLaunching)
    }
    
    var buttonText: String {
        if isLaunching { return "Chargement..." }
        return showSuccess ? "Réinitialiser" : "Lancer la démo"
    }
    
    func startDemoSequence() {
        if showSuccess {
            showSuccess = false
            return
        }
        isLaunching = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLaunching = false
            showSuccess = true
        }
    }
}

#Preview {
    ContentView()
}
