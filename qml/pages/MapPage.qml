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
    //onStatusChanged: console.log("LAM", lamStations.get(0).LAM_NUMERO)
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
            zoomLevel: (maximumZoomLevel - minimumZoomLevel)/2
            plugin : Plugin {
                id: plugin
                allowExperimental: true
                preferred: ["nokia", "osm"]
                required.mapping: Plugin.AnyMappingFeatures
                required.geocoding: Plugin.AnyGeocodingFeatures
                parameters: [
                    PluginParameter { name: "app_id"; value: "d3T1aLrywH9xSvigxqd3" },
                    PluginParameter { name: "token"; value: "03u1EAv_sslP5fFLTLb4KA" },
                    PluginParameter { name: "proxy"; value: "system" }
                ]
            }
            center: currentPosition.coordinate
            gesture.enabled: true

            /*onPinchFinished: {
                useLocation = false;
                console.log("Pinch started")
            }*/


            MapItemView {
                id:lamList
                model:lamPoints
                delegate: lamComponent
            }

            Component {
                id: lamComponent

                MapCircle {
                    id: lamDirOne
                    color: "red"
                    border.color: Qt.darker(color);
                    border.width: 3
                    radius:300.0
                    opacity: 1.0
                    z:40
                    //center: QtPositioning.coordinate(62.74529734,25.77326947)
                    center: QtPositioning.coordinate(latti,longi)
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
                    color: "orange"
                    border.color: Qt.darker(color);
                    border.width: 3
                    radius:200.0
                    opacity: 1.0
                    z:60
                    center: QtPositioning.coordinate(latti,longi)
                    MouseArea {
                        anchors.fill: parent
                        onClicked: pageStack.push(Qt.resolvedUrl("LamList.qml"))
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
                        color:"blue"
                        font.bold: true
                    }
                    zoomLevel: 12.5
                    z:80
                    coordinate: QtPositioning.coordinate(latti,longi)
                    anchorPoint: Qt.point(velTex.sourceItem.width * 0.5,velTex.sourceItem.height * 0.5)
                }
            }


            /*HereIndicator {
                id: hereIndicator
                coordinate: positionAccuracyIndicator.center
            }*/

            PositionSource {
                id:possut
                active:useLocation && Qt.application.active
                updateInterval:1000
                onPositionChanged: {
                    map.center = possut.position.coordinate
                    vars.counter++
                    vars.counter > 10 ? useLocation=false :useLocation = true
                    console.log("Wait location", vars.counter)
                    //Mytables.loadLocation()
                    //lamDirOne.center = QtPositioning.coordinate(61.48127685,23.8442065)
                    //velTex.coordinate = QtPositioning.coordinate(61.48127685,23.8442065)
                }
            }
            Timer {
                id:waitXml
                running: true
                repeat:true
                interval: 200
                onTriggered: {
                    if (lamStations.status == 1) {
                        waitXml.stop();
                        Mytables.loadLocation()}
                    else {console.log ("lamStations.not Ready", lamStations.status)}
                }
            }

            Timer {
                id:loadXml
                running: true
                repeat:true
                interval: 60000
                onTriggered: {
                    lamSpecs.reload()
                    waitXmlLoad.start()
                    console.log("Reloading traffic data")
                }
            }

            Timer {
                id:waitXmlLoad
                running: false
                repeat:true
                interval: 200
                onTriggered: {
                    if (lamSpecs.status == 1) {
                        waitXmlLoad.stop();
                        Mytables.addData()}
                    else {console.log ("lamSpecs.not Ready", lamSpecs.status)}
                }
            }

        }
    }
    //onComponentCompleted: {counter = 0; useLocation = true}
    //    }
}


