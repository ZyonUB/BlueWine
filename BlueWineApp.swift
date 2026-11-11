import SwiftUI

@main
struct BlueWineApp: App {
    var body: some Scene {
        WindowGroup {
            BlueWineDashboard()
                .preferredColorScheme(.dark)
                .frame(minWidth: 900, minHeight: 600)
        }
        .windowStyle(.hiddenTitleBar)
    }
}

struct BlueWineDashboard: View {
    @State private var section = "Combat"
    @State private var search = ""
    @State private var enabled = true
    @State private var teammates = false
    @State private var preview = true
    @State private var fov = 100.0
    @State private var smooth = 0.25
    private let blue = Color(red: 0.08, green: 0.40, blue: 1.0)
    private let sections = ["Combat", "Visuals", "Player", "Overlays", "Settings", "Favorites"]

    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 10) {
                Label("Blue Wine", systemImage: "wineglass.fill")
                    .font(.system(size: 21, weight: .bold)).foregroundStyle(blue)
                    .padding(.horizontal, 18).padding(.vertical, 24)
                ForEach(sections, id: \.self) { item in
                    Button { section = item } label: {
                        Label(item, systemImage: icon(item))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(12)
                            .background(section == item ? blue.opacity(0.24) : .clear)
                            .clipShape(RoundedRectangle(cornerRadius: 9))
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(section == item ? .white : .white.opacity(0.65))
                }
                Spacer()
                Text("Blue Wine • macOS").font(.caption).foregroundStyle(.white.opacity(0.4)).padding(16)
            }
            .frame(width: 205).background(Color.black.opacity(0.25))

            VStack(alignment: .leading, spacing: 22) {
                HStack {
                    Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
                    TextField("Search settings...", text: $search).textFieldStyle(.plain)
                    Spacer()
                    Text("Blue Wine").font(.caption).foregroundStyle(.white.opacity(0.55))
                }
                .padding(12).background(Color.white.opacity(0.06)).clipShape(RoundedRectangle(cornerRadius: 10))

                Text(section).font(.system(size: 22, weight: .bold))
                Text("Standalone desktop interface demo. It does not connect to or modify Roblox.")
                    .font(.system(size: 12)).foregroundStyle(.white.opacity(0.45))

                if section == "Combat" || section == "Visuals" {
                    toggleRow("Enable demo control", detail: "Local interface switch only", value: $enabled)
                    sliderRow("FOV preview", value: $fov, range: 10...300, valueText: "\(Int(fov))")
                    sliderRow("Smoothness preview", value: $smooth, range: 0.01...1, valueText: String(format: "%.2f", smooth))
                    toggleRow("Ignore teammates (demo)", detail: "Example preference switch", value: $teammates)
                    toggleRow("Show preview panel", detail: "Display the sample preview", value: $preview)
                } else {
                    Text("Choose Combat or Visuals to see the sample controls.")
                        .foregroundStyle(.white.opacity(0.6))
                }
                Spacer()
                Label("UI-only demo • No injector • No game modification", systemImage: "info.circle")
                    .font(.caption).foregroundStyle(.white.opacity(0.4))
            }
            .padding(28)
        }
        .background(Color(red: 0.035, green: 0.045, blue: 0.07))
        .foregroundStyle(.white).tint(blue)
    }

    private func toggleRow(_ title: String, detail: String, value: Binding<Bool>) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.system(size: 14, weight: .semibold))
                Text(detail).font(.system(size: 11)).foregroundStyle(.white.opacity(0.42))
            }
            Spacer()
            Toggle(title, isOn: value).labelsHidden()
        }.padding(.vertical, 8)
    }

    private func sliderRow(_ title: String, value: Binding<Double>, range: ClosedRange<Double>, valueText: String) -> some View {
        VStack(spacing: 8) {
            HStack {
                Text(title).font(.system(size: 14, weight: .semibold))
                Spacer()
                Text(valueText).monospacedDigit().foregroundStyle(.white.opacity(0.65))
            }
            Slider(value: value, in: range)
        }.padding(.vertical, 6)
    }

    private func icon(_ name: String) -> String {
        switch name {
        case "Combat": return "scope"
        case "Visuals": return "eye"
        case "Player": return "person"
        case "Overlays": return "square.3.layers.3d"
        case "Settings": return "gearshape"
        default: return "star"
        }
    }
}
