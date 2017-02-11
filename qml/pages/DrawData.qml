/*Copyright (c) 2014-2015 Kimmo Lindholm

  Modified for trafficviewer by Riku Lahtinen

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0
import "../components"
import "tables.js" as Mytables
import "../components/setting.js" as Mysettings

Page
{
    id: drawDataPage
    //property var dataList : []
    //property var parInfo : null

    //backNavigation: !plotDraggingActive

    allowedOrientations: Orientation.Portrait | Orientation.Landscape

    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            /*MenuItem {
                text: qsTr("Help")
                onClicked: pageStack.push(Qt.resolvedUrl("Help.qml"))
            }
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("About.qml"))
            }*/
            MenuItem {
                text: qsTr("Select LAM to my favourite")
                onClicked: {
                    favourSelected = lammiSelected
                    favourPair = lammiPair
                    favourLatti = lammiLatti
                    favourLongi = lammiLongi
                    Mysettings.saveSettings()
                }
            }
            MenuItem {
                text: qsTr("Select LAM to cover")
                onClicked: {
                    coverLam = lammiSelected
                    coverPair = lammiPair
                    Mysettings.saveSettings()
                    //plot.canvas.requestPaint()
                }
            }
            MenuItem {
                text: speedView ? qsTr("To cars per hour view") : qsTr("To speed view")
                onClicked: {
                    //console.log("Speed to car amounts")
                    speedView = !speedView
                    chView = true
                    //plot.canvas.requestPaint()
                }
            }
        }

        /*PushUpMenu {
            MenuItem {
                text: qsTr("Help")
                onClicked: pageStack.push(Qt.resolvedUrl("Help.qml"))
            }
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("About.qml"))
            }
        }*/

    PageHeader
    {
        id: ph
        title: speedView ? qsTr("Speed, LAM") + " " + lammiSelected : qsTr("Cars per hour, LAM") + " " + lammiSelected
    }


    LinePlot
    {
        //dataListModel: dataList
        //parInfoModel: parInfo
        id: plot
        width: parent.width - Theme.paddingLarge
        height: parent.height
        anchors.left: parent.left
        anchors.leftMargin: Theme.paddingLarge/2
        anchors.top: ph.bottom
        anchors.bottom: parent.bottom
    }
}
}

