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
import QtQuick.XmlListModel 2.0

Page {
    //onStatusChanged: console.log(lamSpecs.get(0).localtime)
    id: page
    SilicaListView {
        id: listView
        model: lamSpecs
        anchors.fill: parent

        /*PullDownMenu {
            MenuItem {
                text: qsTr("Draw Data")
                onClicked: pageStack.push(Qt.resolvedUrl("DrawData.qml"))
            }
            MenuItem {
                text: qsTr("Loc List")
                onClicked: pageStack.push(Qt.resolvedUrl("LocList.qml"))
            }
        }*/

        header: PageHeader {
            id:headeri
            title: ("Current LAM data")
        }


        delegate: BackgroundItem {
            id: delegate

            Label {
                //var text0 = lamSpecs.get(0).localtime + "\n" + "LAM"
                x: Theme.paddingLarge
                text: "LAM" + lamid + ", " + trafficvolume1 + ", " + averagespeed1 + ", " + trafficvolume2 + ", " + averagespeed2
                anchors.verticalCenter: parent.verticalCenter
                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
            }
            onClicked: {
                //console.log("Clicked " + index)
                //console.log(lamSpecs.get(0).lamid, lamSpecs.get(index).lamLocaltime)
            }
        }

        /*XmlListModel {
            id: lamSpecs
            source: testData ? "lamData.xml" : "http://tie.digitraffic.fi/sujuvuus/ws/lamData"
            query: "/soap:Envelope/soap:Body/LamDataResponse/lamdynamicdata/lamdata"
            //query: "/lamdynamicdata/lamdata"
            namespaceDeclarations: "declare namespace soap ='http://schemas.xmlsoap.org/soap/envelope/';
                                    declare default element namespace 'http://tie.digitraffic.fi/sujuvuus/schemas';"
            XmlRole {name:"localtime"; query:"timestamp/localtime/string()"}
            XmlRole {name:"lamid"; query:"lamid/number()"}
            XmlRole {name:"lamLocaltime"; query:"measurementtime/localtime/string()"}
            XmlRole {name:"trafficvolume1"; query:"trafficvolume1/number()"}
            XmlRole {name:"trafficvolume2"; query:"trafficvolume2/number()"}
            XmlRole {name:"averagespeed1"; query:"averagespeed1/number()"}
            XmlRole {name:"averagespeed2"; query:"averagespeed2/number()"}
        }*/



        VerticalScrollDecorator {}
    }
}





