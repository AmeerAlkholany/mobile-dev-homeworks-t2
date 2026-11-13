# Interactive Counter — GetX vs. Modern Riverpod 2.x

Second Flutter coursework assignment. The Interactive Counter application (counter controls,
automatic timer, application lifecycle handling) is implemented **twice, independently** in one
Flutter project:

1. **Implementation A — GetX** (`GetxController` + `Obx` + bindings)
2. **Implementation B — Modern Riverpod 2.x** (`AutoDisposeNotifier` + `NotifierProvider.autoDispose` + `ConsumerWidget`)

Both implementations expose the same features and share the same presentational UI, so the two
state-management approaches can be compared fairly. They share **no** state-management code: the
shared layer contains only a theme, a status enum, two formatting helpers and a stateless view.

---

## Note on the original Assignment 1 source

The specification asks to preserve the original counter application's features. The repository does
not contain that source: `main` holds the Flutter starter (`Hello World`) and branch `assignment-1`
contains a student-authentication app, not a counter. The feature set below was therefore derived
from the written specification only. Every listed feature is implemented; nothing was removed and no
undocumented feature (login, persistence, etc.) was invented.

---

## Technologies used

| Area | Choice |
|---|---|
| Framework | Flutter 3.47.2 (stable), Material 3 |
| Language | Dart 3.13.2 |
| Implementation A | `get` 4.7.3 |
| Implementation B | `flutter_riverpod` 2.6.1 (pinned to the **2.x** API generation) |
| Tests | `flutter_test`, `fake_async` 1.3.3 (dev only) |
| Lints | `flutter_lints` 6.0.0 |

No other dependencies were added.

> Riverpod is intentionally pinned with `^2.6.1`. Riverpod 3.x renamed/unified several APIs, so
> mixing generations would break the contract required by the assignment.

---

## Project structure

```text
lib/
├── main.dart                          # ProviderScope + GetMaterialApp entry point
├── home/
│   └── home_page.dart                 # Navigation to both implementations
├── getx/
│   ├── bindings/
│   │   └── counter_binding.dart       # Get.lazyPut dependency injection
│   ├── controllers/
│   │   └── counter_controller.dart    # GetxController + WidgetsBindingObserver
│   └── views/
│       └── counter_page.dart          # GetView + Obx
├── riverpod/
│   ├── controllers/
│   │   └── counter_notifier.dart      # CounterState + AutoDisposeNotifier
│   ├── providers/
│   │   └── counter_provider.dart      # NotifierProvider.autoDispose
│   └── views/
│       └── counter_page.dart          # ConsumerStatefulWidget + ConsumerWidget
└── shared/
    ├── models/
    │   └── timer_status.dart          # stopped / running / paused
    ├── theme/
    │   └── app_theme.dart             # Material 3 theme + accents
    ├── utils/
    │   ├── lifecycle_label.dart       # AppLifecycleState → label
    │   └── time_formatter.dart        # mm:ss / h:mm:ss
    └── widgets/
        └── counter_view.dart          # Stateless shared layout

test/
├── app_navigation_test.dart           # Home → GetX → Riverpod navigation
├── getx_counter_controller_test.dart  # GetX counter + timer + lifecycle
└── riverpod_counter_notifier_test.dart# Riverpod state + timer + disposal
```

Separation is strict:

- `shared/widgets/counter_view.dart` imports **neither** `get` **nor** `flutter_riverpod`.
- Each implementation owns its controller/state, its view and its own timer.
- `home/home_page.dart` is the only file that imports both views.

---

## How to run

```bash
flutter pub get
flutter run          # Windows desktop, Android emulator or Chrome
```

Quality gates:

```bash
flutter analyze
flutter test
```

From the home screen choose **GetX Counter** or **Riverpod Counter**. Both are fully functional on
their own.

---

## Functional behaviour (identical in both implementations)

### Counter controls

- Prominent current value, animated on every change (`AnimatedSwitcher`: fade + scale).
- **Increment** `+1`.
- **Decrement** `−1`, disabled and floored at `0` — the value can never go negative.
- **Reset** to `0`.
- Decrementing is disabled in the UI *and* guarded in the state layer (`if (counter > 0)`), so the
  rule holds even if an action is triggered programmatically.

### Timer

- One tick per second increments the counter **and** the elapsed time.
- **Start** (stopped → running), **Pause** (running → paused, values preserved),
  **Resume** (paused → running from the same values), **Stop** (cancels the timer, resets elapsed
  time and status; the counter value is kept).
- Buttons enable/disable from the current status; "Start" while paused resumes.
- Status pill shows **Running / Paused / Stopped**; elapsed time is shown as `mm:ss`
  (`h:mm:ss` past an hour).

### Application lifecycle

- Each implementation registers a `WidgetsBindingObserver` and displays the latest state
  (**Resumed / Inactive / Paused / Hidden / Detached**).
