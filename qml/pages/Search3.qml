/*Copyright (c) 2016, Riku Lahtinen
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

import QtQuick 2.2
import Sailfish.Silica 1.0

Dialog {
    property int lamID
    property bool searchValid

    Column {
        width: parent.width

        DialogHeader {
            title: qsTr("Search LAM")
        }

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
            text: {qsTr("Search a LAM location with a LAM-number") + "\n"
            }
        }

        SearchField {
            id:lamSearch
            width: parent.width
            validator: IntValidator{bottom: 100; top: 2000;}
            placeholderText: "448"
            inputMethodHints: Qt.ImhDigitsOnly
            onTextChanged: {
                if(!errorHighlight) {searchValid = true; console.log("valid")}
            }
        }

        /*ListView {
            model: lammit
            anchors.fill: lamSearch.bottom
            //anchors.top: lamSearch.bottom
            delegate: BackgroundItem {
                //id: name
                Label {
                color: Theme.primaryColor
                text: laami
                }
                onClicked: console.log(laami)
            }
        }

        ListModel {
            id:lammit
            ListElement {
                laami: 901
            }
            ListElement {
                laami: 902
            }
        }*/

    }

    onDone: {
        lamSearch.focus = false
        if (result == DialogResult.Accepted) {
            lamID = lamSearch.text

        }
    }
}
