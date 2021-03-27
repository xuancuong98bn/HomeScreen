import QtQuick 2.14

MouseArea {
    id: root

    property string icon_default
    property string icon_pressed
    property string icon_released
    property alias cHeight: root.height

    width: 60
    height: 30
    anchors.verticalCenter: parent.verticalCenter

    Image {
        id: img
        width: parent.width
        height: parent.height
        source: icon_default
    }
    onPressed: {
        img.source = icon_pressed
    }
    onReleased: {
        img.source = icon_released
    }
}
