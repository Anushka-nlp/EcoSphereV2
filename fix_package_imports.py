import os

frontend_dir = r"c:\echosphere v2.2\frontend"

# 1. Update pubspec.yaml
pubspec_path = os.path.join(frontend_dir, "pubspec.yaml")
with open(pubspec_path, 'r', encoding='utf-8') as f:
    pubspec = f.read()

pubspec = pubspec.replace("name: echosphere", "name: anymex")
pubspec = pubspec.replace("echosphere_extension_runtime_bridge:", "anymex_extension_runtime_bridge:")
pubspec = pubspec.replace("url: https://github.com/RyanYuuki/EchoSphereExtensionRuntimeBridge.git", "url: https://github.com/RyanYuuki/AnymeXExtensionRuntimeBridge.git")

with open(pubspec_path, 'w', encoding='utf-8') as f:
    f.write(pubspec)

# 2. Fix package imports in lib/ and files
for root, dirs, files in os.walk(os.path.join(frontend_dir, "lib")):
    for f in files:
        if f.endswith(".dart"):
            fp = os.path.join(root, f)
            with open(fp, 'r', encoding='utf-8', errors='ignore') as file:
                content = file.read()
            
            # Restore package imports
            new_content = content.replace("package:echosphere/", "package:anymex/")
            new_content = new_content.replace("package:echosphere_extension_runtime_bridge/", "package:anymex_extension_runtime_bridge/")
            new_content = new_content.replace("Anymex", "EchoSphere")
            new_content = new_content.replace("AnymeX", "EchoSphere")

            if new_content != content:
                with open(fp, 'w', encoding='utf-8') as file:
                    file.write(new_content)

print("Package imports restored to package:anymex/ while keeping EchoSphere branding!")
