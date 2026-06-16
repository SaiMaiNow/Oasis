//
//  DynamicIslandController.swift
//
//  Created by Rachanon on 16/6/2569 BE.
//

import SwiftUI
import AppKit

/// ขนาดของ pill — ต้องตรงกับ .frame ใน DynamicIslandPanel (เท่ารอยบาก notch)
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
        hosting.sizingOptions = []             // อย่าให้ auto-resize window ตามเนื้อหา → คุมขนาดเองให้ตรง islandSize

        let panel = NSPanel(
            contentRect: hosting.frame,
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        panel.isOpaque = false                 // ให้พื้นหลังโปร่งได้
        panel.backgroundColor = .clear         // เห็นเฉพาะ pill สีดำ
        panel.hasShadow = false
        panel.level = .statusBar               // ลอยเหนือ menu bar
        panel.collectionBehavior = [.canJoinAllSpaces, .stationary, .fullScreenAuxiliary]
        panel.contentView = hosting
        return panel
    }

    private func position(_ panel: NSPanel) {
        guard let screen = NSScreen.main else { return }
        let frame = screen.frame
        let x = frame.midX - islandSize.width / 1.9
        let y = frame.maxY - islandSize.height
        panel.setFrameOrigin(NSPoint(x: x, y: y))
    }
}
