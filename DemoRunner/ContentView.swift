import SwiftUI

struct ContentView: View {
    @State private var isHovering = false
    @State private var isLaunching = false
    @State private var showSuccess = false
    
    var body: some View {
        ZStack {
            // --- FOND OPTIMISÉ (MOINS TRANSPARENT) ---
            ZStack {
                // 1. L'effet de flou de base (Vibrant Material)
                VisualEffectView(material: .underWindowBackground, blendingMode: .behindWindow)
                
                // 2. LA COUCHE D'OPACITÉ : Un fond blanc très léger qui "fixe" la transparence
                Color.white.opacity(0.6)
                
                // 3. Les cercles lumineux de profondeur (légèrement ajustés)
                ZStack {
                    Circle()
                        .fill(showSuccess ? Color.green.opacity(0.12) : Color.blue.opacity(0.12))
                        .frame(width: 300, height: 300)
                        .blur(radius: 60)
                        .offset(x: -150, y: -100)
                    
                    Circle()
                        .fill(Color.purple.opacity(0.12))
                        .frame(width: 300, height: 300)
                        .blur(radius: 60)
                        .offset(x: 150, y: 100)
                }
            }
            .ignoresSafeArea()
            .allowsHitTesting(false) // Pour ne pas bloquer les clics sur l'interface
            
            VStack(spacing: 35) {
                
                // LOGO M2 (Optimisé)
                if !showSuccess {
                    Image("ScalewayLogo") // Assure-toi que le nom correspond dans tes Assets
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 140, height: 140)
                        .saturation(1.2)
                        .shadow(color: Color.black.opacity(0.2), radius: 12, x: 0, y: 8)
                        .transition(.asymmetric(
                            insertion: .scale.combined(with: .opacity),
                            removal: .opacity.combined(with: .scale(scale: 0.5))
                        ))
                }
                
                // ICÔNE DE SUCCÈS OU NAVETTE
                Image(systemName: showSuccess ? "checkmark.seal.fill" : "shuttle.fill")
                    .font(.system(size: 70))
                    .foregroundStyle(showSuccess ? AnyShapeStyle(.green) : AnyShapeStyle(LinearGradient(colors: [.blue, .cyan], startPoint: .top, endPoint: .bottom)))
                    .symbolEffect(.bounce, value: isHovering || isLaunching)
                    .shadow(color: showSuccess ? .green.opacity(0.3) : .blue.opacity(0.3), radius: 10)

                // TEXTES
                VStack(spacing: 12) {
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
                    
                // BOUTON
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
        .frame(minWidth: 600, minHeight: 600)
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showSuccess)
        .animation(.easeInOut, value: isLaunching)
    }
    
    var buttonText: String {
        if isLaunching { return "Loading..." }
        return showSuccess ? "Reset" : "Start the demo"
    }
    
    func startDemoSequence() {
        if showSuccess { showSuccess = false; return }
        isLaunching = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLaunching = false
            showSuccess = true
        }
    }
}

// --- UTILITAIRE POUR L'EFFET DE FLOU MACOS ---
struct VisualEffectView: NSViewRepresentable {
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode
    
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
    }
}

extension Color {
    static let scaleway = Color(red: 191/255, green: 149/255, blue: 249/255)
}

#Preview {
    ContentView()
}
