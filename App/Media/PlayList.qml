import QtQuick 2.14
import QtQuick.Controls 2.14

ListView{
    id: root
    property alias model: root.model
    property int holdIndex

    anchors.fill: parent
    spacing: 1
    clip: true
    contentHeight: parent.height

    highlight: Rectangle {
        id: hl
        width: parent.width
        height: 100
        color: "#45000000"
    }

    delegate: Rectangle {
        id: item
        width: parent.width
        height: 100
        color: "#25000000"
        property bool pref: false

        Image {
            id: imgHold
            source: "Image/hold.png"
            width: parent.width
            height: 100
            visible: pref
        }

        Image{
            id: imgPlaying
            source: "Image/playing.png"
            width: 19
            height: 17
            anchors.left: item.left
            anchors.margins: 9
            anchors.verticalCenter: parent.verticalCenter
            visible: currentIndex === index
        }

        Text {
            id: itemtext
            text: title
            width: parent.width
            wrapMode: Text.Wrap
            font.family: "Trebuchet MS"
            color: "white"
            font.pointSize: 13
            anchors.left: imgPlaying.right
            padding: 10
            anchors.verticalCenter: parent.verticalCenter
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                mController.setCurrentIndex(index)
            }
            onPressed: {
                pref = true
                holdIndex = index
            }
            onReleased: {
                pref = false
            }
        }
    }

    onDragEnded:{
        root.itemAtIndex(holdIndex).pref = false
    }

    ScrollBar.vertical: ScrollBar{}
}
