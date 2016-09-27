/*Copyright (c) 2016, Riku Lahtinen, rikul.lajolla@kiu.as
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

// Initial version copied from the page https://github.com/b0bben/SailfishOS_MapTutorial
// Thanks for that tutorial

import QtQuick 2.0
import Sailfish.Silica 1.0
import QtPositioning 5.2
import QtQuick.XmlListModel 2.0
import QtLocation 5.0
import QtQuick.LocalStorage 2.0
import "tables.js" as Mytables

Page {
    id: page
    onStatusChanged: console.log("status", page.status)
    /*SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("List Page")
                onClicked: pageStack.push(Qt.resolvedUrl("LamList.qml"))
            }
        }*/
    Item {
        id:vars
        property int counter : 0
    }



    Location {
        id: currentPosition
        coordinate: QtPositioning.coordinate(-27.5, 153.1) }
    /*Item {
        id: currentPosition
        property variant coordinate: QtPositioning.coordinate(62.74529734,25.77326947)
    }*/

    Label {
        id: lblPosition
        text: "current position: " + currentPosition.coordinate
        font.pixelSize: Theme.fontSizeSmall
    }

    Rectangle {
        anchors.top: lblPosition.bottom
        anchors.fill: parent

        Map {
            id: map
            anchors.fill: parent
            zoomLevel: (maximumZoomLevel - minimumZoomLevel)/2 + 4.5
            /*plugin : Plugin {
                id: plugin
                allowExperimental: true
                preferred: ["here", "osm"]
                required.mapping: Plugin.AnyMappingFeatures
                required.geocoding: Plugin.AnyGeocodingFeatures
                parameters: [
                    PluginParameter { name: "here.app_id"; value: "xxxxxxxx" },
                    PluginParameter { name: "here.token"; value: "yyyyyyyyy" },
                    PluginParameter { name: "here.proxy"; value: "system" }
                ]
            }*/
            plugin : Plugin {
                name: "osm"
                PluginParameter { name: "osm.mapping.copyright"; value: "© <a href=\"http://www.openstreetmap.org/copyright\">OpenStreetMap</a> contributors" }
            }
            //center: currentPosition.coordinate
            center: QtPositioning.coordinate(62.74529734,25.77326947)
            gesture.enabled: true

            /*onPinchFinished: {
                //useLocation = false;
                console.log("Pinch started")
            }*/


            MapItemView {
                id:lamList
                model:lamBarePoints
                delegate: lamComponent
            }

            Component {
                id: lamComponent

                MapCircle {
                    id: lamDirOne
                    color: "red"
                    border.color: Qt.darker(color);
                    border.width: 3
                    radius:200.0
                    opacity: 1.0
                    z:40
                    //center: QtPositioning.coordinate(62.74529734,25.77326947)
                    center: QtPositioning.coordinate(latti,longi)
                }
            }

            MapItemView {
                id:lamList2
                model:lamPoints
                delegate: lamComponentRec
            }

            Component {
                id: lamComponentRec

                MapRectangle {
                    id: lamDirTwo
                    color: "blue"
                    border.color: Qt.darker(color);
                    border.width: 3
                    opacity: 1.0
                    z:40
                    //center: QtPositioning.coordinate(62.74529734,25.77326947)
                    topLeft: QtPositioning.coordinate(latti-0.002,longi-0.003)
                    bottomRight: QtPositioning.coordinate(latti-0.0036,longi+0.003)
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            lammiSelected = lamPoints.get(index).iidee
                            lammiPair = lamPoints.get(index).pair
                            speedView = false
                            pageStack.push(Qt.resolvedUrl("DrawData.qml"))
                            //dataLoad = true
                            console.log("Lamindex", lammiSelected, lammiPair)
                        }
                    }
                }
            }

            MapItemView {
                id:lamInner
                model:lamPoints
                delegate: lamInnerComponent
            }

            Component {
                id: lamInnerComponent

                MapCircle {
                    id: lamDirTwo
                    color: age < 600 ? (age < 300 ? "yellow":"orange") : "red"
                    border.color: Qt.darker(color);
                    border.width: 3
                    radius:150.0
                    opacity: 1.0
                    z:60
                    center: QtPositioning.coordinate(latti,longi)
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            lammiSelected = lamPoints.get(index).iidee
                            lammiPair = lamPoints.get(index).pair
                            speedView = true
                            pageStack.push(Qt.resolvedUrl("DrawData.qml"))
                            console.log("Lamindex", lammiSelected, lammiPair)
                        }
                    }
                }
            }

            MapItemView {
                id:veloList
                model:lamPoints
                delegate: veloComponent
            }

            Component {
                id: veloComponent

                MapQuickItem {
                    id:velTex
                    sourceItem: Text{
                        text: veloc
                        color:"black"
                        font.bold: true
                    }
                    zoomLevel: 13.8
                    z:80
                    coordinate: QtPositioning.coordinate(latti,longi)
                    anchorPoint: Qt.point(velTex.sourceItem.width * 0.5,velTex.sourceItem.height * 0.5)
                }
            }

            MapItemView {
                id:carsList
                model:lamPoints
                delegate: carsComponent
            }

            Component {
                id: carsComponent

                MapQuickItem {
                    id:velTex
                    sourceItem: Text{
                        text: cars*12
                        color:"white"
                        font.bold: true
                    }
                    zoomLevel: 14.0
                    z:80
                    coordinate: QtPositioning.coordinate(latti-0.0028,longi)
                    anchorPoint: Qt.point(velTex.sourceItem.width * 0.5,velTex.sourceItem.height * 0.5)
                }
            }
            PositionSource {
                id:possut
                active:useLocation && Qt.application.active
                updateInterval:gpsUpdateRate
                onPositionChanged: {
                    map.center = possut.position.coordinate
                    currentLat = map.center.latitude
                    currentLong = map.center.longitude
                    vars.counter++
                    vars.counter > 9 ? useLocation=false :useLocation = true
                    console.log("Wait location", vars.counter)
                    //Mytables.loadLocation()
                    //lamDirOne.center = QtPositioning.coordinate(61.48127685,23.8442065)
                    //velTex.coordinate = QtPositioning.coordinate(61.48127685,23.8442065)
                }
            }

            Timer {
                id:loadXml
                running: Qt.application.active && page.status == 2
                repeat:true
                interval: 1000
                onTriggered: {
                    console.log(map.center, map.center.latitude)
                    differenceExists = Math.abs(map.center.latitude-currentLat) + Math.abs(map.center.longitude-currentLong)
                    currentLat = map.center.latitude
                    currentLong = map.center.longitude
                    if (page.status == 2 && !dataReaded) {
                        Mytables.readData()
                        dataReaded = true;
                        console.log("Updating LAM data to the screen")
                    }
                    else if (differenceExists > 0.001) {
                        console.log("Searching LAM-stations on screen", page.status)
                        Mytables.subsetLocation()
                        dataReaded = false;
                    }
                    else {
                        dataReaded = false;
                    }

                }
            }

            Timer {
                id:waitXmlLoad
                running: false
                repeat:true
                interval: 600
                onTriggered: {
                    if (lamSpecs.status == 1) {
                        waitXmlLoad.stop();
                        Mytables.addData()
                        dataLoad = false
                        console.log("Data loaded", dataLoad, lamSpecs.status)
                    }
                    else {console.log ("lamSpecs.not Ready", lamSpecs.status)}
                }
            }

        }

    }
    //onComponentCompleted: {counter = 0; useLocation = true}
        Text{
            font.pixelSize: Theme.fontSizeSmall
            text: qsTr("Map data") + " © " + "<a href=\'http://www.openstreetmap.org/copyright\'>OpenStreetMap</a> " + qsTr("contributors")
            anchors.bottom : page.bottom
            onLinkActivated: Qt.openUrlExternally(link)
        }

    IconButton {
        id:gpsIcon
        anchors.bottom: page.bottom
        anchors.right: page.right
        icon.source: "image://theme/icon-m-gps?" + (pressed
                                                    ? Theme.highlightColor
                                                    : Theme.primaryColor)
        onClicked: {
            useLocation = true
            vars.counter = 0
            //map.center = possut.position.coordinate
            //currentLat = map.center.latitude
            //currentLong = map.center.longitude
        }
    }

    IconButton {
        id: settingsIcon
        anchors.bottom: gpsIcon.top
        //anchors.bottomMargin: 20
        anchors.right: page.right
        icon.source: "image://theme/icon-m-developer-mode?" + (pressed
                                                    ? Theme.highlightColor
                                                    : Theme.primaryColor)
        onClicked: {
            pageStack.push(Qt.resolvedUrl("Settings.qml"))
        }
    }

    IconButton {
        id: favoriteIcon
        anchors.bottom: settingsIcon.top
        //anchors.bottomMargin: 20
        anchors.right: page.right
        icon.source: "image://theme/icon-m-favorite?" + (pressed
                                                    ? Theme.highlightColor
                                                    : Theme.primaryColor)
        onClicked: {
            lammiSelected = 902
            lammiPair = 1
            speedView = false
            pageStack.push(Qt.resolvedUrl("DrawData.qml"))
        }
    }
}


