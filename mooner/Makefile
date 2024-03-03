TARGET := iphone:clang:15.6:15.0
ARCHS = arm64 arm64e
include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = mooner

mooner_FILES = $(shell find Sources/mooner -name '*.swift') $(shell find Sources/moonerC -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
mooner_SWIFTFLAGS = -ISources/moonerC/include
mooner_INSTALL_PATH = /Library/PreferenceBundles
mooner_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
