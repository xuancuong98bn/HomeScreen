import QtQuick 2.14

Item {
    id: root

    property string timePlayed
    property string timeTotal

    property var progress
    property int xBegin: progressBG.x - point.width/2
    property int xEnd: progressBG.x + progressBG.width - point.width/2
    property int xCurr: progressBG.x + progress * progressBG.width - point.width/2

    signal seekTo(ratio: double)
    signal widthChange()

    function onProgressChanged(pro){
        progress = pro
        ptrSlide.x = xCurr
    }

    width: parent.width
    height: 20
    onWidthChanged: widthChange()

    Text {
        id: tPlayed
        text: timePlayed
        color: "white"
        font.pointSize: 8
        rightPadding: 20
        anchors.right: slider.left
    }

    Text {
        id: slider
        width: parent.width * 0.65
        anchors.horizontalCenter: parent.horizontalCenter
        Image {
            id: progressBG
            source: "Image/progress_bar_bg.png"
            width: parent.width
            height: 3
            anchors.top: parent.verticalCenter
            Image {
                id: progressIMG
                source: "Image/progress_bar.png"
                width: ptrSlide.x - progressBG.x + point.width/2
                height: parent.height
            }

            Item {
                id: ptrSlide
                x: xCurr
                y: slider.y - point.height/2 + 2
                Image {
                    id: point
                    source: "Image/point.png"
                    width: 15
                    height: 16
                    Image {
                        id: cPoint
                        source: "Image/center_point.png"
                        width: 11
                        height: 11
                        x: parent.x + 2
                        y: parent.y + 2
                    }
                }
            }
        }
        MouseArea{
            anchors.fill: slider
            drag.target: ptrSlide
            drag.axis: Drag.XAxis
            drag.minimumX: xBegin
            drag.maximumX: xEnd
            onPressed: {
                ptrSlide.x = mouseX - point.width/2
            }
            onReleased: {
                var ratio = (progressIMG.width)/(progressBG.width)
                seekTo(ratio)
            }
        }
    }

    Text {
        id: tTotal
        text: timeTotal
        color: "white"
        font.pointSize: 8
        leftPadding: 20
        anchors.left: slider.right
    }

    Component.onCompleted: {
        mController.progressChanged.connect(onProgressChanged)
        this.seekTo.connect(mController.seek)
        this.widthChange.connect(mController.calculateProgress)
    }

    Component.onDestruction: {
        mController.progressChanged.disconnect(onProgressChanged)
        this.seekTo.disconnect(mController.seek)
        this.widthChange.disconnect(mController.calculateProgress)
    }
}
