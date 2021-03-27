import QtQuick 2.14
import MyMedia 1.0

Rectangle {
    id: root
    property bool statusList: false
    property int total: selectLanguage.count

    signal collapse(status: bool)

    width: parent.width
    height: 70
    color: "#2B2937"
    MouseArea {
        id: controlPlaylist
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 12
        width: icPlayList.width + txtPlaylist.width
        height: 20
        Image {
            id: icPlayList
            width: 20
            height: 20
            source: "Image/drawer.png"
            anchors.margins: 30
        }
        Text {
            id: txtPlaylist
            text: qsTr("Playlist") + myTrans.emptyString
            //font.family: "Trebuchet MS"
            anchors.left: icPlayList.right
            anchors.leftMargin: 5
            font.pointSize: 13
            color: "white"
        }
        onClicked: {
            statusList = !statusList
            collapse(statusList)
            if (statusList) icPlayList.source = "Image/back.png"
            else icPlayList.source = "Image/drawer.png"
        }
    }
    Text {
        text: qsTr("Media Player") + myTrans.emptyString
        //font.family: "Trebuchet MS"
        anchors.centerIn: parent
        font.pointSize: 17
        color: "white"
    }

    ListView {
        id: selectLanguage
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 10
        orientation: ListView.Horizontal
        width: total*24 + (total>1?total-1:0)*5
        height: 20
        spacing: 5
        interactive: false
        model: LangListModel{
            langs: langList
        }

        highlight: Rectangle {
            border.color: "#49ff0d"
            border.width: 2
            color: "#00000000"
            z : 5
        }

        delegate: Image {
            id: item
            width: 24
            height: parent.height
            source: src
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    selectLanguage.currentIndex = index
                    myTrans.updateLanguage(code)
                }
            }
        }
    }
}
