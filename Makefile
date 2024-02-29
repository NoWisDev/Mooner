TARGET := iphone:clang:15.6:15.0
ARCHS = arm64 arm64e
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Mooner

Mooner_FILES = $(shell find Sources/Mooner -name '*.swift') $(shell find Sources/MoonerC -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
Mooner_SWIFTFLAGS = -ISources/MoonerC/include
Mooner_CFLAGS = -fobjc-arc -ISources/MoonerC/include

include $(THEOS_MAKE_PATH)/tweak.mk
