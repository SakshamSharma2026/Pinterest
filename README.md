# Pinterest Gesture Menu (Flutter)

A **Pinterest-style long-press gesture menu** for Flutter that reveals a floating action menu from the user’s touch point. It supports **drag-to-select interactions, haptic feedback, smart boundary detection, and clean controller-driven architecture**.

This component is designed with **production-grade Flutter patterns**:

* Separation of concerns (Controller vs UI)
* Testable geometry and selection logic
* Accessibility-friendly motion
* Reusable and extensible API

---

🎥 Demo

Add a short screen recording or GIF to showcase the long-press + drag-to-select interaction.

Demo Video / GIF:
[Check out the post]()

---


## ✨ Features

* 📌 **Long-press to open menu** at the exact touch point
* 🎯 **Drag-to-select** menu actions
* 📳 **Haptic feedback** on selection
* 🧠 **Smart edge clamping** (menu never goes off-screen)
* 🧩 **Controller-based architecture** (business logic separated from UI)
* ⚡ **High performance** (cached geometry, minimal rebuilds)
* ♿ **Reduced motion friendly** (supports system animation preferences)

---

## 📦 Architecture Overview

This menu uses a **controller-driven design**, similar to Flutter’s `TextEditingController` or `ScrollController`.

```
UI (Widget)
  ├─ Handles gestures
  ├─ Drives animations
  └─ Renders UI

Controller (PinterestMenuController)
  ├─ Owns state
  ├─ Calculates geometry
  ├─ Handles selection logic
  └─ Notifies listeners
```

This keeps the system:

* Testable
* Scalable
* Easy to integrate with BLoC, Riverpod, or Provider

---

## 🗂 Folder Structure

```
lib/
  pinterest_menu/
    pinterest_menu_controller.dart

  widgets/
    animated_menu_btn.dart
    content_card.dart
    menu_btn.dart

  core/
    app_constants.dart

  pinterest_gesture_menu.dart
```


## 📜 License

MIT License — Free to use in personal and commercial projects.

---

## 💬 Credits

Inspired by Pinterest’s mobile interaction design and built using Flutter best practices.

---

## ⭐ Final Note

This component is designed to be:

> **Portfolio-grade, production-ready, and architecturally clean**


Happy building 🚀
