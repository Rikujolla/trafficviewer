/*Copyright (c) 2015, Riku Lahtinen
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

import QtQuick 2.0
import Sailfish.Silica 1.0
import QtPositioning 5.2
import QtLocation 5.0


Page {
    id: page
    onStatusChanged: {
        //console.log("status")
        //Mydbases.loadLocation()
        searchModel.update()
        //console.log(searchModel.status)
    }

    Plugin {
        id: osmPlugin
        name: "osm"
    }

    PlaceSearchModel {
        id: searchModel

        plugin : osmPlugin

        limit:5
        searchTerm: "Nirva"
        searchArea: QtPositioning.circle(QtPositioning.coordinate(61.461967, 23.769631), 10000);

        Component.onCompleted: update()

    }


    SilicaListView {
        id: listView
        model: searchModel
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: qsTr("Search")
                onClicked: searchModel.update()
            }
        }


        header: PageHeader {
            title: qsTr("Search page")
        }
        delegate: BackgroundItem {
            id: delegate

            Label {
                id: listos
                x: Theme.paddingLarge
                text: place.location.address.text
                anchors.verticalCenter: parent.verticalCenter
                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
            }
            onClicked: {
                //currentIndex = index+1;
                //pageStack.push(Qt.resolvedUrl("Loc.qml"))
            }
        }


        VerticalScrollDecorator {}

        Component.onCompleted: {
            //Mydbases.loadLocation()
        }


    }
}



            /*SectionHeader { text: qsTr("GPS settings") }

            Text {
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.primaryColor
                wrapMode: Text.WordWrap
                width: parent.width
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: Theme.paddingLarge
                }
                text: {qsTr("Adjust GPS update rate with slider")
                }
            }

            Slider {
                width: parent.width
                minimumValue: 1
                maximumValue: 10
                value: 2
                valueText: value + " " + "s"
                onValueChanged: gpsUpdateRate = value * 1000

            }*/

            /*TextField {
                id: searchField
                //text: "help"
                placeholderText: "Location"
                label: qsTr("Enter location where to find the LAM")
                visible: true
                width: page.width
                //anchors.bottom: favoriteIcon.top
                validator: RegExpValidator { regExp: /^((([A-E])([0-9])([0]))|((A)([0-5])([0-9]))||((R)([0])([1-5])))$/ }
                color: errorHighlight? "red" : Theme.primaryColor
                inputMethodHints: Qt.ImhNoPredictiveText
                EnterKey.enabled: !errorHighlight
                EnterKey.iconSource: "image://theme/icon-m-search"
                EnterKey.onClicked: {
                    console.log("test")
                }
            }*/


            /*ListView {
                //anchors.fill: parent
                model: searchModel
                delegate:
                    //Component {
                    //Row {
                        //spacing: 5
                        //Marker { height: parent.height }
                        //Column {
                            Text { text: title; font.bold: true }
                            //Text { text: place.location.address.text }
                        //}
                   // }
                //}
            }


        }
    }
}*/


