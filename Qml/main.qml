import QtQuick 2.11
import QtQuick.Window 2.0
import QtQuick.Controls 2.4

ApplicationWindow {
    id: window
    visible: true
    width: 1920 * appConfig.w_ratio
    height: 1200 * appConfig.h_ratio
    flags: Qt.Window | Qt.FramelessWindowHint

    Image {
        id: background
        width: 1920 * appConfig.w_ratio
        height: 1200 * appConfig.h_ratio
        source: "qrc:/Img/bg_full.png"
    }

    StatusBar {
        id: statusBar
        onBntBackClicked: stackView.pop()
        isShowBackBtn: stackView.depth == 1 ? false : true
    }

    StackView {
        id: stackView
        width: 1920 * appConfig.w_ratio
        anchors.top: statusBar.bottom
        initialItem: HomeWidget{id: home}
        onCurrentItemChanged: {
            currentItem.forceActiveFocus()
        }
        pushExit: Transition {
            XAnimator {
                from: 0
                to: -1920 * appConfig.w_ratio
                duration: 200
                easing.type: Easing.OutCubic
            }
        }
        Keys.onPressed: {
            if (statusBar.isShowBackBtn === true && event.key === Qt.Key_Backspace){
                statusBar.bntBackClicked()
            }
            if (event.key === Qt.Key_Home){
                while (stackView.depth > 1) stackView.pop()
            } else {
                var url = appsModel.getUrlByKey(event.key)
                if (url !== "NONE") home.openApplication(url)
            }
            if (event.modifiers === Qt.ControlModifier)
               home.widgetKeyPressed(event.key - Qt.Key_0)
        }
    }
}
