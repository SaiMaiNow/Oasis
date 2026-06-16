import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate {
    let island = DynamicIslandController()

    func applicationDidFinishLaunching(_ notification: Notification) {
        island.show()
    }
}

@main
struct OasisApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        MenuBarExtra("Oasis", systemImage: "music.note") {
            Text("Oasis")
                .font(.headline)
            Divider()
            Button("Toggle Dynamic Island") {
                appDelegate.island.toggle()
            }
            Divider()
            Button("Song Started") {
                appDelegate.island.songDidStart()
            }
            Button("Song Stopped") {
                appDelegate.island.songDidStop()
            }
            Divider()
            Button("Quit Oasis") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q")
        }
    }
}
	