- On `paused`, `hidden` or `detached` a **running** timer is cancelled and the status becomes
  **Paused**; the counter and elapsed time are preserved.
- Returning to the foreground does **not** auto-restart the timer. A note explains that it was
  paused automatically and the user taps **Resume**. This makes the resume behaviour predictable and
  guarantees that returning to the app cannot create a second timer.
- `inactive` is displayed but does not pause (it also fires for transient interruptions such as the
  notification shade).

---

## GetX implementation

`lib/getx/controllers/counter_controller.dart`

```dart
class CounterController extends GetxController with WidgetsBindingObserver {
  final RxInt counter = 0.obs;
  final RxInt elapsedSeconds = 0.obs;
  final Rx<TimerStatus> timerStatus = TimerStatus.stopped.obs;
  final Rx<AppLifecycleState> lifecycleState = AppLifecycleState.resumed.obs;
  final RxBool pausedByLifecycle = false.obs;
  ...
}
```

- **Reactive state:** `RxInt`, `Rx<TimerStatus>`, `Rx<AppLifecycleState>` and `RxBool`. Getters such
  as `isRunning` derive from them instead of duplicating fields.
- **Reactive UI:** `GetxCounterPage extends GetView<CounterController>` wraps the screen in a single
  `Obx`. Reads inside that builder are tracked, so only this subtree rebuilds.
- **Dependency injection:** `CounterBinding extends Bindings` calls
  `Get.lazyPut<CounterController>(CounterController.new)`, attached to the route with
  `Get.to(() => const GetxCounterPage(), binding: CounterBinding())`.
- **Lifecycle:** `onInit` registers the observer and reads the current lifecycle state; `onClose`
  cancels the timer, removes the observer and calls `super.onClose()`. Because the binding is
  route-scoped, popping the screen deletes the controller, so the timer and observer never leak.
- **UI actions** are plain controller methods passed as callbacks; the view holds no business logic.

---

## Riverpod 2.x implementation

`lib/riverpod/controllers/counter_notifier.dart`

```dart
@immutable
class CounterState {
  final int counter;
  final int elapsedSeconds;
  final TimerStatus timerStatus;
  final AppLifecycleState lifecycleState;
  final bool pausedByLifecycle;
  CounterState copyWith({...});
}
```

- **Dedicated state class:** `CounterState` is immutable, every mutation goes through `copyWith` in
  the notifier, and `==`/`hashCode` are implemented so Riverpod only notifies on real changes.
- **Notifier (2.x API):** `class CounterNotifier extends AutoDisposeNotifier<CounterState>` with
  `build()` returning `const CounterState()`. No `StateNotifier`/`StateNotifierProvider` is mixed
  in — a single, modern 2.x style is used throughout.
- **Provider:** `NotifierProvider.autoDispose<CounterNotifier, CounterState>(CounterNotifier.new)` in
  `counter_provider.dart`. `autoDispose` ties the notifier to the screen: after the route is popped
  and no listener remains, the provider is disposed.
- **Reactive UI:** `_RiverpodCounterView extends ConsumerWidget` reads state with
  `ref.watch(counterProvider)` and sends actions with `ref.read(counterProvider.notifier)`.
- **Why a `ConsumerStatefulWidget` at all:** only to own the `WidgetsBindingObserver`
  (`initState` registers, `dispose` removes) and forward events to the notifier. The reactive tree
  itself is a `ConsumerWidget`.
- **Lifecycle of the provider:** `ref.onDispose(_cancelTimer)` inside `build()` cancels the periodic
  timer when the provider is disposed, and `_emit` ignores late writes after disposal.

---

## Comparison

| Feature | GetX | Riverpod |
|---|---|---|
| State management | `GetxController` | `StateNotifier` / `Notifier` (used: `AutoDisposeNotifier`) |
| Reactive updates | `Obx` | `ConsumerWidget` / `ref.watch` |
| State access | `Get.find` / controller | `ref.read` |
| Dependency management | `Get.put` / Bindings | Providers |
| Lifecycle management | `onInit` / `onClose` | Provider lifecycle / dispose |
| State shape | Mutable reactive fields (`RxInt`, `RxBool`, `Rx<T>`) | One immutable `CounterState` + `copyWith` |
| Where logic lives | Controller methods | Notifier methods |
| This project's disposal hook | Route-scoped binding → `onClose` | `autoDispose` → `ref.onDispose` |
| Boilerplate | Very low | Low, but explicit (state class, provider, consumer) |
| Compile-time safety | Reactive reads are runtime-tracked | Typed provider/state; missing scopes fail fast |
| Testability | Easy: instantiate/`Get.put` the controller | Easy: `ProviderContainer`, `fake_async` |

