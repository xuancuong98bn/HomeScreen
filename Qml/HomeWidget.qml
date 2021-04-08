import QtQuick 2.14
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.4
import QtQml.Models 2.1

Item {
    id: root
    property var focusItem
    property int widgetFocusing : -1
    property int appFocusing : -1

    function openApplication(url){
        parent.push(url)
    }

    function changeFocus(item){
        if (focusItem !== undefined){
            focusItem.isFocusing = false
        }
        focusItem = item
        focusItem.isFocusing = true
    }
    function moveAppKey(key){
        if (appsModel.rowCount() > 0) {
            if (key === Qt.Key_Left){
                if (appFocusing == -1) appFocusing = 0
                appFocusing = (appFocusing + appsModel.rowCount()-1)%appsModel.rowCount()
            }
            if (key === Qt.Key_Right) appFocusing = (appFocusing + 1)%appsModel.rowCount()
            if (key === Qt.Key_Down) appFocusing = 0
            appKeyPressed(appsModel.getIdByIndex(appFocusing), false)
        }
    }

    signal appKeyPressed(var appID, var isOpened)
    signal widgetKeyPressed(var index, var isOpened)

    width: 1920 * appConfig.w_ratio
    height: 1096 * appConfig.h_ratio

    Keys.onPressed: {
        switch (event.key){
        case Qt.Key_Up:
            widgetKeyPressed(0, false)
            break;
        case Qt.Key_Down:
            widgetFocusing = -1
            moveAppKey(Qt.Key_Down)
            break;
        case Qt.Key_Left:
            if (widgetFocusing >= 0) widgetKeyPressed((widgetFocusing+2)%3, false)
            else moveAppKey(Qt.Key_Left)
            break;
        case Qt.Key_Right:
            if (widgetFocusing >= 0) widgetKeyPressed((widgetFocusing+1)%3, false)
            else moveAppKey(Qt.Key_Right)
            break;
        case Qt.Key_Return:
            if (widgetFocusing >= 0) widgetKeyPressed(widgetFocusing, true)
            else if (appsModel.rowCount() > 0) appKeyPressed(appsModel.getIdByIndex(appFocusing), true)
            break;
        }
    }

    ListView {
        id: lvWidget
        spacing: 5 * appConfig.w_ratio
        orientation: ListView.Horizontal
        width: parent.width - spacing
        leftMargin: 2 * appConfig.w_ratio
        rightMargin: 3 * appConfig.w_ratio
        height: 570 * appConfig.h_ratio
        interactive: false

        displaced: Transition {
            NumberAnimation { properties: "x,y"; easing.type: Easing.OutQuad }
        }

        model: DelegateModel {
            id: visualModelWidget
            model: ListModel {
                id: widgetModel
                ListElement { type: "map" }
                ListElement { type: "climate" }
                ListElement { type: "media" }
            }

            delegate: DropArea {
                id: delegateRootWidget
                width: 635 * appConfig.w_ratio
                height: 570 * appConfig.h_ratio
                keys: "widget"

                onEntered: {
                    visualModelWidget.items.move(drag.source.visualIndex, iconWidget.visualIndex)
                    iconWidget.item.enabled = false
                }
                property int visualIndex: DelegateModel.itemsIndex
                Binding { target: iconWidget; property: "visualIndex"; value: visualIndex }
                onExited: iconWidget.item.enabled = true
                onDropped: {
                    //console.log(drop.source.visualIndex)
                }

                Loader {
                    id: iconWidget
                    property int visualIndex: 0
                    width: 635 * appConfig.w_ratio
                    height: 570 * appConfig.h_ratio
                    anchors {
                        horizontalCenter: parent.horizontalCenter;
                        verticalCenter: parent.verticalCenter
                    }

                    sourceComponent: {
                        switch(model.type) {
                        case "map": return mapWidget
                        case "climate": return climateWidget
                        case "media": return mediaWidget
                        }
                    }

                    Drag.active: iconWidget.item.drag.active
                    Drag.keys: "widget"
                    Drag.hotSpot.x: delegateRootWidget.width/2
                    Drag.hotSpot.y: delegateRootWidget.height/2

                    states: [
                        State {
                            when: iconWidget.Drag.active
                            ParentChange {
                                target: iconWidget
                                parent: root
                            }

                            AnchorChanges {
                                target: iconWidget
                                anchors.horizontalCenter: undefined
                                anchors.verticalCenter: undefined
                            }
                        }
                    ]
                }
            }
        }

        Component {
            id: mapWidget
            MapWidget{
                id: itemMap
                function onWidgetKeyPressed(index, isOpened){
                    if (parent.visualIndex === index){
                        if (isOpened) openApplication("qrc:/App/Map/Map.qml")
                        changeFocus(itemMap)
                        widgetFocusing = index
                    }
                }
                onClicked: {
                    openApplication("qrc:/App/Map/Map.qml")
                    changeFocus(this)
                    widgetFocusing = parent.visualIndex
                }
                Component.onCompleted: {
                    root.widgetKeyPressed.connect(onWidgetKeyPressed)
                }
            }
        }
        Component {
            id: climateWidget
            ClimateWidget {
                id: itemClimate
                function onWidgetKeyPressed(index, isOpened){
                    if (parent.visualIndex === index){
                        //if (isOpened) openApplication("qrc:/App/Map/Map.qml")
                        changeFocus(itemClimate)
                        widgetFocusing = index
                    }
                }
                onClicked: {
                    changeFocus(this)
                    widgetFocusing = parent.visualIndex
                }
                Component.onCompleted: root.widgetKeyPressed.connect(onWidgetKeyPressed)
            }
        }
        Component {
            id: mediaWidget
            MediaWidget{
                id: itemMedia
                function onWidgetKeyPressed(index, isOpened){
                    if (parent.visualIndex === index){
                        if (isOpened) openApplication("qrc:/App/Media/Media.qml")
                        changeFocus(itemMedia)
                        widgetFocusing = index
                    }
                }
                onClicked: {
                    openApplication("qrc:/App/Media/Media.qml")
                    changeFocus(this)
                    widgetFocusing = parent.visualIndex
                }
                Component.onCompleted: root.widgetKeyPressed.connect(onWidgetKeyPressed)
            }
        }
    }

    ScrollBar{
        id: scrollBar
        width: lvApps.width
        height: 23 * appConfig.h_ratio
        anchors.top: lvApps.top
        anchors.left: lvApps.left
        visible: visualModel.count > 6
        orientation: Qt.Horizontal
    }

    ListView {
        id: lvApps
        x: 2 * appConfig.w_ratio
        y: 570 * appConfig.h_ratio
        width: parent.width - spacing
        height: 604 * appConfig.h_ratio
        orientation: ListView.Horizontal
        interactive: scrollBar.visible
        spacing: 4 * appConfig.w_ratio
        contentWidth: width
        clip: true

        displaced: Transition {
            NumberAnimation { properties: "x,y"; easing.type: Easing.OutQuad }
        }

        model: DelegateModel {
            id: visualModel
            model: appsModel
            delegate: DropArea {
                id: delegateRoot
                width: 316 * appConfig.w_ratio
                height: 604 * appConfig.h_ratio
                keys: "AppButton"

                onEntered: {
                    if (drag.source.visualIndex !== icon.visualIndex) {
                        appsModel.move(drag.source.visualIndex, icon.visualIndex);
                        visualModel.items.move(drag.source.visualIndex, icon.visualIndex)
                        appsModel.saveApps()
                    }
                }

                property int visualIndex: DelegateModel.itemsIndex
                Binding { target: icon; property: "visualIndex"; value: visualIndex }

                Item {
                    id: icon
                    property int visualIndex: 0
                    width: 316 * appConfig.w_ratio
                    height: 604 * appConfig.h_ratio
                    anchors {
                        horizontalCenter: parent.horizontalCenter;
                        verticalCenter: parent.verticalCenter
                    }

                    AppButton{
                        id: app

                        function onAppKeyPressed(appID, isOpened){
                            if (appID === model.id){
                                if (isOpened) openApplication(app.url)
                                changeFocus(app)
                                widgetFocusing = -1
                            }
                        }

                        anchors.fill: parent
                        title: model.title
                        icon: model.iconPath
                        url: model.url
                        onClicked: {
                            openApplication(this.url)
                            changeFocus(this)
                        }
                        drag.target: icon
                        Component.onCompleted: {
                            root.appKeyPressed.connect(onAppKeyPressed)
                        }
                    }

                    onFocusChanged: app.focus = icon.focus

                    Drag.active: app.drag.active
                    Drag.keys: "AppButton"

                    states: [
                        State {
                            when: icon.Drag.active
                            ParentChange {
                                target: icon
                                parent: root
                            }

                            AnchorChanges {
                                target: icon
                                anchors.horizontalCenter: undefined
                                anchors.verticalCenter: undefined
                            }
                        }
                    ]
                }
            }
        }

        ScrollBar.horizontal: scrollBar
    }
}
