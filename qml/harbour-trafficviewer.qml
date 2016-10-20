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
import QtQuick.LocalStorage 2.0
import "pages/tables.js" as Mytables
import "pages"

ApplicationWindow
{
    initialPage: Component { MapPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: Orientation.All
    _defaultPageOrientations: Orientation.All

    property bool testData : false // Used to test
    property bool useLocation : true // When starting, GPS is used
    property bool dataLoad : true // Selects if data is reloaded or updated to screen
    property bool dataReaded : false // Tells if the data has been readed to map recently
    property bool locationsLoaded : false
    property string timeLamUpdated : "" //Stores the last update value not to update too often
    property bool speedView : true // Default speedView, when false cars/hour view
    property bool chView : false  // used to update plot vieW
    property int lammiSelected  // selected LAM from the map
    property int lammiPair // selected LAM pair from the map
    property real lammiLatti // Favuorite LAM latitude
    property real lammiLongi // Favourite LAM longitude
    property int favourSelected: 902  // selected LAM for your favourite
    property int favourPair: 1 // selected LAM pair your favourite
    property real favourLatti: 62.655165527248755 // Favourite LAM latitude
    property real favourLongi: 25.73116712970659 // Favourite LAM longitude
    property int tempTime
    property int coverLam  // Selected LAM to cover
    property int coverPair // Selected LAM direction to cover
    property int speedOrCars  // Either Speed or Cars in cover
    property int speedLAM // Speed to cover
    property int carsLAM // Cars to cover
    property real currentLat // To record currentLat: of the mapcenter
    property real currentLong // To record currentLong: of the map center
    property real gpsLat // Current position, latitude
    property real gpsLong // Current position, longitude
    property real differenceExists  // calculates screen difference to currentlatlong
    property int gpsUpdateRate : 9000

    XmlListModel {
        id: lamStations
        source: !testData ? "data/lamstations.xml" : "https://github.com/Rikujolla/trafficviewer/tree/master/qml/data/lamstations.xml"
        query: "/xml/lam_station"
        //query: "/lamdynamicdata/lamdata"
        //namespaceDeclarations: "declare namespace soap ='http://schemas.xmlsoap.org/soap/envelope/';
        //                        declare default element namespace 'http://tie.digitraffic.fi/sujuvuus/schemas';"
        XmlRole {name:"LAM_NUMERO"; query:"LAM_NUMERO/number()"}
        XmlRole {name:"TSA_NIMI"; query:"TSA_NIMI/string()"}
        XmlRole {name:"latitude"; query:"latitude/number()"}
        XmlRole {name:"longitude"; query:"longitude/number()"}
        XmlRole {name:"offlat1"; query:"offlat1/number()"}
        XmlRole {name:"offlong1"; query:"offlong1/number()"}
        XmlRole {name:"offlat2"; query:"offlat2/number()"}
        XmlRole {name:"offlong2"; query:"offlong2/number()"}
    }

    XmlListModel {
        id: lamSpecs
        source: testData ? "lamData.xml" : "http://tie.digitraffic.fi/sujuvuus/ws/lamData"
        query: "/soap:Envelope/soap:Body/LamDataResponse/lamdynamicdata/lamdata"
        //query: "/lamdynamicdata/lamdata"
        namespaceDeclarations: "declare namespace soap ='http://schemas.xmlsoap.org/soap/envelope/';
                                declare default element namespace 'http://tie.digitraffic.fi/sujuvuus/schemas';"
        //XmlRole {name:"localtime"; query:"timestamp/localtime/string()"} //not working
        XmlRole {name:"lamid"; query:"lamid/number()"; isKey:true}
        XmlRole {name:"lamLocaltime"; query:"measurementtime/localtime/string()"}
        XmlRole {name:"trafficvolume1"; query:"trafficvolume1/number()"}
        XmlRole {name:"trafficvolume2"; query:"trafficvolume2/number()"}
        XmlRole {name:"averagespeed1"; query:"averagespeed1/number()"}
        XmlRole {name:"averagespeed2"; query:"averagespeed2/number()"}
    }

    ListModel {
        id: lamPoints
        ListElement {
            iidee:901
            pair: 0
            //neim:"L_vt4_Tikkakoski"
            latti:62.3695273
            longi:25.70485293
            veloc:999
            cars:111
        }
    }

    ListModel {
        id: lamBarePoints
        ListElement {
            iidee:901
            pair: 0
            //neim:"L_vt4_Tikkakoski"
            latti:62.3695273
            longi:25.70485293
            veloc:998
        }
    }


    ListModel {
        id:dataList
        ListElement {
            timestamp: "Tue Jun 07 2016 06:00:00 GMT+0300"
            speed:60.0
            age:1000
        }
        ListElement {
            timestamp: "Tue Jun 07 2016 07:00:00 GMT+0300"
            speed:66.0
            age:1000
        }
    }

    ListModel {
        id:dataFuture
        ListElement {
            timestamp: "Wed Jun 15 2016 07:00:00 GMT+0300"
            speed:66.0
        }
        ListElement {
            timestamp: "Wed Jun 15 2016 09:00:00 GMT+0300"
            speed:40.0
        }
    }

    ListModel {
        id:dataYesterday
        ListElement {
            timestamp: "Tue Jun 07 2016 10:00:00 GMT+0300"
            speed:60.0
        }
        ListElement {
            timestamp: "Tue Jun 07 2016 15:00:00 GMT+0300"
            speed:49.0
        }
    }

    ListModel { //
        id:dataHistory
        ListElement {
            timestamp: "Tue Jun 07 2016 00:00:00 GMT+0300"
            speed:55.0
        }
    }

    ListModel {
        id:dataTitles
        ListElement {
            name: "Today"
            kolor: "red"
        }
        /*ListElement {
            name: "Prognosis"
            kolor: "green"
        }*/
        ListElement {
            name: "Yesterday"
            kolor: "yellow"
        }
        ListElement {
            name: "History"
            kolor: "grey"
        }
    }

    Timer { // Loads lam locations when starting the app
        id:waitXml
        //running: !locationsLoaded && Qt.application.active
        running: true
        repeat:true
        interval: 200
        onTriggered: {
            if (lamStations.status == 1 && !locationsLoaded) {
                //waitXml.stop();
                Mytables.loadLocation()
                locationsLoaded = true
                console.log("LAM-stations data updated")
            }
            else if (locationsLoaded) {
                loadXmlIdle.start()
                waitXml.stop();
                console.log("Starting LAM measurement data capture")
            }

            else {console.log ("Updating LAM-stations data", lamStations.status)}
        }
    }


    Timer {
        id:loadXmlIdle
        //running: !Qt.application.active
        running: false
        repeat:true
        interval: !Qt.application.active ? 120000 : 30000
        triggeredOnStart: true
        onTriggered: {
                lamSpecs.reload()
                waitXmlLoadIdle.start()
                console.log("Starting traffic XML-data load")
        }
    }

    Timer {
        id:waitXmlLoadIdle
        running: false
        repeat:true
        interval: 1000
        onTriggered: {
            if (lamSpecs.status == 1) {
                waitXmlLoadIdle.stop();
                Mytables.addData()
                dataLoad = false
                console.log("Traffic XML-data added to SQL table", dataLoad, lamSpecs.status)
            }
            else {console.log ("Loading traffic XML-data", lamSpecs.status)}
        }
    }

    //onComponentCompleted: console.log("LAM", lamStations.get(0).LAM_NUMERO)
}


