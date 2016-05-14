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
import QtLocation 5.0

Page {
    id: page
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
        id: currentPosition
        property variant coordinate: QtPositioning.coordinate(62.74529734,25.77326947)
    }

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

            // Circle for indicating both the position and the accuracy of the
            // positioning.
            MapCircle {
                id: positionAccuracyIndicator
                color: "#40FF0000"
                border.color: Qt.darker(color);
                border.width: 3
                opacity: 1.0
                center: currentPosition.coordinate

            }

            /*HereIndicator {
                id: hereIndicator
                coordinate: positionAccuracyIndicator.center
            }*/
        }
    }
//    }
}