Practical summary: GetX is the shortest path — few files, mutable reactive fields, rebuilds tracked
at runtime. Riverpod costs a state class plus a provider, and in exchange gives explicit data flow,
immutable snapshots that are easy to compare/test, no reliance on ambient `Get.find`, and a
disposal contract that is local to the provider. Both reach the same behaviour and the same UI here.

---

## Timer management

Shared rules, implemented separately in each state layer:

1. **Single timer invariant** — `_startTicking()` always calls `_cancelTimer()` before
   `Timer.periodic(...)`, and `startTimer()` returns early when already running. Calling
   `start`/`start`/`resume` in a row still yields exactly one tick per second (covered by tests).
2. **No duplicate subscriptions** — `Resume` is only accepted from `paused`; `Pause` only from
   `running`; `Stop` is idempotent.
3. **No leaks** — the timer reference is nulled on cancel and the cancellation is wired into the
   framework's disposal: GetX `onClose` (route deletion) and Riverpod `ref.onDispose` (autoDispose).
4. **Pause preserves state, Stop resets timer state** — pause keeps counter and elapsed time; stop
   cancels and resets elapsed time plus status while keeping the counter.
5. **Tested on simulated time** — `fake_async` (Riverpod) and `tester.pump(Duration)` (GetX), so no
   test waits in real seconds.

---

## Application lifecycle handling

| State | Indicator | Timer effect |
|---|---|---|
| `resumed` | Resumed | none (no auto-resume) |
| `inactive` | Inactive | none — transient interruptions |
| `hidden` | Hidden | auto-pause if running |
| `paused` | Paused | auto-pause if running |
| `detached` | Detached | auto-pause if running |

- Observers are registered per implementation: GetX inside the controller (`onInit`/`onClose`),
  Riverpod inside the screen's `ConsumerState`, which is removed in `dispose`.
- The background auto-pause cancels the `Timer` rather than leaving it running, so the counter
  cannot advance while the app is not visible.
- The counter value and elapsed time survive the round trip; the status becomes **Paused** and an
  info banner explains why. A single `Resume` continues from exactly where it stopped — predictable
  and impossible to duplicate.
- `pausedByLifecycle` is cleared by the next manual timer action (start/pause/stop).

---

## Testing

Run `flutter test`. Current result: **22 tests passed**.

| # | Scenario | Where |
|---|---|---|
| 1 | Increment multiple times | both controller test suites |
| 2 | Decrement floored at zero | both controller test suites |
| 3 | Reset counter | both controller test suites |
| 4 | Start automatic timer (1 tick/s) | both timer suites |
| 5 | Pause and resume from previous values | both timer suites |
| 6 | Stop cancels and resets timer state | both timer suites |
| 7 | Navigate away and return (disposal, fresh state) | `app_navigation_test.dart`, disposal tests |
| 8 | Navigate GetX ↔ Riverpod (independent state) | `app_navigation_test.dart` |
| 9 | Background/foreground lifecycle + preserved counter | lifecycle tests (observer callbacks) |
| 10 | No duplicate timers on repeated start/resume | both timer suites |
| 11 | Resources disposed (timer cancelled, no pending timers) | disposal tests + `Get.delete`/`container.dispose` |

Covered automatically:

- Counter arithmetic and the zero floor.
- Timer tick counts for counter and elapsed time.
- Pause keeps values; resume continues; stop resets elapsed only.
- Repeated `start`/`resume` yields one tick per second.
- Background pause preserves the counter and does not auto-resume; `resumed` restores the indicator.
- `detached` also stops the timer.
- Riverpod state immutability/equality, `autoDispose` disposal cancels the timer, and a fresh
  container starts clean.
- Widget navigation across home → GetX → back → Riverpod, with independent values.

Not covered automatically (manual verification only): real device/emulator backgrounding (the tests
invoke the observer callbacks directly instead of driving the platform channel), and handset
rotation/responsiveness.

---

## Screenshots

Screenshots are not included; add them after the first run.

| Screen | Placeholder |
|---|---|
| Home (both options) | `docs/screenshots/home.png` |
| GetX counter | `docs/screenshots/getx-counter.png` |
| Riverpod counter | `docs/screenshots/riverpod-counter.png` |
| Timer running (both) | `docs/screenshots/timer-running.png` |
| Background → auto-paused note | `docs/screenshots/lifecycle-paused.png` |

```markdown
![Home](docs/screenshots/home.png)
![GetX](docs/screenshots/getx-counter.png)
![Riverpod](docs/screenshots/riverpod-counter.png)
```

---

## GitHub submission

- Source for both implementations, `pubspec.yaml`/`pubspec.lock`, tests and this README are included.
- `.gitignore` excludes `build/`, `.dart_tool/`, IDE files (`.idea/`, `*.iml`) and generated
  artifacts.
- No secrets, API keys or machine-specific paths are stored in the project.
- Suggested commands:

```bash
git add .
git commit -m "feat: implement interactive counter with GetX and Riverpod 2.x"
git push origin assignment-2
```
