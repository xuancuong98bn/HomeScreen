import QtQuick 2.0

MouseArea {
    id: root
    implicitWidth: 316 * appConfig.w_ratio
    implicitHeight: 604 * appConfig.h_ratio
    property string icon
    property string title
    property bool isFocusing: false;
    Image {
        id: idBackgroud
        width: root.width
        height: root.height
        source: icon + "_n.png"
    }
    Text {
        id: appTitle
        anchors.horizontalCenter: parent.horizontalCenter
        y: 350 * appConfig.h_ratio
        text: title
        font.pixelSize: 36 * appConfig.h_ratio
        color: "white"
    }

    states: [
        State {
            name: "Focus"
            PropertyChanges {
                target: idBackgroud
                source: icon + "_f.png"
            }
        },
        State {
            name: "Pressed"
            PropertyChanges {
                target: idBackgroud
                source: icon + "_p.png"
            }
        },
        State {
            name: "Normal"
            PropertyChanges {
                target: idBackgroud
                source: icon + "_n.png"
            }
        }
    ]

    onPressed: root.state = "Pressed"
    onReleased: {
        if (root.isFocusing) root.state = "Focus"
        else root.state = "Normal"
    }
    onIsFocusingChanged:{
        if (root.isFocusing) root.state = "Focus"
        else root.state = "Normal"
    }
}
