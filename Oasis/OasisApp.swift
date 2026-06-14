import SwiftUI

@main
struct OasisApp: App {
    var body: some Scene {
        MenuBarExtra("Oasis", systemImage: "music.note") {
            Text("Oasis")
                .font(.headline)
            Divider()
            Button("Quit Oasis") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q")
        }
    }
}
	
