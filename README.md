# Oasis

A free, open-source macOS app that brings the best iPhone features to your Mac.

It runs as a **menu bar agent** (no Dock icon), starting with a **Dynamic Island + Now Playing** experience around the notch.

> ⚠️ Early development (Slice 1) — not ready for real-world use yet.

---

## Requirements

- macOS **14.4 Sonoma** or later
- (To build from source) Xcode 15.3+ with the macOS SDK

## Build from source

```sh
git clone https://github.com/rcn/oasis.git
cd oasis
open Oasis.xcodeproj   # then press Run in Xcode (⌘R)
```

Or build from the command line:

```sh
xcodebuild -project Oasis.xcodeproj -scheme Oasis -configuration Release build
```

## Install a prebuilt binary (Releases)

Download the `.dmg` from the [Releases](https://github.com/rcn/oasis/releases) page and drag `Oasis.app` into `/Applications`.

The build is **unsigned** (no Apple Developer account), so macOS Gatekeeper will warn you the first time you open it. There are two ways around this:

**Option 1 — Right-click > Open**
Right-click `Oasis.app`, choose **Open**, then click **Open** to confirm in the dialog (only needed once).

**Option 2 — Remove the quarantine attribute**

```sh
xattr -cr /Applications/Oasis.app
```

## Permissions

On first launch, an onboarding screen requests:

1. **Automation** — to talk to Music.app via ScriptingBridge (read the currently playing song)
2. **Audio capture** — for the audio visualizer via CoreAudio Process Tap

## License

[GPLv3](LICENSE) © Rachanon
