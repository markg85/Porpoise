# Add more folders to ship with the application, here
folder_01.source = qml/Porpoise
folder_01.target = qml
DEPLOYMENTFOLDERS = folder_01

# Additional import path used to resolve QML modules in Creator's code model
# QML_IMPORT_PATH = /usr/lib/kde4/imports

symbian:TARGET.UID3 = 0xE6C1FAF8

# Smart Installer package's UID
# This UID is from the protected range and therefore the package will
# fail to install if self-signed. By default qmake uses the unprotected
# range value if unprotected UID is defined for the application and
# 0x2002CCCF value if protected UID is given to the application
#symbian:DEPLOYMENT.installer_header = 0x2002CCCF

# Allow network access on Symbian
symbian:TARGET.CAPABILITY += NetworkServices

# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
# CONFIG += mobility
# MOBILITY +=

# Speed up launching on MeeGo/Harmattan when using applauncherd daemon
# CONFIG += qdeclarative-boostable

# Add dependency to Symbian components
# CONFIG += qt-components

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    kurlwrapper.cpp \
    pathmodel.cpp \
    util.cpp \
    kcompletionwrapper.cpp \
    dirmodel.cpp \
    kgraphicsitem.cpp \
    kurlundoredo.cpp \
    shortcut.cpp \
    clipboard.cpp \
    CNaturalString.inl \
    CNaturalString.cpp

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()

QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

LIBS += -lkdecore -lkio -lkdeui
INCLUDEPATH += /usr/include/KDE

HEADERS += \
    kurlwrapper.h \
    pathmodel.h \
    util.h \
    kcompletionwrapper.h \
    dirmodel.h \
    fileitem.h \
    kgraphicsitem.h \
    kurlundoredo.h \
    shortcut.h \
    clipboard.h \
    CNaturalString.h \
    mimeimageprovider.h \
    thumbimageprovider.h

OTHER_FILES += \
    qml/Porpoise/colorstyles/porpoise.js
