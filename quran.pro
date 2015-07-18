TEMPLATE = app

QT += quick qml
QT += sql
SOURCES += main.cpp \
    downloader.cpp
RESOURCES += quran.qrc

target.path = $$[QT_INSTALL_EXAMPLES]/quick/quran
INSTALLS += target

HEADERS += \
    downloader.h

DISTFILES += \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/AndroidManifest.xml \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew \
    android/gradlew.bat \
    android/res/drawable/scaledbackground.xml

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
