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
    onStatusChanged: {
        if (searchDone) {
            map.center = QtPositioning.coordinate(searchLatti+0.01, searchLongi+0.01)
            map.center = QtPositioning.coordinate(searchLatti, searchLongi)
            map.zoomLevel = 14.5
            searchDone = false
        }
        /*if (leftHanded) {
            //
            //helpIcon.anchors.right = undefined
            gpsIcon.anchors.left = page.left
            helpIcon.anchors.left = page.left
        }
        else {
            //
            //helpIcon.anchors.left = undefined
            gpsIcon.anchors.right = page.right
            helpIcon.anchors.right = page.right
        }*/

        //console.log("status", page.status)
    }
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
        id:rect
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
            center: QtPositioning.coordinate(61.4042,23.7746)
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
                    topLeft: QtPositioning.coordinate(latti-0.002,longi-0.003)
                    bottomRight: QtPositioning.coordinate(latti-0.0036,longi+0.003)
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            lammiSelected = lamPoints.get(index).iidee
                            lammiPair = lamPoints.get(index).pair
                            lammiLatti = lamPoints.get(index).latti
                            lammiLongi = lamPoints.get(index).longi
                            speedView = false
                            pageStack.push(Qt.resolvedUrl("DrawData.qml"))
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
                            lammiLatti = lamPoints.get(index).latti
                            lammiLongi = lamPoints.get(index).longi
                            speedView = true
                            pageStack.push(Qt.resolvedUrl("DrawData.qml"))
                            //console.log("Lamindex", lammiSelected, lammiPair, lammiLatti, lammiLongi)
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
                    gpsLat = possut.position.coordinate.latitude
                    gpsLong = possut.position.coordinate.longitude
                    currentLat = map.center.latitude
                    currentLong = map.center.longitude
                }
            }

            Timer {
                id:loadXml
                running: Qt.application.active && page.status == 2
                repeat:true
                interval: 600
                onTriggered: {
                    differenceExists = Math.abs(map.center.latitude-currentLat) + Math.abs(map.center.longitude-currentLong)
                    currentLat = map.center.latitude
                    currentLong = map.center.longitude
                    if (page.status == 2 && !dataReaded) {
                        Mytables.readData()
                        dataReaded = true;
                        //console.log("Updating LAM data to the screen")
                    }
                    else if (differenceExists > 0.001) {
                        //console.log("Searching LAM-stations on screen", page.status)
                        Mytables.subsetLocation()
                        dataReaded = false;
                    }
                    else {
                        dataReaded = false;
                    }

                }
            }


        }

    }


    Text{
            font.pixelSize: Theme.fontSizeSmall
            text: qsTr("Map data") + " © " + "<a href=\'http://www.openstreetmap.org/copyright\'>OpenStreetMap</a> " + qsTr("contributors")
            anchors.bottom : page.bottom
            //anchors.left: leftHanded  ? undefined : rect.left
            //anchors.right: leftHanded  ? rect.right : undefined
            onLinkActivated: Qt.openUrlExternally(link)
        }

    IconButton {
        id:gpsIcon
        anchors.bottom: page.bottom
        //anchors.left: leftHanded  ? page.left : undefined
        //anchors.right: leftHanded ? undefined : page.right
        anchors.right: page.right
        icon.source: "image://theme/icon-m-gps?" + (useLocation ? (pressed
                                                    ? Theme.highlightColor
                                                    : Theme.secondaryHighlightColor): "red")
        onClicked: {
            if (useLocation) {
            map.center.latitude = gpsLat
            map.center.longitude = gpsLong
            }
            else {}
        }
    }

    IconButton {
        id: settingsIcon
        anchors.bottom: gpsIcon.top
        //anchors.left: leftHanded  ? page.left : undefined
        //anchors.right: leftHanded ? undefined : page.right
        anchors.right: page.right
        icon.source: "image://theme/icon-m-developer-mode?" + (pressed
                                                    ? Theme.highlightColor
                                                    : Theme.secondaryHighlightColor)
        onClicked: {
            pageStack.push(Qt.resolvedUrl("Settings.qml"))
            //gpsIcon.anchors.left = undefined
            //gpsIcon.anchors.right = undefined
            //searchIcon.anchors.left = undefined
            //searchIcon.anchors.right = undefined
        }
    }

    IconButton {
        id: favoriteIcon
        anchors.bottom: settingsIcon.top
        //anchors.left: leftHanded  ? page.left : undefined
        //anchors.right: leftHanded ? undefined : page.right
        anchors.right: page.right
        icon.source: "image://theme/icon-m-favorite?" + (pressed
                                                    ? Theme.highlightColor
                                                    : Theme.secondaryHighlightColor)
        onClicked: {
            lammiSelected = favourSelected
            lammiPair = favourPair
            lammiLatti = favourLatti
            lammiLongi = favourLongi
            map.center = QtPositioning.coordinate(favourLatti+0.01,favourLongi+0.01)
            map.center = QtPositioning.coordinate(favourLatti, favourLongi)
            speedView = false
            pageStack.push(Qt.resolvedUrl("DrawData.qml"))
        }
    }

    IconButton {
        id: searchIcon
        anchors.bottom: favoriteIcon.top
        //anchors.left: leftHanded  ? page.left : undefined
        //anchors.right: leftHanded ? undefined : page.right
        anchors.right: page.right
        icon.source: "image://theme/icon-m-search?" + (pressed
                                                    ? Theme.highlightColor
                                                    : Theme.secondaryHighlightColor)
        onClicked: {
            var dialog = pageStack.push(Qt.resolvedUrl("Search3.qml"),
                                        {"lamID": 901})
            dialog.accepted.connect(function() {
                //header.title = "My name: " + dialog.name
                //console.log(dialog.lamID)
                Mytables.searchLAM(dialog.lamID)

            })

        }
    }

    IconButton {
        id: helpIcon
        anchors.bottom: searchIcon.top
        //anchors.right: leftHanded ? undefined : page.right
        //anchors.left: leftHanded  ? page.left : undefined
        anchors.right: page.right
        icon.source: "image://theme/icon-m-question?" + (pressed
                                                    ? Theme.highlightColor
                                                    : Theme.secondaryHighlightColor)
        onClicked: {
            //if(leftHanded) {anchors.left = page.left}
            pageStack.push(Qt.resolvedUrl("Help.qml"))
        }
    }

    IconButton {
        id: aboutIcon
        anchors.bottom: helpIcon.top
        //anchors.left: leftHanded  ? page.left : undefined
        //anchors.right: leftHanded ? undefined : page.right
        anchors.right: page.right
        icon.source: "image://theme/icon-m-about?" + (pressed
                                                    ? Theme.highlightColor
                                                    : Theme.secondaryHighlightColor)
        onClicked: {
            pageStack.push(Qt.resolvedUrl("About.qml"))
        }
    }

    Timer { // Waits LAM-data loaded
        id:dbCheck
        running: true
        repeat:true
        interval: 4000
        onTriggered: {
            console.log("Dbversion check", dbVersion)
            if(dbVersion < 15) {
                Qt.createComponent("UpdateMessage.qml").createObject(page, {});
            }
            dbCheck.stop();
        }
    }

    Component.onCompleted: {
        map.center = QtPositioning.coordinate(61.4042+0.01,23.7746+0.01)
        map.center = QtPositioning.coordinate(61.4042,23.7746)
        //map.center = QtPositioning.coordinate(61.461967+0.01,23.769631+0.01)
        //map.center = QtPositioning.coordinate(61.461967, 23.769631)
        currentLat = map.center.latitude
        currentLong = map.center.longitude
        /*if (leftHanded) {
            //
            //helpIcon.anchors.right = undefined
            gpsIcon.anchors.left = page.left
            helpIcon.anchors.left = page.left
        }
        else {
            //
            //helpIcon.anchors.left = undefined
            gpsIcon.anchors.right = page.right
            helpIcon.anchors.right = page.right
        }*/
    }
}


