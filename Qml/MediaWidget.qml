import QtQuick 2.0
import QtGraphicalEffects 1.0

MouseArea {
    id: root
    property string _title
    property string _singer
    property string _src
    property bool isFocusing: false;

    function onSongChanged(t, s, sr){
        _title = t
        _singer = s
        _src = "qrc:/App/Media/"+sr
    }

    function onProgressChanged(pro){
        imgPosition.width = pro * imgDuration.width
    }

    Component.onCompleted: {
        mController.songChanged.connect(onSongChanged)
        mController.progressChanged.connect(onProgressChanged)
    }

    implicitWidth: 635 * appConfig.w_ratio
    implicitHeight: 570 * appConfig.h_ratio
    drag.target: parent

    Rectangle {
        anchors{
            fill: parent
        }
        opacity: 0.1
        color: "#111419"
    }
    Image {
        id: bgBlur
        x:10 * appConfig.w_ratio
        y:10 * appConfig.h_ratio
        width: 615 * appConfig.w_ratio
        height: 550 * appConfig.h_ratio
        source: _src
    }
    FastBlur {
        anchors.fill: bgBlur
        source: bgBlur
        radius: 18
    }
    Image {
        id: idBackgroud
        source: ""
        width: root.width
        height: root.height
    }
    Text {
        id: title
        anchors.horizontalCenter: parent.horizontalCenter
        y: 40 * appConfig.h_ratio
        text: "USB Music"
        color: "white"
        font.pixelSize: 34 * appConfig.h_ratio
    }
    Image {
        id: bgInner
        x:201 * appConfig.w_ratio
        y:119 * appConfig.h_ratio
        width: 258 * appConfig.w_ratio
        height: 258 * appConfig.h_ratio
        source: _src
    }
    Image{
        x:201 * appConfig.w_ratio
        y:119 * appConfig.h_ratio
        width: 258 * appConfig.w_ratio
        height: 258 * appConfig.h_ratio
        source: "qrc:/Img/HomeScreen/widget_media_album_bg.png"
    }
    Text {
        id: txtSinger
        x: 42 * appConfig.w_ratio
        y: (56+343) * appConfig.h_ratio
        width: 551 * appConfig.w_ratio
        horizontalAlignment: Text.AlignHCenter
        text: _singer
        color: "white"
        font.pixelSize: 30 * appConfig.h_ratio
    }
    Text {
        id: txtTitle
        x: 42 * appConfig.w_ratio
        y: (56+343+55) * appConfig.h_ratio
        width: 551 * appConfig.w_ratio
        horizontalAlignment: Text.AlignHCenter
        text: _title
        color: "white"
        font.pixelSize: 48 * appConfig.h_ratio
    }
    Image{
        id: imgDuration
        x: 62 * appConfig.w_ratio
        y: (56+343+55+62) * appConfig.h_ratio
        width: 511 * appConfig.w_ratio
        height: 6 * appConfig.h_ratio
        source: "qrc:/Img/HomeScreen/widget_media_pg_n.png"
    }
    Image{
        id: imgPosition
        x: 62 * appConfig.w_ratio
        y: (56+343+55+62) * appConfig.h_ratio
        width: 0
        height: 6 * appConfig.h_ratio
        source: "qrc:/Img/HomeScreen/widget_media_pg_s.png"
    }

    states: [
        State {
            name: "Focus"
            PropertyChanges {
                target: idBackgroud
                source: "qrc:/Img/HomeScreen/bg_widget_f.png"
            }
        },
        State {
            name: "Pressed"
            PropertyChanges {
                target: idBackgroud
                source: "qrc:/Img/HomeScreen/bg_widget_p.png"
            }
        },
        State {
            name: "Normal"
            PropertyChanges {
                target: idBackgroud
                source: ""
            }
        }
    ]
    onPressed: root.state = "Pressed"
    onReleased:{
        if (!root.isFocusing) root.state = "Normal"
        else root.state = "Focus"
    }
    onIsFocusingChanged: {
        if (root.isFocusing) root.state = "Focus"
        else root.state = "Normal"
    }
}
