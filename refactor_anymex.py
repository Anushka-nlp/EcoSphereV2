import os
import re

frontend_dir = r"c:\echosphere v2.2\frontend"

# 1. Rename files starting with anymex_
for root, dirs, files in os.walk(frontend_dir):
    for f in files:
        if f.startswith("anymex_"):
            old_path = os.path.join(root, f)
            new_f = f.replace("anymex_", "echosphere_")
            new_path = os.path.join(root, new_f)
            os.rename(old_path, new_path)
            print(f"Renamed file: {f} -> {new_f}")

# 2. Text replacements across all files in frontend/lib and pubspec.yaml
file_extensions = ('.dart', '.yaml', '.json', '.txt', '.md', '.kt', '.java', '.cc', '.h', '.cpp', '.gradle')

for root, dirs, files in os.walk(frontend_dir):
    for f in files:
        if f.endswith(file_extensions):
            file_path = os.path.join(root, f)
            try:
                with open(file_path, 'r', encoding='utf-8', errors='ignore') as fp:
                    content = fp.read()

                new_content = content
                # Imports
                new_content = new_content.replace("package:anymex/", "package:echosphere/")
                # File imports
                new_content = new_content.replace("anymex_", "echosphere_")
                # Class / Identifier names
                new_content = new_content.replace("AnymeX", "EchoSphere")
                new_content = new_content.replace("anymex", "echosphere")
                new_content = new_content.replace("ANYMEX", "ECHOSPHERE")

                if new_content != content:
                    with open(file_path, 'w', encoding='utf-8') as fp:
                        fp.write(new_content)
                    print(f"Refactored: {file_path}")
            except Exception as e:
                print(f"Error processing {file_path}: {e}")

print("\nRefactoring script executed successfully!")
