# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-trafficviewer

CONFIG += sailfishapp

SOURCES += src/harbour-trafficviewer.cpp

OTHER_FILES += qml/harbour-trafficviewer.qml \
    qml/cover/CoverPage.qml \
    rpm/harbour-trafficviewer.spec \
    rpm/harbour-trafficviewer.yaml \
    translations/*.ts \
    harbour-trafficviewer.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 256x256

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/harbour-trafficviewer-de.ts \
                translations/harbour-trafficviewer-fi.ts


DISTFILES += \
    qml/pages/Settings.qml \
    qml/pages/LamList.qml \
    rpm/harbour-trafficviewer.changes \
    qml/pages/MapPage.qml \
    qml/pages/DrawData.qml \
    qml/components/LinePlot.qml \
    qml/pages/tables.js \
    qml/data/lamstations.xml \
    qml/data/lamData.xml \
    qml/pages/LocList.qml \
    qml/pages/Help.qml \
    qml/pages/About.qml \
    qml/pages/Search.qml \
    qml/components/setting.js \
    qml/pages/Search2.qml

