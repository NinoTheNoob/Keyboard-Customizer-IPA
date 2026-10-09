# Keyboard-Customizer-IPA

## Little Quest — Flutter + iOS Kaomoji Keyboard

A small Flutter companion app with three tabs (kaomoji copy grid, live Unicode text styles, and gradient themes), plus a native Swift custom keyboard extension that inserts kaomojis directly into the active text field. The Flutter UI can be built for Android or iOS; the keyboard extension is iOS-only.

## Project layout

```text
.
├── .github/workflows/build_ipa.yml  # macOS CI build, artifact, tagged release
├── ios/
│   ├── KeyboardExtension/           # Native keyboard view controller and extension metadata
│   ├── Runner/                      # Flutter iOS host app
│   └── Runner.xcodeproj/            # Runner + embedded keyboard extension targets
├── lib/main.dart                    # Companion app UI and Unicode text transforms
├── test/widget_test.dart
├── analysis_options.yaml
└── pubspec.yaml
```

## Build on Windows

Install the Flutter stable SDK and Git, then open PowerShell or Windows Terminal in this folder:

```powershell
flutter doctor
flutter pub get
flutter test
```

Flutter's UI source is cross-platform. This repository contains the iOS host and keyboard extension because iOS keyboard extensions must be native app-extension targets; Windows cannot compile iOS apps. If you also want a locally generated Android wrapper, add it without regenerating the iOS project:

```powershell
flutter create --platforms=android .
flutter run
```

Run `flutter run` after generating an Android platform folder; the checked-in native platform target is iOS.

## Initialize and push to GitHub (PowerShell)

Create an empty repository on GitHub first (do not initialize it with a README/license), then replace `YOUR_GITHUB_USERNAME` and `YOUR_REPOSITORY` below:

```powershell
git init
git add .
git commit -m "Create Flutter kaomoji keyboard app"
git branch -M main
git remote add origin https://github.com/YOUR_GITHUB_USERNAME/YOUR_REPOSITORY.git
git push -u origin main
```

## Build an unsigned IPA with GitHub Actions

Push to `main`/`master` or run **Actions → Build unsigned iOS IPA → Run workflow**. The workflow installs Flutter on `macos-latest`, runs `flutter test`, builds with:

```bash
flutter build ios --release --no-codesign
```

It packages `build/ios/iphoneos/Runner.app` under `Payload/Runner.app` as `keyboard.ipa` and uploads it as the `keyboard-unsigned-ipa` artifact. Pushing a `v*` tag also attaches that IPA to a GitHub Release, for example:

```powershell
git tag v1.0.0
git push origin v1.0.0
```

The artifact is deliberately **unsigned**. It is useful as a build artifact, but it is not a ready-to-install signed app. To use it on an iPhone, sign the containing app and keyboard extension with an Apple development certificate and provisioning profile, or use an AltStore-compatible signing flow that provisions both targets. The bundle IDs are placeholders (`com.example.kaomojikeyboard` and `com.example.kaomojikeyboard.KeyboardExtension`); change them to identifiers you control before signing. No Apple credentials or signing secrets belong in this repository. Once the signed app is installed, enable **Settings → General → Keyboard → Keyboards → Add New Keyboard → Kaomoji Keyboard**. The keyboard does not request Full Access.

## Keyboard behavior

The extension offers Happy, Love, Cute, Sad, and Fun kaomoji categories; tapping an item inserts it into the current text field. Its globe key returns to the next installed keyboard, and the space, delete, and return keys provide basic text entry. It does not read typed text, access the network, or use the clipboard. Theme selection and Unicode font conversion are companion-app features; the extension currently uses its own dark keyboard appearance.
