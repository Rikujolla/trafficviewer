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


Page {
    id: page

    SilicaFlickable {
        anchors.fill: parent

        /*PullDownMenu {

            MenuItem {
                text: qsTr("Back to settings")
                onClicked: pageStack.pop()
            }
        }*/

        contentHeight: column.height

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("Help page")
            }

            SectionHeader { text: qsTr("Map view") }
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
                text:
                {
                    qsTr("Speed limit signs:") + "\n" +
                            "-" + qsTr("Yellow inside tells the data is less than five minutes old") + "\n" +
                            "-" + qsTr("Orange inside tells the data is more than five minutes but less than ten minutes old") + "\n" +
                            "-" + qsTr("Red inside tells the data is more than ten minutes old") + "\n" +
                            "-" + qsTr("Pure red is a station with no data in the phone or the data aquisition is on going") + "\n" +
                            "-" + qsTr("In the blue additional panel below the speed limit sign cars per hour is shown") + "\n" +
                    qsTr("Icons on the right side:") + "\n" +
                            "-" + qsTr("Center the map to your location") + "\n" +
                            "-" + qsTr("Open the settings page") + "\n" +
                            "-" + qsTr("Open your favourite LAM") + "\n" +
                            "-" + qsTr("Open search page") + "\n" +
                            "-" + qsTr("Open this help page") + "\n" +
                            "-" + qsTr("Open about page")
                }
            }

            SectionHeader { text: qsTr("Chart view") }
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
                text: {
                    qsTr("The chart view can be entered by tapping the speed limit sign or the blue additional panel.") + "\n" +
                       qsTr("The day can be changed from the icons above the cart. Icons become visible by tapping the screen. As a default history mean data curve and the selected day data are shown. The day before data can also be shown by the switch on the settings page.")
                }
            }

//loppusulkeet
        }
    }
}
