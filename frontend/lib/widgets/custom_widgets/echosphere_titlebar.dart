import 'dart:io';

import 'package:anymex/widgets/custom_widgets/echosphere_animated_logo.dart';
import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:anymex/utils/theme_extensions.dart';
import 'package:anymex/controllers/theme.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:win32/win32.dart';
import 'dart:ffi';
// import 'package:anymex_extension_runtime_bridge/anymex_extension_runtime_bridge.dart' hide isar;

class EchoSphereTitleBar {
  static final ValueNotifier<bool> isFullScreen = ValueNotifier(false);
  static final ValueNotifier<bool> isMaximized = ValueNotifier(false);

  static Future<void> initialize() async {
    if (!Platform.isWindows) {
      await windowManager.waitUntilReadyToShow(
        const WindowOptions(
          backgroundColor: null,
          titleBarStyle: TitleBarStyle.normal,
          skipTaskbar: null,
        ),
      );
      await windowManager.setPreventClose(true);
      windowManager.addListener(_WindowListener());
      return;
    }

    const windowOptions = WindowOptions(
      backgroundColor: null,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();

      EchoSphereTitleBar.isMaximized.value = await windowManager.isMaximized();
      await windowManager.setPreventClose(true);
      windowManager.addListener(_WindowListener());
    });
  }

  static void listenToWin32() {
    final hwnd = GetForegroundWindow();

    final placement = calloc<WINDOWPLACEMENT>();
    GetWindowPlacement(hwnd, placement);

    final isMaximized = placement.ref.showCmd == SW_SHOWMAXIMIZED;
    EchoSphereTitleBar.isMaximized.value = isMaximized;

    calloc.free(placement);
  }

  static Widget titleBar() => ValueListenableBuilder<bool>(
        valueListenable: isFullScreen,
        builder: (_, fullscreen, __) {
          return fullscreen ? const SizedBox.shrink() : const _TitleBarWidget();
        },
      );

  static Future<void> setFullScreen(bool enable) async {
    await windowManager.setFullScreen(enable);
    isFullScreen.value = enable;
  }

  static Future<void> toggleFullScreen() async {
    await windowManager.setFullScreen(!isFullScreen.value);
    isFullScreen.value = !isFullScreen.value;
  }
}

class _WindowListener extends WindowListener {
  Future<void> _sync() async {
    EchoSphereTitleBar.isMaximized.value = await windowManager.isMaximized();
  }

  @override
  void onWindowMaximize() => _sync();

  @override
  void onWindowUnmaximize() => _sync();

  @override
  void onWindowResized() async {
    if (Platform.isWindows) {
      EchoSphereTitleBar.listenToWin32();
    }
  }

  @override
  void onWindowClose() async {
    try {
      // AnymexExtensionBridge.dispose();
    } catch (e) {
      debugPrint('Error disposing AnymexExtensionBridge: $e');
    }
    try {
      // await TorrentStreamResolver.dispose();
    } catch (e) {
      debugPrint('Error disposing TorrentStreamResolver: $e');
    }
    await windowManager.destroy();
  }
}

class _TitleBarWidget extends StatelessWidget {
  const _TitleBarWidget();

  Future<void> _toggleMaximize() async {
    final maximized = await windowManager.isMaximized();
    if (maximized) {
      await windowManager.unmaximize();
    } else {
      await windowManager.maximize();
    }

    EchoSphereTitleBar.isMaximized.value = await windowManager.isMaximized();
  }

  @override
  Widget build(BuildContext context) {
    final isOled = Provider.of<ThemeProvider>(context).isOled;
    final defaultColor = context.colors.onSurface;

    return RepaintBoundary(
        child: Material(
      color: Colors.transparent,
      child: ClipRect(
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: isOled ? Colors.black : Colors.black.opaque(0.2),
            border: Border(
              bottom: BorderSide(
                color: isOled ? Colors.transparent : defaultColor.opaque(0.1),
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: defaultColor.opaque(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const EchoSphereAnimatedLogo(
                  size: 15,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'EchoSphere',
                style: TextStyle(
                  color: defaultColor,
                  fontSize: 12,
                  fontFamily: 'Poppins-Bold',
                ),
              ),
              const Expanded(
                child: DragToMoveArea(
                  child: SizedBox(
                    height: double.infinity,
                  ),
                ),
              ),
              ValueListenableBuilder(
                  valueListenable: EchoSphereTitleBar.isMaximized,
                  builder: (context, val, _) {
                    return IconButton(
                      onPressed: _toggleMaximize,
                      icon: Icon(
                        val ? Icons.copy_rounded : Icons.crop_square_rounded,
                        color: defaultColor,
                        size: 16,
                      ),
                    );
                  }),
              IconButton(
                onPressed: () async {
                  await windowManager.minimize();
                },
                icon: Icon(
                  Icons.horizontal_rule_rounded,
                  color: defaultColor,
                  size: 16,
                ),
              ),
              IconButton(
                onPressed: () async {
                  await windowManager.close();
                },
                icon: Icon(
                  Icons.close_rounded,
                  color: defaultColor,
                  size: 16,
                ),
              ),
              const SizedBox(width: 5),
            ],
          ),
        ),
      ),
    ));
  }
}
