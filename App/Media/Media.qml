import QtQuick 2.14
import QtQuick.Window 2.2
import QtMultimedia 5.14
import QtQuick.Controls 2.14

import MyMedia 1.0

Item {
    id: root

    function onPlayStateChanged(state: bool){
        if (state) {
            btnPlay.icon_default = "Image/pause.png"
            btnPlay.icon_pressed = "Image/hold-pause.png"
            btnPlay.icon_released = "Image/pause.png"
        } else {
            btnPlay.icon_default = "Image/play.png"
            btnPlay.icon_pressed = "Image/hold-play.png"
            btnPlay.icon_released = "Image/play.png"
        }
    }

    function onCollapsed(status){
        if (status) leftContent.open()
        else leftContent.close()
    }

    width: 1920 * appConfig.w_ratio
    height: (1200-104) * appConfig.h_ratio

    //title: qsTr("Media Player") + myTrans.emptyString

    Column {
        id: container
        anchors.fill: parent

        AppHeader{
            id: header
            width: parent.width
            height: 104 * appConfig.h_ratio

            Component.onCompleted: {
                header.collapse.connect(onCollapsed)
            }
        }

        Image {
            id: background
            width: parent.width
            height: parent.height - header.height
            source: "Image/background.png"

            Item {
                id: content
                anchors.fill: parent

                Drawer{
                    id: leftContent //Qt.LeftEdge is default
                    parent: content
                    width: parent.width * 0.35
                    height: parent.height
                    interactive: false
                    modal: false //off dimming above and allow handle action below
                    background: Rectangle {
                        id: playListContainer
                        anchors.fill: parent
                        color: "#05000000"
                    }
                    PlayList {
                        id: playListID
                        objectName: "playListID"
                        model: PlayListModel{
                            songs: songList
                        }
                    }
                }

                Column {
                    id: rightContent
                    width: parent.width - leftContent.width*leftContent.position
                    height: parent.height
                    anchors.right: parent.right
                    spacing: 10

                    Rectangle {
                        id: rborderTop
                        width: parent.width
                        height: 2
                        color: "#70000000"
                    }

                    MediaInfo {
                        id: rMediaInfo
                        objectName: "rMediaInfo"
                    }

                    AlbumArt {
                        id: rAlbumArt
                        objectName: "rAlbumArt"
                        model: PlayListModel{
                            songs: songList
                        }
                    }

                    Item {
                        id: rMediaControl
                        width: parent.width
                        height: parent.height - rAlbumArt.height - rMediaInfo.height //60

                        TimeSlider {
                            id: rTimeSlider
                            objectName: "rTimeSlider"
                            anchors.bottom: pnlControl.top
                            anchors.bottomMargin: 12
                        }

                        Item {
                            id: pnlControl
                            width: parent.width * 0.8
                            height: btnPlay.height
                            anchors.centerIn: parent

                            SwitchButton {
                                id: btnSuffle
                                anchors.left: parent.left
                                icon_on: "Image/shuffle-1.png"
                                icon_off: "Image/shuffle.png"
                                onPressed: {
                                    mController.suffle(!status)
                                }
                            }

                            ControlButton {
                                id: btnPre
                                cHeight: 30
                                anchors.right: btnPlay.left
                                icon_default: "Image/prev.png"
                                icon_pressed: "Image/hold-prev.png"
                                icon_released: "Image/prev.png"
                                onPressed: {
                                    mController.previous()
                                }
                            }

                            ControlButton {
                                id: btnPlay
                                cHeight: 60
                                anchors.horizontalCenter: parent.horizontalCenter
                                icon_default: "Image/play.png"
                                icon_pressed: "Image/hold-play.png"
                                icon_released: "Image/play.png"
                                onPressed: {
                                    mController.play()
                                }
                            }

                            ControlButton {
                                id: btnNext
                                cHeight: 30
                                anchors.left: btnPlay.right
                                icon_default: "Image/next.png"
                                icon_pressed: "Image/hold-next.png"
                                icon_released: "Image/next.png"
                                onPressed: {
                                    mController.next()
                                }
                            }

                            SwitchButton {
                                id: btnRepeat
                                anchors.right: parent.right
                                icon_on: "Image/repeat1_hold.png"
                                icon_off: "Image/repeat.png"
                                onPressed: {
                                    mController.repeat(!status)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        mController.playStateChanged.connect(onPlayStateChanged)
        mController.shuffleStateChanged.connect(btnSuffle.changeStatus)
        mController.repeatStateChanged.connect(btnRepeat.changeStatus)
    }

    Component.onDestruction: {
        mController.playStateChanged.disconnect(onPlayStateChanged)
        mController.shuffleStateChanged.disconnect(btnSuffle.changeStatus)
        mController.repeatStateChanged.disconnect(btnRepeat.changeStatus)
    }
}
