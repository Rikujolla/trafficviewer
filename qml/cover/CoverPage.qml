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
import "../pages"

//Cover {
CoverBackground {
    //opacity: 0.2
    Label {
        id: label
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        text: qsTr("LAM ") + coverLam
        anchors.topMargin: Theme.paddingLarge
        x: Theme.paddingLarge
    }
    Label {
        id: label2
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: label.bottom
        //text: speedView ? speedOrCars + "km/h" : speedOrCars + "cars/h"
        text: speedLAM + qsTr("km/h")
        anchors.topMargin: Theme.paddingLarge
        wrapMode: Text.WordWrap
    }
    Label {
        id: label3
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: label2.bottom
        text: carsLAM*12 + qsTr("cars/h")
        anchors.topMargin: Theme.paddingLarge
        wrapMode: Text.WordWrap
    }

    /*Timer {
        //update
    }*/

    CoverActionList {
        id: coverAction

        /*CoverAction {
            iconSource: "image://theme/icon-cover-next"
        }

        CoverAction {
            iconSource: "image://theme/icon-cover-pause"
        }*/
    }
}


