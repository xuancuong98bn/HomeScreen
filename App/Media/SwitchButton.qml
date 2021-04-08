import QtQuick 2.14

MouseArea {
    id: root

    property string icon_on
    property string icon_off
    property bool status: false //0-Off 1-On

    function changeStatus(toStatus){
        status = toStatus
    }

    width: 60
    height: 30
    anchors.verticalCenter: parent.verticalCenter

    Image {
        id: img
        source: root.status ? icon_on : icon_off
        width: parent.width
        height: parent.height
    }
    onClicked: {
        root.status = !root.status
    }

}
