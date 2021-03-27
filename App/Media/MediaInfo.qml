import QtQuick 2.14

Item {
    id: root

    property string title
    property string singer
    property int amount

    width: parent.width
    height: 50

    onTitleChanged: {
        changeAnim.start()
    }

    Item {
        id: info
        width: parent.width*0.8
        height: parent.height
        Rectangle{
            id: mTitle
            width: parent.width
            height: textmTitle.implicitHeight
            color: "#00000000"
            Text {
                id: textmTitle
                text: title
                width: parent.width
                wrapMode: Text.Wrap
                color: "white"
                leftPadding: 10
                font.pointSize: 14
            }
        }

        Rectangle{
            id: mSinger
            width: parent.width
            height: textmSinger.implicitHeight
            color: "#00000000"
            anchors.top: mTitle.bottom
            Text {
                id: textmSinger
                text: singer
                color: "white"
                leftPadding: 10
                font.pointSize: 12
            }

        }
        NumberAnimation {
            id: changeAnim
            targets: [textmSinger,textmTitle]
            properties: "opacity"
            from:0.0
            to:1.0
            duration: 1000
        }
    }

    Image{
        id: imgMusic
        source: "Image/music.png"
        anchors.right: txtAmount.left
        width: 20
        height: 20
    }

    Rectangle{
        id: txtAmount
        width: 25
        height: 20
        color: "#00000000"
        anchors.right: root.right
        Text {
            text: amount
            color: "white"
            font.pointSize: 13
            anchors.centerIn: parent
        }
    }
}
