import QtQuick 2.0
import QtQuick.Controls 2.5

Item {
    id: root
    width: 1920 * appConfig.w_ratio
    height: (1200-104) * appConfig.h_ratio
    Rectangle{
        id: header
        width: parent.width
        height: 104 * appConfig.h_ratio
        color: "#2B2937"
        Text {
            text: qsTr("Climate")
            anchors.centerIn: parent
            font.pointSize: 17
            color: "white"
        }
    }
    Item {
        width: 400
        height: 480
        anchors.centerIn: root
        Text {
            id: temp1
            anchors.topMargin: 50
            text: "Temperature driver: "
            color: "white"
            horizontalAlignment: Text.AlignHCenter
        }

        SpinBox {
            id: driverTemp
            anchors.left: passengerTemp.left
            anchors.verticalCenter: temp1.verticalCenter
            width: 200
            from: 165
            to: 315
            stepSize: 5
            value: climateModel.driver_temp * 10

            property int decimals: 1

            validator: DoubleValidator {
                bottom: Math.min(driverTemp.from, driverTemp.to)
                top:  Math.max(driverTemp.from, driverTemp.to)
            }

            textFromValue: function(value, locale) {
                return Number(value / 10).toLocaleString(locale, 'f', driverTemp.decimals)
            }

            valueFromText: function(text, locale) {
                return Number.fromLocaleString(locale, text)
            }
        }

        Text {
            id: temp2
            anchors.top: temp1.bottom
            anchors.topMargin: 30
            anchors.left: temp1.left
            text: "Temperature passenger: "
            color: "white"
            horizontalAlignment: Text.AlignHCenter
        }
        SpinBox {
            id: passengerTemp
            anchors.left: temp2.right
            anchors.leftMargin: 20
            anchors.verticalCenter: temp2.verticalCenter
            width: 200
            from: 165
            to: 315
            stepSize: 5
            value: climateModel.passenger_temp * 10

            property int decimals: 1

            validator: DoubleValidator {
                bottom: Math.min(driverTemp.from, driverTemp.to)
                top:  Math.max(driverTemp.from, driverTemp.to)
            }

            textFromValue: function(value, locale) {
                return Number(value / 10).toLocaleString(locale, 'f', driverTemp.decimals)
            }

            valueFromText: function(text, locale) {
                return Number.fromLocaleString(locale, text)
            }
        }
        Text {
            id: fan
            anchors.top: temp2.bottom
            anchors.topMargin: 30
            anchors.left: temp2.left
            text: "Fan: "
            color: "white"
            horizontalAlignment: Text.AlignHCenter
        }

        Row {
            id: r1
            anchors.right: passengerTemp.right
            anchors.verticalCenter: fan.verticalCenter
            Slider {
                id: fanLevel
                from : 1
                to: 10
                stepSize: 1
                value: climateModel.fan_level
            }
            Text {
                id: valueSlider
                text: fanLevel.value
                color: "white"
                horizontalAlignment: Text.AlignHCenter
            }
        }
        Text {
            id: driver_wind_mode_txt
            anchors.top: fan.bottom
            anchors.topMargin: 30
            anchors.left: temp1.left
            text: "Driver wind direction"
            color: "white"
            horizontalAlignment: Text.AlignHCenter
        }

        ComboBox {
            id: driver_wind_mode
            anchors.verticalCenter: driver_wind_mode_txt.verticalCenter
            anchors.left: passengerTemp.left
            textRole: "key"
            currentIndex: climateModel.driver_wind_mode
            width: 200
            model: ListModel {
                ListElement {
                    key: "on face"
                    value: 0
                }
                ListElement {
                    key: "on foot"
                    value: 1
                }
                ListElement {
                    key: "on face and foot"
                    value: 2
                }
            }
        }
        Text {
            id: passenger_wind_mode_txt
            anchors.top: driver_wind_mode_txt.bottom
            anchors.topMargin: 30
            anchors.left: temp1.left
            text: "Passenger wind direction"
            color: "white"
            horizontalAlignment: Text.AlignHCenter
        }

        ComboBox {
            id: passenger_wind_mode
            anchors.verticalCenter: passenger_wind_mode_txt.verticalCenter
            anchors.left: passengerTemp.left
            textRole: "key"
            currentIndex: climateModel.passenger_wind_mode
            width: 200
            model: ListModel {
                ListElement {
                    key: "on face"
                    value: 0
                }
                ListElement {
                    key: "on foot"
                    value: 1
                }
                ListElement {
                    key: "on face and foot"
                    value: 2
                }
            }
        }
        Text {
            id: auto_mode_txt
            anchors.left: temp1.left
            anchors.top: passenger_wind_mode_txt.bottom
            anchors.topMargin: 30
            text: "AUTO mode: "
            color: "white"
            horizontalAlignment: Text.AlignHCenter
        }

        ComboBox {
            id: auto_mode
            anchors.left: passengerTemp.left
            anchors.verticalCenter: auto_mode_txt.verticalCenter
            textRole: "key"
            currentIndex: climateModel.auto_mode
            width: 200
            model: ListModel {
                ListElement {
                    key: "ON"
                    value: 0
                }
                ListElement {
                    key: "OFF"
                    value: 1
                }
            }
        }
        Text {
            id: sync_mode_txt
            anchors.left: temp1.left
            anchors.top: auto_mode_txt.bottom
            anchors.topMargin: 30
            text: "SYNC mode: "
            color: "white"
            horizontalAlignment: Text.AlignHCenter
        }

        ComboBox {
            id: sync_mode
            anchors.left: passengerTemp.left
            anchors.verticalCenter: sync_mode_txt.verticalCenter
            textRole: "key"
            currentIndex: climateModel.sync_mode
            width: 200
            model: ListModel {
                ListElement {
                    key: "ON"
                    value: 0
                }
                ListElement {
                    key: "OFF"
                    value: 1
                }
            }
        }
    }
}
