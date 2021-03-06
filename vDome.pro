TEMPLATE = app

QT += qml quick
QT += multimedia

SOURCES += main.cpp \
    playlist.cpp \
    syscmds.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)
include(osc/osc.pri)

HEADERS += \
    playlist.h \
    syscmds.h

OTHER_FILES +=

CONFIG += static
