import QtQuick 2.0
import QtGraphicalEffects 1.0

MouseArea {
    id: root
    implicitWidth: 635 * appConfig.w_ratio
    implicitHeight: 570 * appConfig.h_ratio
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
        source: {
            if (myModel.rowCount() > 0 && myModel.rowCount() >  player.playlist.currentIndex)
                return myModel.data(myModel.index(player.playlist.currentIndex,0), 260)
            else
                return "qrc:/Img/HomeScreen/cover_art.jpg"
        }
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
        source: {
            if (myModel.rowCount() > 0 && myModel.rowCount() >  player.playlist.currentIndex)
                return myModel.data(myModel.index(player.playlist.currentIndex,0), 260)
            else
                return "qrc:/Img/HomeScreen/cover_art.jpg"
        }
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
        text: {
            if (myModel.rowCount() > 0 && myModel.rowCount() >  player.playlist.currentIndex)
                return myModel.data(myModel.index(player.playlist.currentIndex,0), 258)
        }
        color: "white"
        font.pixelSize: 30 * appConfig.h_ratio
    }
    Text {
        id: txtTitle
        x: 42 * appConfig.w_ratio
        y: (56+343+55) * appConfig.h_ratio
        width: 551 * appConfig.w_ratio
        horizontalAlignment: Text.AlignHCenter
        text: {
            if (myModel.rowCount() > 0 && myModel.rowCount() >  player.playlist.currentIndex)
                return myModel.data(myModel.index(player.playlist.currentIndex,0), 257)
        }
        color: "white"
        font.pixelSize: 48 * appConfig.h_ratio
    }
    Image{
        id: imgDuration
        x: 62 * appConfig.w_ratio
        y: (56+343+55+62) * appConfig.h_ratio
        width: 511 * appConfig.w_ratio
        source: "qrc:/Img/HomeScreen/widget_media_pg_n.png"
    }
    Image{
        id: imgPosition
        x: 62 * appConfig.w_ratio
        y: (56+343+55+62) * appConfig.h_ratio
        width: 0
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
        root.focus = true
        root.state = "Focus"
    }
    onFocusChanged: {
        if (root.focus == true )
            root.state = "Focus"
        else
            root.state = "Normal"
    }

    Connections{
        target: player.playlist
        onCurrentIndexChanged:{
            if (myModel.rowCount() > 0 && myModel.rowCount() >  player.playlist.currentIndex) {
                bgBlur.source = myModel.data(myModel.index(player.playlist.currentIndex,0), 260)
                bgInner.source = myModel.data(myModel.index(player.playlist.currentIndex,0), 260)
                txtSinger.text = myModel.data(myModel.index(player.playlist.currentIndex,0), 258)
                txtTitle.text = myModel.data(myModel.index(player.playlist.currentIndex,0), 257)
            }
        }
    }

    Connections{
        target: player
        onDurationChanged:{
            imgDuration.width = 511 * appConfig.w_ratio
        }
        onPositionChanged: {
            imgPosition.width = (player.position / player.duration)*(511 * appConfig.w_ratio);
        }
    }
}
