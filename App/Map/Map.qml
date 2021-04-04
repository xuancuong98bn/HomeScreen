import QtQuick 2.11
import QtQuick.Controls 2.4
import QtLocation 5.6
import QtPositioning 5.6

Item {
    id: root
    width: 1920 * appConfig.w_ratio
    height: (1200-104) * appConfig.h_ratio

    Item {
        id: startAnimation
        XAnimator{
            target: root
            from: 1920 * appConfig.w_ratio
            to: 0
            duration: 200
            running: true
        }
    }

    Plugin {
        id: mapPlugin
        name: "mapboxgl" //"osm" // , "esri", ...
    }

    MapQuickItem {
        id: marker
        anchorPoint.x: image.width/4
        anchorPoint.y: image.height
        coordinate: QtPositioning.coordinate(21.03, 105.78)

        sourceItem: Image {
            id: image
            source: "qrc:/Img/Map/car_icon.png"
        }
    }

    Map {
        id: map
        anchors.fill: parent
        plugin: mapPlugin
        center: QtPositioning.coordinate(21.03, 105.78)
        zoomLevel: 14
        copyrightsVisible: false
        Component.onCompleted: {
            map.addMapItem(marker)
        }
    }    
}
