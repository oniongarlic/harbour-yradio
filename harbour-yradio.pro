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

SOURCES += src/harbour-yradio.cpp

OTHER_FILES += qml/harbour-yradio.qml \
    qml/cover/CoverPage.qml \
    rpm/harbour-yradio.spec \
    rpm/harbour-yradio.yaml \
    harbour-yradio.desktop \
    qml/pages/MainPage.qml \
    qml/pages/AboutPage.qml \
    qml/pages/SettingsPage.qml \
    qml/RadioPlayer.qml \
    qml/ChannelsModel.qml \
    qml/yle.xml

