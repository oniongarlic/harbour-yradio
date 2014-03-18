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

SOURCES += src/harbour-yradio.cpp src/settings.cpp src/FileDownloader.cpp src/DateUtils.cpp

HEADERS += src/settings.h src/FileDownloader.hpp src/DateUtils.h

# lupdate src/*.{cpp,h} qml/*.{qml,js} -ts nls/*.ts

CODECFORTR = UTF-8
TRANSLATIONS += \
    nls/yradio.en.ts \
    nls/yradio.sv.ts \
    nls/yradio.fi.ts

updateqm.input = TRANSLATIONS
updateqm.output = ${QMAKE_FILE_PATH}/${QMAKE_FILE_BASE}.qm
updateqm.commands = lrelease ${QMAKE_FILE_IN} -qm ${QMAKE_FILE_OUT}
updateqm.CONFIG += no_link
QMAKE_EXTRA_COMPILERS += updateqm
PRE_TARGETDEPS += compiler_updateqm_make_all

OTHER_FILES += qml/*.qml \
    qml/cover/*.qml \
    qml/pages/*.qml \
    qml/models/*.qml \
    qml/yle.xml \
    qml/*.js \
    qml/models/FavoritesModel.qml \
    qml/pages/SongsPage.qml \
    qml/PlayerDbusInterface.qml \
    qml/Song.qml \
    qml/Program.qml \
    qml/ArtistImage.qml


RESOURCES += \
    nls.qrc

