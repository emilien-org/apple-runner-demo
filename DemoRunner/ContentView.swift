import SwiftUI

struct ContentView: View {
    @State private var isHovering = false
    @State private var isLaunching = false
    @State private var showSuccess = false
    
    var body: some View {
        ZStack {
            // --- FOND PREMIUM TEINTÉ (GLASSMORPHISM) ---
            ZStack {
                // 1. Effet de flou (Adaptatif)
                #if os(macOS)
                VisualEffectView(material: .underWindowBackground, blendingMode: .behindWindow)
                #else
                // Sur iOS, on utilise l'effet Ultra Thin Material natif
                Rectangle().fill(.ultraThinMaterial)
                #endif
                
                // 2. La teinte subtile (Violet Scaleway au début, Vert au succès)
                (showSuccess ? Color.green : Color.scaleway)
                    .opacity(0.06)
                    .animation(.easeInOut(duration: 0.8), value: showSuccess)
                
                // 3. Couche d'opacité pour stabiliser le fond
                Color.white.opacity(0.45)
                
                // 4. Cercles de lumière pour la profondeur
                ZStack {
                    Circle()
                        .fill(showSuccess ? Color.green.opacity(0.2) : Color.blue.opacity(0.15))
                        .frame(width: 450, height: 450)
                        .blur(radius: 80)
                        .offset(x: -200, y: -150)
                    
                    Circle()
                        .fill(Color.scaleway.opacity(0.25))
                        .frame(width: 450, height: 450)
                        .blur(radius: 80)
                        .offset(x: 200, y: 150)
                }
            }
            .ignoresSafeArea()
            .allowsHitTesting(false)
            
            VStack(spacing: 35) {
                
                // --- LOGO M2 (S'efface au succès) ---
                if !showSuccess {
                    // Note: Assurez-vous que l'image est bien dans Assets.xcassets
                    Image("ScalewayLogo")
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
                
                // --- ICÔNE DYNAMIQUE ---
                Image(systemName: showSuccess ? "checkmark.seal.fill" : "shuttle.fill")
                    .font(.system(size: 70))
                    .foregroundStyle(showSuccess ? AnyShapeStyle(.green) : AnyShapeStyle(LinearGradient(colors: [.blue, .cyan], startPoint: .top, endPoint: .bottom)))
                    .symbolEffect(.bounce, value: isHovering || isLaunching)
                    .shadow(color: showSuccess ? .green.opacity(0.3) : .blue.opacity(0.3), radius: 10)

                // --- ZONE TEXTE ---
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
                    
                // --- BOUTON D'ACTION ---
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
                #if os(macOS)
                .onHover { isHovering = $0 }
                #endif
            }
            .padding(50)
        }
        // Sur iOS, on laisse l'app prendre toute la place, sur Mac on fixe une taille
        #if os(macOS)
        .frame(minWidth: 600, minHeight: 650)
        #endif
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showSuccess)
        .animation(.easeInOut, value: isLaunching)
    }
    
    var buttonText: String {
        if isLaunching { return "Loading..." }
        return showSuccess ? "Reset" : "Start the demo"
    }
    
    func startDemoSequence() {
        if showSuccess {
            showSuccess = false
            return
        }
        isLaunching = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLaunching = false
            showSuccess = true
        }
    }
}

// --- UTILITAIRE POUR L'EFFET DE FLOU MACOS (Isolé pour iOS) ---
#if os(macOS)
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
#endif

// --- EXTENSION COULEURS ---
extension Color {
    static let scaleway = Color(red: 191/255, green: 149/255, blue: 249/255)
}

#Preview {
    ContentView()
}
