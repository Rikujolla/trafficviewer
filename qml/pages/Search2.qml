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

import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0
import "../components/setting.js" as Mysettings
import "tables.js" as Mytables


Page {
    id: page

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        /*PullDownMenu {
            MenuItem {
                text: qsTr("Save settings")
                onClicked: Mysettings.saveSettings()
            }
        }*/

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("Search page")
            }


            SectionHeader { text: qsTr("Search") }

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
                text: {qsTr("Search with LAM-number")
                }
            }


            TextField {
                validator: IntValidator{bottom: 100; top: 2000;}
                focus: true
                placeholderText: qsTr("LAM-index")
                inputMethodHints: Qt.ImhDigitsOnly
                EnterKey.enabled: !errorHighlight
                EnterKey.iconSource: "image://theme/icon-m-enter-close"
                EnterKey.onClicked: {
                    //lammiSelected = text
                    //console.log(lammiSelected)
                    Mytables.searchLAM(text)
                    focus=false
                }
            }

            /*Timer {
                id:killPage
                running:searchDone
                interval: 100
                repeat:true
                onTriggered: {
                    pageStack.pop()
                    searchDone = false

                }
            }*/

            //SectionHeader { text: qsTr("View settings") }

            /*Text {
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.primaryColor
                wrapMode: Text.WordWrap
                width: parent.width
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: Theme.paddingLarge
                }
                text: {qsTr("Use app with a left hand")
                }
            }*/

            /*TextSwitch {
                id: leftHandSwitch
                text: qsTr("Use app with a left hand")
                checked:leftHanded
                onCheckedChanged: {
                    checked ? leftHanded = true : leftHanded = false
                    Mysettings.saveSettings()
                }
            }*/

            /*SectionHeader { text: qsTr("Database maintenance") }

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
                text: {qsTr("Purge measured data to create or modify the history curve. Prepare for a wait up to two minutes.")
                }
            }

            Button {
                text: qsTr("Make history data")
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    Mytables.maintainDb()
                }
            }*/

            /* Label {
                x: Theme.paddingLarge
                text: qsTr("Hello Sailors")
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeExtraLarge
            }*/


        }
    }
}


