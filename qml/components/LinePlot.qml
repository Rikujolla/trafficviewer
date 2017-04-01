/*
	Original Copyright (c) 2013 Jussi Sainio
 
	Modified to support multiple lines for valuelogger 2014 Kimmo Lindholm

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
	THE SOFTWARE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0
import "../pages/tables.js" as Mytables

Rectangle
{
    id: chart
    width: parent.width
    height: parent.height
    color: "transparent"

    //property var dataListModel: null
    //property var dataListModel: [80, 85]
    //property var parInfoModel: null
    //property string column: "value"
    property int daysBefore: 0 // used to visualize previous days
    property bool plotDraggingActive //to remove errormessage, not knowing why to use this boolean

    property real min : 0.0
    property real max : 140.0

    property int fontSize: 14
    property bool fontBold: true

    property date xstart : new Date("2016-06-15T05:48:00")
    property date xend : new Date("2016-06-15T06:37:00")

    function distanceX(p1, p2)
    {
        return Math.max(p1.x, p2.x) - Math.min(p1.x, p2.x)
    }
    function distanceY(p1, p2)
    {
        return Math.max(p1.y, p2.y) - Math.min(p1.y, p2.y)
    }

    function getMinMax()
    {
        var last = dataHistory.count - 1;
        var first = 0;
        var koo = 1.0
        if (!speedView) {if (!cumulativeView) {koo = 12.0} else {koo = 2.0}}

        for (var i = first; i <= last; i++)
        {
            var l = dataHistory.get(i).speed * koo

            if (l > max){
                max = l-l%700+700;
            }
        }

        first = 0;
        last = last = dataList.count - 1;

        for (i = first; i <= last; i++)
        {
            l = dataList.get(i).speed * koo

            if (l > max){
                max = l-l%700+700;
            }
        }

        first = 0;
        last = last = dataYesterday.count - 1;

        for (i = first; i <= last; i++)
        {
            l = dataYesterday.get(i).speed * koo

            if (l > max){
                max = l-l%700+700;
            }
        }

    }

    function updateVerticalScale()
    {

        var m = (((max-min))/canvas.height)*pinchZoom.deltaY

        max = max - m/2
        min = min + m/2

        var d = (((max-min))/canvas.height)*pinchMove.movementY

        max = max + d
        min = min + d

        valueMax.text = max.toFixed(2)
        valueMin.text = min.toFixed(2)

        for (var midIndex=0; midIndex<6; midIndex++)
            valueMiddle.itemAt(midIndex).text = (min+(((max-min) / 7.)*(midIndex+1))).toFixed(2)

    }

    function updateHorizontalScale()
    {
        var mm = (((xstart.getTime() - xend.getTime()))/canvas.width)*pinchZoom.deltaX

        var t = new Date()
        t.setTime(xstart.getTime() - Math.floor(mm))
        xstart = t

        var u = new Date()
        u.setTime(xend.getTime() + Math.floor(mm))
        xend = u

        var dd = (((xstart.getTime() - xend.getTime()))/canvas.width)*pinchMove.movementX

        t = new Date()
        t.setTime(xstart.getTime() + Math.floor(dd))
        xstart = t

        u = new Date()
        u.setTime(xend.getTime() + Math.floor(dd))
        xend = u

        xStart.text = Qt.formatDateTime(xend, "dd.MM.yyyy hh:mm")
        xEnd.text = Qt.formatDateTime(xstart, "dd.MM.yyyy hh:mm")
    }

    function update()
    {
        canvas.requestPaint()
    }

    IconButton {
        id: nowIcon
        z:15
        visible:legend.opacity == 1.0
        anchors.bottom: parent.top
        anchors.bottomMargin: -Screen.height/30
        //anchors.bottomMargin: 20
        //anchors.right: leftHanded ? undefined : page.right
        //anchors.left: leftHanded  ? page.left : undefined
        anchors.horizontalCenter: parent.horizontalCenter
        icon.source: "image://theme/icon-m-day?" + (pressed
                                                    ? Theme.highlightColor
                                                    : Theme.secondaryHighlightColor)
        onClicked: {
            daysBefore = 0;
            Mytables.drawSpeed(daysBefore)
            canvas.requestPaint()
            //console.log("now", daysBefore)
        }
    }

    IconButton {
        id: backIcon
        z:15
        visible:legend.opacity == 1.0
        anchors.bottom: parent.top
        anchors.bottomMargin: -Screen.height/30
        anchors.right: nowIcon.left
        icon.source: "image://theme/icon-m-back?" + (pressed
                                                    ? Theme.highlightColor
                                                    : Theme.secondaryHighlightColor)
        onClicked: {
            daysBefore++;
            Mytables.drawSpeed(daysBefore)
            canvas.requestPaint()
            //console.log("back", daysBefore)
        }
    }

    IconButton {
        id: fwdIcon
        z:15
        visible:legend.opacity == 1.0
        anchors.bottom: parent.top
        anchors.bottomMargin: -Screen.height/30
        //anchors.bottomMargin: 20
        //anchors.right: leftHanded ? undefined : page.right
        //anchors.left: leftHanded  ? page.left : undefined
        anchors.left: nowIcon.right
        icon.source: "image://theme/icon-m-forward?" + (pressed
                                                    ? Theme.highlightColor
                                                    : Theme.secondaryHighlightColor)
        onClicked: {
            daysBefore > 0 ? daysBefore-- : daysBefore = 0;
            Mytables.drawSpeed(daysBefore)
            canvas.requestPaint()
            //console.log("forward", daysBefore)
        }
    }
    Text
    {
        id: xStart
        color: Theme.primaryColor
        font.pointSize: fontSize
        font.bold: fontBold
        wrapMode: Text.WordWrap
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.top: parent.top
        text: "unk"
    }

    Text
    {
        id: xEnd
        color: Theme.primaryColor
        font.pointSize: fontSize
        font.bold: fontBold
        wrapMode: Text.WordWrap
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.top
        horizontalAlignment: Text.AlignRight
        text: "unk"
    }

    Text
    {
        id: valueMax
        color: Theme.primaryColor
        width: 50
        font.pointSize: fontSize
        font.bold: fontBold
        wrapMode: Text.WordWrap
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: xEnd.bottom
        text: "unk"
    }

    Text
    {
        id: valueMin
        color: Theme.primaryColor
        width: 50
        font.pointSize: fontSize
        font.bold: fontBold
        wrapMode: Text.WordWrap
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.bottom: parent.bottom
        text: "unk"
    }

    Repeater
    {
        id: valueMiddle
        model:6

        Text
        {
            color: Theme.primaryColor
            width: 50
            font.pointSize: fontSize
            font.bold: fontBold
            wrapMode: Text.WordWrap
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: (index+1) * ((parent.height/7) - fontSize/2 )
            text: "unk"
            z: 10
        }
    }

    ListView
    {
        x: 150
        y: 100
        z: 11
        height: fontSize*1.2*10
        id: legend
        model: dataTitles
        //model:1

        delegate: ListItem
        {
            contentHeight: fontSize*2

            Row
            {
                id: legendRow
                height: fontSize*2
                spacing: 10
                Rectangle
                {
                    id: legendColor
                    width: 30
                    height: 3
                    //color: plotcolor
                    color: kolor
                }
                Text
                {
                    //text: name
                    text: qsTr(dataTitles.get(index).name) + (index == 0 && cumulativeView ? ", quality " + thedayQuality + "%" : "")
                    color: Theme.primaryColor
                    font.pointSize: fontSize
                    font.bold: fontBold
                    anchors.verticalCenter: legendColor.verticalCenter
                }
            }
        }

        Behavior on opacity
        {
            FadeAnimation {}
        }

        onOpacityChanged:
        {
            if (opacity == 1.0)
                legendVisibility.start()
        }

        Timer
        {
            id: legendVisibility
            interval: 5000
            running: Qt.application.active && true
            onTriggered:  legend.opacity = 0.0
                //PropertyAnimation { duration: 500; target: legend; property: "opacity"; to: 0 }
        }

        Timer
        {
            id: changeWiev
            interval: 60
            running: Qt.application.active && chView
            onTriggered:  {
                canvas.requestPaint()
                //console.log("latest ", dataList.get(dataList.count-1).speed)
                chView = false
                //console.log(" change view")
            }
                //PropertyAnimation { duration: 500; target: legend; property: "opacity"; to: 0 }
        }

    }

    Canvas
    {
        id: canvas
        width: parent.width
        anchors.top: xEnd.bottom
        anchors.bottom: valueMin.top
        //renderTarget: Canvas.FramebufferObject
        renderTarget: Canvas.Image
        antialiasing: true

        property int first: 0
        property int last: 0

        function drawBackground(ctx)
        {
            ctx.save();

            // clear previous plot
            ctx.clearRect(0,0,canvas.width, canvas.height);

            // fill translucent background
            // ctx.fillStyle = Qt.rgba(0,0,0,0.5);
            // ctx.fillRect(0, 0, canvas.width, canvas.height);

            // draw grid lines
            ctx.strokeStyle = Qt.rgba(1,1,1,0.3);
            ctx.beginPath();

            var cols = 6.0;
            var rows = 7.0;

            for (var i = 0; i < rows; i++)
            {
                ctx.moveTo(0, i * (canvas.height/rows));
                ctx.lineTo(canvas.width, i * (canvas.height/rows));
            }
            for (i = 0; i < cols; i++)
            {
                ctx.moveTo(i * (canvas.width/cols), 0);
                ctx.lineTo(i * (canvas.width/cols), canvas.height);
            }
            ctx.stroke();

            ctx.restore();
        }

        function drawHistory(ctx, color)
        {
            ctx.save();
            ctx.globalAlpha = 1.0;
            ctx.strokeStyle = color;
            ctx.lineWidth = 3;
            ctx.beginPath();

            for (var i = 0; i < dataHistory.count; i++)
            {
                var s = new Date(dataHistory.get(i).timestamp)
                //console.log(s)
                var x = (s.getTime() - xstart)/(xend-xstart);
                var y = (dataHistory.get(i).speed-min)/(max-min);
                if (speedView) {} else if (!cumulativeView){y=y*12} else {y=y*2}; //hardcoding should be parametrized
                if (i == 0)
                {
                    ctx.moveTo(x * canvas.width, (1-y) * canvas.height);
                }
                else
                {
                    ctx.lineTo(x * canvas.width, (1-y) * canvas.height);
                }
            }
            ctx.stroke();
            ctx.restore();
        }

        function drawYesterday(ctx, color)
        {
            ctx.save();
            ctx.globalAlpha = 1.0;
            ctx.strokeStyle = color;
            ctx.lineWidth = 3;
            ctx.beginPath();

            for (var i = 0; i < dataYesterday.count; i++)
            {
                var s = new Date(dataYesterday.get(i).timestamp)
                var x = (s.getTime() - xstart)/(xend-xstart);
                var y = (dataYesterday.get(i).speed-min)/(max-min);
                if (speedView) {} else if (!cumulativeView){y=y*12} else{y=y*2}; //hardcoding should be parametrized
                if (i == 0)
                {
                    ctx.moveTo(x * canvas.width, (1-y) * canvas.height);
                }
                else
                {
                    ctx.lineTo(x * canvas.width, (1-y) * canvas.height);
                }
            }
            ctx.stroke();
            ctx.restore();
        }

        function drawPlot(ctx, color)
        {
            ctx.save();
            ctx.globalAlpha = 1.0;
            ctx.strokeStyle = color;
            ctx.lineWidth = 3;
            ctx.beginPath();

            for (var i = 0; i < dataList.count; i++)
            {
                var s = new Date(dataList.get(i).timestamp)
                var x = (s.getTime() - xstart)/(xend-xstart);
                var y = (dataList.get(i).speed-min)/(max-min);
                if (speedView) {} else if (!cumulativeView){y=y*12} else{y=y*2}; //hardcoding should be parametrized
                if (i == 0)
                {
                    ctx.moveTo(x * canvas.width, (1-y) * canvas.height);
                }
                else
                {
                    ctx.lineTo(x * canvas.width, (1-y) * canvas.height);
                }
            }
            ctx.stroke();
            ctx.restore();
        }

        function drawFuture(ctx, color)
        {
            ctx.save();
            ctx.globalAlpha = 1.0;
            ctx.strokeStyle = color;
            ctx.lineWidth = 3;
            ctx.beginPath();

            for (var i = 0; i < dataFuture.count; i++)
            {
                var s = new Date(dataFuture.get(i).timestamp)
                var x = (s.getTime() - xstart)/(xend-xstart);
                var y = (dataFuture.get(i).speed-min)/(max-min);
                if (speedView) {} else if (!cumulativeView){y=y*12} else{y=y*2}; //hardcoding should be parametrized
                if (i == 0)
                {
                    ctx.moveTo(x * canvas.width, (1-y) * canvas.height);
                }
                else
                {
                    ctx.lineTo(x * canvas.width, (1-y) * canvas.height);
                }
            }
            ctx.stroke();
            ctx.restore();
        }

        onCanvasSizeChanged: requestPaint();

        onPaint:
        {
            Mytables.drawSpeed(daysBefore)

            var ctx = canvas.getContext("2d");

            ctx.globalCompositeOperation = "source-over";
            ctx.lineWidth = 2;

            drawBackground(ctx);

            /*if (!dataListModel)
            {
                console.log("not ready")
                return;
            }*/

            // assign some timestamp which is in range as start/end default for further expanding
            //xstart = new Date(dataListModel[0][0]["timestamp"])
            //now.set(Calendar.HOUR_OF_DAY, 0);
            var time = new Date().getTime()
            //var offset = new Date().getTimezoneOffset()
            var offset = new Date(time-daysBefore*24*60*60*1000).getTimezoneOffset()
            //console.log("offset", offset)
            xstart = new Date(time + offset*60*1000 - time%(24*60*60*1000) - daysBefore*24*60*60*1000) //RLAH
            xend = new Date(time + 24*60*60*1000 + offset*60*1000- time%(24*60*60*1000) - daysBefore*24*60*60*1000) //RLAH

            speedView ? max = 140.0 : max = 350.0;

            getMinMax()

            updateVerticalScale()
            updateHorizontalScale()

            drawHistory(ctx, "grey")
            if (drawYesterdayValues == true) {
                drawYesterday(ctx, "yellow")
            }
            drawPlot(ctx, "red");
            drawFuture(ctx, "green");

            /*for (var n=0; n<dataList.length; n++)
            {
                //drawPlot(ctx, dataListModel[n], parInfoModel.get(n).plotcolor, column);
                drawPlot(ctx, dataListModel[n], "red");
            }*/
        }

        PinchArea
        {
            id: pinchZoom
            anchors.fill: canvas

            property real iX
            property real iY
            property real deltaX : 0
            property real deltaY : 0

            property point lv1
            property point lv2

            property bool scaleInX

            onPinchFinished:
            {
            }
            onPinchStarted:
            {
                iX = distanceX(pinch.point1, pinch.point2)
                iY = distanceY(pinch.point1, pinch.point2)

                scaleInX = (iX > iY)
            }
            onPinchUpdated:
            {
                if (pinch.point1 !== pinch.point2)
                {
                    lv1 = pinch.point1
                    lv2 = pinch.point2
                }

                if (scaleInX)
                {
                    var dX = distanceX(lv1, lv2) - iX
                    iX = distanceX(lv1, lv2)
                    deltaX += dX
                }
                else
                {
                    var dY = distanceY(lv1, lv2) - iY
                    iY = distanceY(lv1, lv2)
                    deltaY += dY
                }

                canvas.requestPaint()

            }
            MouseArea
            {
                property real iX
                property real iY
                property real movementX : 0
                property real movementY : 0

                id: pinchMove
                anchors.fill: parent

                onClicked: legend.opacity = 1.0

                onPressed:
                {
                    plotDraggingActive = true
                    iX = mouseX
                    iY = mouseY
                }
                onDoubleClicked:
                {
                    movementX = 0
                    movementY = 0
                    pinchZoom.deltaX = 0
                    pinchZoom.deltaY = 0

                    canvas.requestPaint()
                }
                onPositionChanged:
                {
                    var dX = mouseX - iX
                    iX = mouseX
                    movementX += dX
                    var dY = mouseY - iY
                    iY = mouseY
                    movementY += dY

                    canvas.requestPaint()
                }
                onReleased: plotDraggingActive = false
            }
        }

    }
}
