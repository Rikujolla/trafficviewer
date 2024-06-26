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
import org.nemomobile.dbus 2.0
import "pages/tables.js" as Mytables
import "pages"
import "components/setting.js" as Mysettings
import harbour.trafficviewer.updater 1.0
import "jsonpath.js" as JSONPath

ApplicationWindow
{
    initialPage: Component { MapPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    //cover: null
    allowedOrientations: Orientation.All
    _defaultPageOrientations: Orientation.All

    property bool testData : false // Used to test
    property bool useLocation : false // When starting, GPS is used
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
    property int favourSelected: 448  // selected LAM for your favourite
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
    property int gpsUpdateRate : 0
    property bool leftHanded : false // Tells, if the user wants to use thhe phone with left hand
    property bool searchDone : false
    property real searchLatti
    property real searchLongi
    property bool drawYesterdayValues: false
    property bool cumulativeView: false
    property bool differenceView: false // View difference to mean
    property int thedayQuality // the quality of the day data
    property int doublesAway:0 // Saves localtime when double values have been removed
    property int dbVersion:9 //
    property int dataIdleUpdateRate : 120000
    property string test: "text"
    property bool useTimedclient: false
    property bool useTimedclientCh : false //Logging if useTimedclient has been changed
    property int dataDifference :42 //
    property bool developing: false // To print console logs when developing

    XmlListModel {
        id: lamStations
        source: !testData ? "data/lamstations.xml" : "https://github.com/Rikujolla/trafficviewer/tree/master/qml/data/lamstations.xml"
        query: "/xml/lam_station"
        //query: "/lamdynamicdata/lamdata"
        //namespaceDeclarations: "declare namespace soap ='http://schemas.xmlsoap.org/soap/envelope/';
        //                        declare default element namespace 'http://tie.digitraffic.fi/sujuvuus/schemas';"
        XmlRole {name:"NUMERO"; query:"NUMERO/number()"}
        XmlRole {name:"LAM_NUMERO"; query:"LAM_NUMERO/number()"}
        XmlRole {name:"TSA_NIMI"; query:"TSA_NIMI/string()"}
        XmlRole {name:"latitude"; query:"latitude/number()"}
        XmlRole {name:"longitude"; query:"longitude/number()"}
        XmlRole {name:"offlat1"; query:"offlat1/number()"}
        XmlRole {name:"offlong1"; query:"offlong1/number()"}
        XmlRole {name:"offlat2"; query:"offlat2/number()"}
        XmlRole {name:"offlong2"; query:"offlong2/number()"}
    }

    /*XmlListModel {
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
    }*/

    JSONListModel {
        id: lamSpecs1
        source: "https://tie.digitraffic.fi/api/tms/v1/stations/23003/data"
        //query: "$..sensorValues[?((@.roadStationId==23901 || @.roadStationId==23902)&& (@.id==5054 || @.id==5119))]"
        query: "$..sensorValues[*]"
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
            age:10
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
            name: "The day"
            kolor: "red"
        }
        /*ListElement {
            name: "Prognosis"
            kolor: "green"
        }*/
        ListElement {
            name: "The day before"
            kolor: "yellow"
        }
        ListElement {
            //: Translation not yet working. It is a part of a list element and needs more coding
            name: QT_TR_NOOP("The history")
            kolor: "grey"
        }
    }

    Forceup {
        id: fupdater
        onReadyRead: test = readAll();
    }

    Timer { //Wakeup timer
        id: wakeupTimer
        running: false
        repeat: true
        interval: !Qt.application.active ? dataIdleUpdateRate : 30000
        onTriggered:{

            if (loadXmlIdle.running || waitXmlLoadIdle.running){
                //console.log("test Waketimer did nothing")
                /*var xhr1 = new XMLHttpRequest;
                var json1 = ""
                var source1 = "https://tie.digitraffic.fi/api/v1/data/tms-data/"
                xhr1.open("GET", source1);
                xhr1.onreadystatechange = function() {
                    if (xhr1.readyState == XMLHttpRequest.DONE)
                        json1 = xhr1.responseText;
                }
                xhr1.send();
                var objectarray = JSON.parse(json1)
                console.log("time updated", objectarray.dataUpdatedTime)*/

            }
            else {
                loadXmlIdle.start();
                //console.log("Waketimer started download timer")
                /*if (lamSpecs1.source == "https://tie.digitraffic.fi/api/v1/data/tms-data/") {
                    lamSpecs1.source = "https://tie.digitraffic.fi/api/v1/data/tms-data/23001"
                    console.log("Waketimer started download small")
                }

                else {
                    lamSpecs1.source = "https://tie.digitraffic.fi/api/v1/data/tms-data/"
                    console.log("Waketimer started download all")
                }*/
                /*var xhr1 = new XMLHttpRequest;
                var json1 = ""
                var source1 = "https://tie.digitraffic.fi/api/v1/data/tms-data/"
                xhr1.open("GET", source1);
                xhr1.onreadystatechange = function() {
                    if (xhr1.readyState == XMLHttpRequest.DONE)
                        json1 = xhr1.responseText;
                }
                xhr1.send();*/
                var objectarray = JSON.parse(lamSpecs1.json)
                //console.log("time updated", objectarray.dataUpdatedTime, objectarray.stations[0].id, objectarray.stations[0].sensorValues[0].id, objectarray.stations[0].sensorValues.length)
            }
        }
    }

    DBusAdaptor {
        id: dbus
        bus: DBus.SessionBus
        service: 'as.kiu'
        iface: 'as.kiu'
        path: '/'
        //dbus-send --session --type=method_call --dest=as.kiu / as.kiu.update
        function update() {
            var string2 = "-eAPPLICATION=Rush_hour;TITLE=Wake_up;ticker=" + dataIdleUpdateRate/1000
            if (!useTimedclient){
                //console.log("Stop timedclient")
            }
            else if (loadXmlIdle.running || waitXmlLoadIdle.running){
                //fupdater.start("timedclient-qt5",["-awhenDue;runCommand=dbus-send --session --type=method_call --dest=as.kiu / as.kiu.update", "-eAPPLICATION=Rush_hour;TITLE=Wake_up;ticker=180"]);
                fupdater.start("timedclient-qt5",["-awhenDue;runCommand=dbus-send --session --type=method_call --dest=as.kiu / as.kiu.update", string2]);
                //console.log("Timedclient did nothing ", string2)
            }
            else {
                //fupdater.start("timedclient-qt5",["-awhenDue;runCommand=dbus-send --session --type=method_call --dest=as.kiu / as.kiu.update", "-eAPPLICATION=Rush_hour;TITLE=Wake_up;ticker=180"]);
                fupdater.start("timedclient-qt5",["-awhenDue;runCommand=dbus-send --session --type=method_call --dest=as.kiu / as.kiu.update", string2]);
                loadXmlIdle.start();
                //console.log("Timedclient started download ", string2)
            }
        }
    }

    Timer { // Loads lam locations when starting the app and start relevant timers
        id:waitXml
        //running: !locationsLoaded && Qt.application.active
        running: true
        repeat:true
        interval: 200
        onTriggered: {
            var string2 = "-eAPPLICATION=Rush_hour;TITLE=Wake_up;ticker=" + dataIdleUpdateRate/1000
            if (dbVersion < 15) {
                /*do nothing before db update*/
                Mytables.checkifEmptydb();
            }
            else if (lamStations.status == 1 && !locationsLoaded) {
                //waitXml.stop();
                Mytables.loadLocation()
                locationsLoaded = true
                //console.log("LAM-stations data updated")
            }
            else if (locationsLoaded) {
                if (useTimedclient) {
                    //console.log(string2)
                    //fupdater.start("timedclient-qt5",["-awhenDue;runCommand=dbus-send --session --type=method_call --dest=as.kiu / as.kiu.update", "-eAPPLICATION=Rush_hour;TITLE=Wake_up;ticker=180"]);
                    fupdater.start("timedclient-qt5",["-awhenDue;runCommand=dbus-send --session --type=method_call --dest=as.kiu / as.kiu.update", string2]);
                    wakeupTimer.start();
                }
                else {
                    wakeupTimer.start();
                }
                loadXmlIdle.start()
                waitXml.stop();
                //console.log("Starting LAM measurement data capture")
            }

            else {
                //console.log ("Updating LAM-stations data", lamStations.status)
            }
        }
    }

    // Updated values according https://www.digitraffic.fi/en/road-traffic/#traffic-measurement-system-tms
    Timer { // Loads LAM-data
        id:loadXmlIdle
        //running: !Qt.application.active
        running: false
        repeat:true
        interval: !Qt.application.active ? dataIdleUpdateRate : 30000
        //interval: 60000
        triggeredOnStart: true
        onTriggered: {
            //lamSpecs.reload();
            if (lamSpecs1.source == "https://tie.digitraffic.fi/api/tms/v1/stations/data") {
                lamSpecs1.source = "https://tie.digitraffic.fi/api/tms/v1/stations/23003/data"
                //console.log("Loader started download small")
            }

            else {
                lamSpecs1.source = "https://tie.digitraffic.fi/api/tms/v1/stations/data"
                //console.log("Loader started download all")
            }

            waitXmlLoadIdle.start();
            loadXmlIdle.stop();
            //console.log("Starting traffic XML-data load")
        }
    }

    Timer { // Waits LAM-data loaded
        id:waitXmlLoadIdle
        running: false
        repeat:true
        interval: 4000
        onTriggered: {
            //if (lamSpecs.status == 1) {
                waitXmlLoadIdle.stop();
                Mytables.addData()
                dataLoad = false
                //console.log("Traffic XML-data added to SQL table", dataLoad, lamSpecs.status)
            //}
            //else {
                //console.log ("Loading traffic XML-data", lamSpecs.status)
                //console.log(lamSpecs1.model.get(0).roadStationId,lamSpecs1.model.get(0).id,lamSpecs1.model.get(0).sensorValue,lamSpecs1.model.get(0).name,lamSpecs1.model.get(0).sensorUnit)
            //}
        }
    }

    Component.onCompleted: {
        //console.log(lamSpecs1.model.get(0).sensorValue)

        Mysettings.loadSettings()
    }
}


