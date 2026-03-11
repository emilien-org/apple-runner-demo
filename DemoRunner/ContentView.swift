import SwiftUI

struct ContentView: View {
    @State private var isHovering = false
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            // 1. Fond dynamique (Gradient animé)
            LinearGradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            // 2. Effet de flou "Glassmorphism"
            VisualEffectView(material: .hudWindow, blendingMode: .withinWindow)
                .ignoresSafeArea()
            
            VStack(spacing: 25) {
                // 3. Icône SF Symbol animée
                Image(systemName: "shuttle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .foregroundStyle(
                        .linearGradient(colors: [.cyan, .blue],
                                        startPoint: .top,
                                        endPoint: .bottom)
                    )
                    .shadow(color: .blue.opacity(0.5), radius: 10)
                    .rotationEffect(.degrees(rotation))
                    .onAppear {
                        withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                            rotation = 15
                        }
                    }
                
                // 4. Texte avec dégradé et typographie forte
                VStack(spacing: 5) {
                    Text("DemoRunner")
                        .font(.system(size: 40, weight: .black, design: .rounded))
                        .foregroundStyle(.primary)
                    
                    Text("Prochaine étape : La Lune 🚀")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
                
                // 5. Bouton interactif avec effet au survol
                Button(action: { print("Action lancée !") }) {
                    Text("Lancer la démo")
                        .fontWeight(.bold)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 12)
                }
                .buttonStyle(.plain)
                .background(isHovering ? Color.blue : Color.primary.opacity(0.1))
                .clipShape(Capsule())
                .scaleEffect(isHovering ? 1.05 : 1.0)
                .animation(.spring(response: 0.3), value: isHovering)
                .onHover { hovering in
                    isHovering = hovering
                }
            }
            .padding(40)
        }
        .frame(minWidth: 500, minHeight: 400)
    }
}

// Utilitaire pour l'effet de flou natif macOS
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

#Preview {
    ContentView()
}
