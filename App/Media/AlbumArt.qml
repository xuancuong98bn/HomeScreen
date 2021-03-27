import QtQuick 2.14

PathView{
    id: root
    property alias model: root.model
    property int currentSong //use to move center art after art move
    property int defaultSize: 130
    property double ratio: 1.5
    property int spacing: defaultSize/2 + defaultSize*ratio/2 + 15//space

    width: parent.width
    height: parent.height*0.4
    pathItemCount: 3

    onMovementEnded: {
        clock.running = true
    }

    delegate: Image{
        id: item
        width: defaultSize
        height: this.width
        source: model.art
        scale: parseFloat(PathView.iconScale)
        MouseArea{
            anchors.fill: parent
            onClicked: {
                mController.setCurrentIndex(index)
            }
        }
    }
    path: Path{
        startX: root.x + width/2 - spacing; startY: root.y+root.height/3.5
        PathAttribute { name: "iconScale"; value: 1 }
        PathLine { relativeX: spacing; y:  root.y+root.height/3.5}
        PathAttribute { name: "iconScale"; value: ratio }
        PathLine { relativeX: spacing; y:  root.y+root.height/3.5}
        PathAttribute { name: "iconScale"; value: 1 }
        PathLine { x: root.x + width/2 + spacing*2 ; y:  root.y+root.height/3.5}
        PathAttribute { name: "iconScale"; value: 0.1 }
    }


    Timer{
        id: clock
        interval: 3000
        repeat: true
        running: false

        onTriggered: {
            positionViewAtIndex(currentSong, PathView.Center)
            running = false
        }
    }

    Component.onCompleted: {
        clock.start()
    }
}
