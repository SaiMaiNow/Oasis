//
//  DynamicIslandController.swift
//
//  Created by Rachanon on 16/6/2569 BE.
//

import SwiftUI
import AppKit

private let islandSize = NSSize(width: 240, height: 34)

final class DynamicIslandController {
    private var panel: NSPanel?

    func toggle() {
        if panel?.isVisible == true {
            panel?.orderOut(nil)
        } else {
            show()
        }
    }

    func show() {
        let panel = panel ?? makePanel()
        self.panel = panel
        position(panel)
        panel.orderFrontRegardless()
    }

    private func makePanel() -> NSPanel {
        let hosting = NSHostingView(rootView: DynamicIslandPanel())
        hosting.frame = NSRect(origin: .zero, size: islandSize)
        hosting.sizingOptions = []

        let panel = NSPanel(
            contentRect: hosting.frame,
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        panel.isOpaque = false
        panel.backgroundColor = .clear
        panel.hasShadow = false
        panel.level = .statusBar
        panel.collectionBehavior = [.canJoinAllSpaces, .stationary, .fullScreenAuxiliary]
        panel.contentView = hosting
        return panel
    }

    private func position(_ panel: NSPanel) {
        guard let screen = NSScreen.main else { return }
        let frame = screen.frame
        let x = frame.midX - islandSize.width / 1.7
        let y = frame.maxY - islandSize.height
        panel.setFrameOrigin(NSPoint(x: x, y: y))
    }
}
