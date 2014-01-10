# The name of your app.
# NOTICE: name defined in TARGET has a corresponding QML filename.
#         If name defined in TARGET is changed, following needs to be
#         done to match new name:
#         - corresponding QML filename must be changed
#         - desktop icon filename must be changed
#         - desktop filename must be changed
#         - icon definition filename in desktop file must be changed
TARGET = harbour-yradio

CONFIG += sailfishapp

SOURCES += src/harbour-yradio.cpp src/settings.cpp

HEADERS += src/settings.h

OTHER_FILES += qml/*.qml \
    qml/cover/*.qml \
    qml/pages/*.qml \
    qml/yle.xml \
    qml/*.js \
    rpm/harbour-yradio.spec \
    rpm/harbour-yradio.yaml \
    harbour-yradio.desktop

