import QtQuick 2.11
import QtQuick.Layouts 1.11
import "Common"
import QtQml 2.2

Item {
    property bool isShowBackBtn: false
    signal bntBackClicked

    width: 1920 * appConfig.w_ratio
    height: 104 * appConfig.h_ratio

    Button {
        anchors.left: parent.left
        icon: "qrc:/Img/StatusBar/btn_top_back"
        width: 135 * appConfig.w_ratio
        height: 104 * appConfig.h_ratio
        iconWidth: width
        iconHeight: height
        onClicked: bntBackClicked()
        visible: isShowBackBtn
    }

    Item {
        id: clockArea
        x: 660 * appConfig.w_ratio
        width: 300 * appConfig.w_ratio
        height: parent.height
        Image {
            anchors.left: parent.left
            height: 104 * appConfig.h_ratio
            source: "qrc:/Img/StatusBar/status_divider.png"
        }
        Text {
            id: clockTime
            text: "10:28"
            color: "white"
            font.pixelSize: 72 * appConfig.h_ratio
            anchors.centerIn: parent
        }
        Image {
            anchors.right: parent.right
            height: 104 * appConfig.h_ratio
            source: "qrc:/Img/StatusBar/status_divider.png"
        }
    }
    Item {
        id: dayArea
        anchors.left: clockArea.right
        width: 300 * appConfig.w_ratio
        height: parent.height
        Text {
            id: day
            text: "Jun. 24"
            color: "white"
            font.pixelSize: 72 * appConfig.h_ratio
            anchors.centerIn: parent
        }
        Image {
            anchors.right: parent.right
            height: 104 * appConfig.h_ratio
            source: "qrc:/Img/StatusBar/status_divider.png"
        }
    }

    QtObject {
        id: time
        property var locale: Qt.locale()
        property date currentTime: new Date()

        Component.onCompleted: {
            clockTime.text = currentTime.toLocaleTimeString(locale, "hh:mm");
            day.text = currentTime.toLocaleDateString(locale, "MMM. dd");
        }
    }

    Timer{
        interval: 1000
        repeat: true
        running: true
        onTriggered: {
            time.currentTime = new Date()
            clockTime.text = time.currentTime.toLocaleTimeString(locale, "hh:mm");
            day.text = time.currentTime.toLocaleDateString(locale, "MMM. dd");
        }
    }
}
