# 基础配置
FLUTTER := flutter
# 默认构建模式为 debug，可以通过 BUILD_MODE=release make build-android 修改
BUILD_MODE ?= debug

# 帮助信息
.PHONY: help clean test build-all

help:
	@echo "Usage: make <target>"
	@echo ""
	@echo "Build targets (构建目标):"
	@echo "  build-android    Build Android APK"
	@echo "  build-ios        Build iOS bundle"
	@echo "  build-web        Build Web app"
	@echo "  build-windows     Build Windows executable"
	@echo "  build-macos       Build macOS app"
	@echo "  build-linux        Build Linux executable"
	@echo "  build-all         Build for all supported platforms"
	@echo ""
	@echo "Run targets (运行目标):"
	@echo "  run-android       Run on Android device/emulator"
	@echo "  run-ios           Run on iOS simulator/device"
	@echo "  run-web           Run on Web (Chrome)"
	@echo "  run-windows        Run on Windows"
	@echo "  run-macos         Run on macOS"
	@echo "  run-linux         Run on Linux"
	@echo ""
	@echo "Maintenance (维护):"
	@echo "  clean             Clean Flutter build artifacts"
	@echo "  test              Run Flutter tests"

# 通用命令
clean:
	$(FLUTTER) clean

test:
	$(FLUTTER) test

build-all: build-android build-ios build-web build-windows build-macos build-linux

# --- Build Commands ---

build-android:
	$(FLUTTER) build apk --release

build-ios:
	$(FLUTTER) build ios --release

build-web:
	$(FLUTTER) build web --release

build-windows:
	$(FLUTTER) build windows --release

build-macos:
	$(FLUTTER) build macos --release

build-linux:
	$(FLUTTER) build linux --release

# --- Run Commands ---

run-android:
	$(FLUTTER) run -d android

run-ios:
	$(FLUTTER) run -d ios

run-web: build-web
	$(FLUTTER) run -d chrome

run-windows:
	$(FLUTTER) run -d windows

run-macos:
	$(FLUTTER) run -d macos

run-linux: build-linux
	$(FLUTTER) run -d linux
