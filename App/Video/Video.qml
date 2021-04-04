import QtQuick 2.11
import QtQuick.Controls 2.4

Item {
    id: root
    width: 1920 * appConfig.w_ratio
    height: (1200-104) * appConfig.h_ratio
    Rectangle{
        width: parent.width
        height: 70
        color: "#2B2937"
        Text {
            text: qsTr("Video")
            anchors.centerIn: parent
            font.pointSize: 17
            color: "white"
        }
    }
}
