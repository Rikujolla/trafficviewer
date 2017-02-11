function loadLocation() {

    var db = LocalStorage.openDatabaseSync("TrafficviewerDB", "1.0", "Traffic viewer database", 1000000);

    db.transaction(
                function(tx) {
                    // Create the table, if not existing
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Location (lamid INTEGER, latti REAL, longi REAL, offlat1 REAL, offlong1 REAL, offlat2 REAL, offlong2 REAL)');

                    tx.executeSql('DELETE FROM Location')

                    for(var i = 0; i < lamStations.count; i++) {

                        tx.executeSql('INSERT OR REPLACE INTO Location VALUES (?,?,?,?,?,?,?)', [lamStations.get(i).LAM_NUMERO, lamStations.get(i).latitude, lamStations.get(i).longitude, lamStations.get(i).offlat1, lamStations.get(i).offlong1, lamStations.get(i).offlat2, lamStations.get(i).offlong2])
                    }

                    var rs = tx.executeSql('SELECT * FROM Location')
                    lamBarePoints.clear()
                    for(i = 0; i < rs.rows.length; i++) {
                        lamBarePoints.append({"iidee": rs.rows.item(i).lamid, "pair": 0, "latti":rs.rows.item(i).latti + rs.rows.item(i).offlat1, "longi":rs.rows.item(i).longi + rs.rows.item(i).offlong1, "veloc":rs.rows.item(i).averagespeed1})
                        lamBarePoints.append({"iidee": rs.rows.item(i).lamid, "pair": 1, "latti":rs.rows.item(i).latti + rs.rows.item(i).offlat2, "longi":rs.rows.item(i).longi + rs.rows.item(i).offlong2, "veloc":rs.rows.item(i).averagespeed2})
                    }
                }
                )
}

/// The function adds traffic data to valuetable from xml data loaded
function addData() {

    var db = LocalStorage.openDatabaseSync("TrafficviewerDB", "1.0", "Traffic viewer database", 1000000);

    db.transaction(
                function(tx) {
                    // Create the table, if not existing
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Valuetable (valamid INTEGER, lamlocaltime TEXT, trafficvolume1 INTEGER, trafficvolume2 INTEGER, averagespeed1 INTEGER, averagespeed2 INTEGER)');

                    for(var i = 0; i < lamSpecs.count; i++) {
                        tx.executeSql('INSERT INTO Valuetable VALUES (?,?,?,?,?,?)', [lamSpecs.get(i).lamid, lamSpecs.get(i).lamLocaltime, lamSpecs.get(i).trafficvolume1, lamSpecs.get(i).trafficvolume2, lamSpecs.get(i).averagespeed1, lamSpecs.get(i).averagespeed2])
                    }
                }
                )
    subsetLocation()
}

//////// Function readData() reads data to map
function readData() {

    var db = LocalStorage.openDatabaseSync("TrafficviewerDB", "1.0", "Traffic viewer database", 1000000);

    db.transaction(
                function(tx) {
                    // Create the table, if not existing
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Location (lamid INTEGER, latti REAL, longi REAL, offlat1 REAL, offlong1 REAL, offlat2 REAL, offlong2 REAL)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Valuetable (valamid INTEGER, lamlocaltime TEXT, trafficvolume1 INTEGER, trafficvolume2 INTEGER, averagespeed1 INTEGER, averagespeed2 INTEGER)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Subloc (lamid INTEGER, latti REAL, longi REAL, offlat1 REAL, offlong1 REAL, offlat2 REAL, offlong2 REAL)');

                    var rs = tx.executeSql('SELECT *, max(lamlocaltime), strftime(?,?)-strftime(?,lamlocaltime) AS age FROM Valuetable INNER JOIN Subloc ON Valuetable.valamid = Subloc.lamid GROUP BY Valuetable.valamid',['%s', 'now', '%s'])
                    //rs = tx.executeSql('SELECT * FROM Locations INNER JOIN Priorities ON Locations.theplace = Priorities.theplace INNER JOIN Cellinfo ON Priorities.theplace = Cellinfo.theplace WHERE Priorities.cell = ? AND Cellinfo.thecelli = ? ORDER BY tolerlong ASC LIMIT 1', ['1',currentCell]);

                    lamPoints.clear();
                    for(var i = 0; i < rs.rows.length; i++) {
                        //console.log(rs.rows.item(i).age)
                        lamPoints.append({"iidee": rs.rows.item(i).lamid, "pair": 0, "latti":rs.rows.item(i).latti + rs.rows.item(i).offlat1, "longi":rs.rows.item(i).longi + rs.rows.item(i).offlong1, "veloc":rs.rows.item(i).averagespeed1, "age":rs.rows.item(i).age, "cars":rs.rows.item(i).trafficvolume1})
                        lamPoints.append({"iidee": rs.rows.item(i).lamid, "pair": 1, "latti":rs.rows.item(i).latti + rs.rows.item(i).offlat2, "longi":rs.rows.item(i).longi + rs.rows.item(i).offlong2, "veloc":rs.rows.item(i).averagespeed2, "age":rs.rows.item(i).age, "cars":rs.rows.item(i).trafficvolume2})
                        if (rs.rows.item(i).lamid == coverLam) {
                            if (coverPair == 0){
                                speedLAM = rs.rows.item(i).averagespeed1
                                carsLAM = rs.rows.item(i).trafficvolume1
                            }
                            else {
                                speedLAM = rs.rows.item(i).averagespeed2
                                carsLAM = rs.rows.item(i).trafficvolume2
                            }
                        }

                    }
                }
                )
}

/// The function drawSpeed() reads data to lists to plot curves
function drawSpeed(daysbf) {

    var db = LocalStorage.openDatabaseSync("TrafficviewerDB", "1.0", "Traffic viewer database", 1000000);

    db.transaction(
                function(tx) {

                    // Create the table, if not existing
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Location (lamid INTEGER, latti REAL, longi REAL, offlat1 REAL, offlong1 REAL, offlat2 REAL, offlong2 REAL)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Valuetable (valamid INTEGER, lamlocaltime TEXT, trafficvolume1 INTEGER, trafficvolume2 INTEGER, averagespeed1 INTEGER, averagespeed2 INTEGER)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Historystable (valamid INTEGER, wday TEXT, htime INTEGER, mtr1 REAL, mtr2 REAL, msp1 REAL, msp2 REAL, nhist INTEGER)');
                    //tx.executeSql('DELETE FROM Valuetable')

                    var time = new Date().getTime()
                    var offset = new Date().getTimezoneOffset()
                    var zeero = new Date(time + offset*60*1000 - time%(24*60*60*1000)) //RLAH
                    switch (daysbf){
                    case 0:
                        var dbf = "now"
                        var dbfm = "-" + daysbf + " days"; // As above but minus
                        var dbfminus = "-" + (daysbf+1) + " days"; // Making string for sqlquery days before minus 1 as negative
                        var dbfminusmin = "-" + (daysbf+2) + " days"; // Making string for sqlquery days before minus 2 as negative
                        var dbfplus = "+" + 1 + " days"; // Making string for sqlquery daysbf plus one as negative
                        break;
                    default:
                        dbf = "+" + daysbf + " days"; // Making string for sqlquery days before
                        dbfm = "-" + daysbf + " days"; // As above but minus
                        dbfminus = "-" + (daysbf+1) + " days"; // Making string for sqlquery days before minus 1 as negative
                        dbfminusmin = "-" + (daysbf+2) + " days"; // Making string for sqlquery days before minus 2 as negative
                        dbfplus = "-" + (daysbf-1) + " days"; // Making string for sqlquery daysbf plus one as negative
                        //console.log (dbf, dbfminus, dbfplus);
                    }
                    var rs = tx.executeSql('SELECT * FROM Valuetable WHERE valamid =? AND date(lamlocaltime,?) > date(?,?,?) AND date(lamlocaltime,?) < date(?,?,?)', [lammiSelected, 'localtime', 'now',dbfminus,'localtime','localtime', 'now',dbfplus, 'localtime'])
                    if (daysbf == 0) {
                        var rw = tx.executeSql('SELECT strftime(?,?,?)AS wdaynow', ['%w', 'now', 'localtime'])
                    }
                    else {
                        rw = tx.executeSql('SELECT strftime(?,?,?,?)AS wdaynow', ['%w', 'now', dbfm, 'localtime'])
                    }
                    //console.log('The day', rw.rows.item(0).wdaynow)
                    var ry = tx.executeSql('SELECT *, datetime(lamlocaltime,?,?) AS lamtime FROM Valuetable WHERE valamid =? AND date(lamlocaltime,?) > date(?,?,?) AND date(lamlocaltime,?) < date(?,?,?)', ['+1 day','localtime', lammiSelected, 'localtime', 'now',dbfminusmin,'localtime','localtime', 'now',dbfm, 'localtime'])
                    var rt = tx.executeSql('SELECT *, datetime(htime+?,?,?) AS hhtime FROM Historystable WHERE valamid=? AND wday=?', [(time + offset*60*1000 - time%(24*60*60*1000)- daysbf*24*60*60*1000)/1000, 'unixepoch', 'localtime', lammiSelected, rw.rows.item(0).wdaynow])

                    dataList.clear();
                    for(var i = 0; i < rs.rows.length; i++) {
                        if (speedView){
                            if (lammiPair == 0) {
                                dataList.append({"timestamp":rs.rows.item(i).lamlocaltime, "speed":rs.rows.item(i).averagespeed1})
                            }
                            else {
                                dataList.append({"timestamp":rs.rows.item(i).lamlocaltime, "speed":rs.rows.item(i).averagespeed2})
                            }
                        }
                        else {
                            if (lammiPair == 0) {
                                dataList.append({"timestamp":rs.rows.item(i).lamlocaltime, "speed":rs.rows.item(i).trafficvolume1})
                            }
                            else {
                                dataList.append({"timestamp":rs.rows.item(i).lamlocaltime, "speed":rs.rows.item(i).trafficvolume2})
                            }
                        }
                    }

                    dataYesterday.clear();
                    for(i = 0; i < ry.rows.length; i++) {
                        if (speedView){
                            if (lammiPair == 0) {
                                dataYesterday.append({"timestamp":ry.rows.item(i).lamtime, "speed":ry.rows.item(i).averagespeed1})
                            }
                            else {
                                dataYesterday.append({"timestamp":ry.rows.item(i).lamtime, "speed":ry.rows.item(i).averagespeed2})
                            }
                        }
                        else {
                            if (lammiPair == 0) {
                                dataYesterday.append({"timestamp":ry.rows.item(i).lamtime, "speed":ry.rows.item(i).trafficvolume1})
                            }
                            else {
                                dataYesterday.append({"timestamp":ry.rows.item(i).lamtime, "speed":ry.rows.item(i).trafficvolume2})
                            }
                        }
                    }

                    dataHistory.clear();
                    for(i = 0; i < rt.rows.length; i++) {
                        if (speedView){
                            if (lammiPair == 0) {
                                dataHistory.append({"timestamp":rt.rows.item(i).hhtime, "speed":rt.rows.item(i).msp1/rt.rows.item(i).nhist})
                            }
                            else {
                                dataHistory.append({"timestamp":rt.rows.item(i).hhtime, "speed":rt.rows.item(i).msp2/rt.rows.item(i).nhist})
                            }
                        }
                        else {
                            if (lammiPair == 0) {
                                dataHistory.append({"timestamp":rt.rows.item(i).hhtime, "speed":rt.rows.item(i).mtr1/rt.rows.item(i).nhist})
                            }
                            else {
                                dataHistory.append({"timestamp":rt.rows.item(i).hhtime, "speed":rt.rows.item(i).mtr2/rt.rows.item(i).nhist})
                            }
                        }
                    }
                }
                )
}

/// Function maintainDb() removes double lines from Valuetable and calls makeHistory() function
function maintainDb() {

    var db = LocalStorage.openDatabaseSync("TrafficviewerDB", "1.0", "Traffic viewer database", 1000000);
    //db.vacuum()
    db.transaction(
                function(tx) {
                    // Create the table, if not existing
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Valuetable (valamid INTEGER, lamlocaltime TEXT, trafficvolume1 INTEGER, trafficvolume2 INTEGER, averagespeed1 INTEGER, averagespeed2 INTEGER)');

                    tx.executeSql('DELETE FROM Valuetable WHERE rowid NOT IN (SELECT max(rowid) FROM Valuetable GROUP BY valamid, lamlocaltime)')

                    //var rs = tx.executeSql('SELECT * FROM Valuetable')

                    //console.log("Valuetable length ", rs.rows.length)
                    //tx.executeSql('VACUUM')

                }
                )
    makeHistory();
}

/// Function subsetLocation() selects points to view to have values. Makes display response better
function subsetLocation() {
    var db = LocalStorage.openDatabaseSync("TrafficviewerDB", "1.0", "Traffic viewer database", 1000000);

    db.transaction(
                function(tx) {
                    // Create the table, if not existing
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Location (lamid INTEGER, latti REAL, longi REAL, offlat1 REAL, offlong1 REAL, offlat2 REAL, offlong2 REAL)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Subloc (lamid INTEGER, latti REAL, longi REAL, offlat1 REAL, offlong1 REAL, offlat2 REAL, offlong2 REAL)');
                    tx.executeSql('DROP TABLE Subloc')
                    tx.executeSql('CREATE TABLE Subloc AS SELECT * FROM Location WHERE abs(latti-?) < 0.12 and abs(longi-?) < 0.12', [currentLat, currentLong])

                    //var rs = tx.executeSql('SELECT * FROM Subloc')
                    //console.log("Subtable table length ", rs.rows.length)
                }
                )
}

/// Function makeHistory() permanently attaches daily values to the history curve.
function makeHistory() {
    //console.log("Make history")
    var db = LocalStorage.openDatabaseSync("TrafficviewerDB", "1.0", "Traffic viewer database", 1000000);

    db.transaction(
                function(tx) {
                    // Create the table, if not existing
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Valuetable (valamid INTEGER, lamlocaltime TEXT, trafficvolume1 INTEGER, trafficvolume2 INTEGER, averagespeed1 INTEGER, averagespeed2 INTEGER)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Location (lamid INTEGER, latti REAL, longi REAL, offlat1 REAL, offlong1 REAL, offlat2 REAL, offlong2 REAL)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS History (lamid INTEGER, latti REAL, longi REAL, offlat1 REAL, offlong1 REAL, offlat2 REAL, offlong2 REAL)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Historystable (valamid INTEGER, wday TEXT, htime INTEGER, mtr1 REAL, mtr2 REAL, msp1 REAL, msp2 REAL, nhist INTEGER)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Historytemp (valamid INTEGER, wday TEXT, htime INTEGER, mtr1 REAL, mtr2 REAL, msp1 REAL, msp2 REAL, nhist INTEGER)');
                    tx.executeSql('DROP TABLE History')
                    tx.executeSql('DROP TABLE Historytemp')
                    //tx.executeSql('CREATE TABLE History AS SELECT valamid, strftime(?,lamlocaltime) AS wday, ((strftime(?,lamlocaltime)%?)-(strftime(?,lamlocaltime)%?)%?) AS htime, total(trafficvolume1) AS mtr1, total(trafficvolume2) AS mtr2, total(averagespeed1) AS msp1, total(averagespeed2) AS msp2, count(rowid) AS nhist FROM Valuetable WHERE (strftime(?,?) - strftime(?,lamlocaltime))> ? GROUP BY valamid, htime, wday', ['%w', '%s', 86400, '%s', 86400, 600, '%s', 'now', '%s', 702000])
/* Testing section
                    var rx = tx.executeSql('SELECT valamid, strftime(?,lamlocaltime,?) AS wday, ((strftime(?,lamlocaltime,?)+?)%?)-((strftime(?,lamlocaltime,?)+?)%?)%? AS htime, total(trafficvolume1) AS mtr1, total(trafficvolume2) AS mtr2, total(averagespeed1) AS msp1, total(averagespeed2) AS msp2, count(rowid) AS nhist FROM Valuetable WHERE (strftime(?,?) - strftime(?,lamlocaltime))> ? GROUP BY valamid, htime, wday', ['%w', 'localtime','%s', 'localtime', 120, 86400, '%s', 'localtime', 120, 86400, 600,'%s', 'now', '%s', 9000])

                    for (var i = 0; i < rx.rows.length; i++) {
                        if (rx.rows.item(i).valamid == 901) {console.log(rx.rows.item(i).htime)}
                    }
                    tx.executeSql('CREATE TABLE History AS SELECT valamid, strftime(?,lamlocaltime,?) AS wday, ((strftime(?,lamlocaltime,?)+?)%?)-((strftime(?,lamlocaltime,?)+?)%?)%? AS htime, total(trafficvolume1) AS mtr1, total(trafficvolume2) AS mtr2, total(averagespeed1) AS msp1, total(averagespeed2) AS msp2, count(rowid) AS nhist FROM Valuetable WHERE (strftime(?,?) - strftime(?,lamlocaltime))> ? GROUP BY valamid, htime, wday', ['%w', 'localtime','%s', 'localtime', 120, 86400, '%s', 'localtime', 120, 86400, 600,'%s', 'now', '%s', 9000])
*/
                    tx.executeSql('CREATE TABLE History AS SELECT valamid, strftime(?,lamlocaltime,?) AS wday, ((strftime(?,lamlocaltime,?)+?)%?)-((strftime(?,lamlocaltime,?)+?)%?)%? AS htime, total(trafficvolume1) AS mtr1, total(trafficvolume2) AS mtr2, total(averagespeed1) AS msp1, total(averagespeed2) AS msp2, count(rowid) AS nhist FROM Valuetable WHERE (strftime(?,?) - strftime(?,lamlocaltime))> ? GROUP BY valamid, htime, wday', ['%w', 'localtime','%s', 'localtime', 120, 86400, '%s', 'localtime', 120, 86400, 600,'%s', 'now', '%s', 702000])
                    tx.executeSql('INSERT INTO Historystable SELECT * FROM History')
                    tx.executeSql('CREATE TABLE Historytemp AS SELECT valamid, wday, htime, total(mtr1) AS mtr1, total(mtr2) AS mtr2, total(msp1) AS msp1, total(msp2) AS msp2, sum(nhist) AS nhist FROM Historystable GROUP BY valamid, htime, wday')
                    tx.executeSql('DELETE FROM Historystable')
                    tx.executeSql('INSERT INTO Historystable SELECT * FROM Historytemp')
                    tx.executeSql('DELETE FROM Valuetable WHERE (strftime(?,?) - strftime(?,lamlocaltime))> ?', ['%s', 'now', '%s', 702000])

                }
                )
}

/// Function searchLAM() finds the lam specified by lam number
function searchLAM(lam) {

    var db = LocalStorage.openDatabaseSync("TrafficviewerDB", "1.0", "Traffic viewer database", 1000000);

    db.transaction(
                function(tx) {
                    // Create the table, if not existing
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Location (lamid INTEGER, latti REAL, longi REAL, offlat1 REAL, offlong1 REAL, offlat2 REAL, offlong2 REAL)');
                    //tx.executeSql('CREATE TABLE IF NOT EXISTS Subloc (lamid INTEGER, latti REAL, longi REAL, offlat1 REAL, offlong1 REAL, offlat2 REAL, offlong2 REAL)');
                    //tx.executeSql('DROP TABLE Subloc')
                    //tx.executeSql('CREATE TABLE Subloc AS SELECT * FROM Location WHERE abs(latti-?) < 0.12 and abs(longi-?) < 0.12', [currentLat, currentLong])
                    var rs = tx.executeSql('SELECT * FROM Location WHERE lamid = ?', lam)

                    //var rs = tx.executeSql('SELECT * FROM Subloc')
                    //console.log("Subtable table length ", rs.rows.length)
                    searchLatti = rs.rows.item(0).latti
                    searchLongi = rs.rows.item(0).longi
                }
                )
    searchDone = true
}

/// Function removeZeros() removes zero values from data
function removeZeros() {
    var db = LocalStorage.openDatabaseSync("TrafficviewerDB", "1.0", "Traffic viewer database", 1000000);
    //db.vacuum()
    db.transaction(
                function(tx) {
                    // Create the table, if not existing
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Valuetable (valamid INTEGER, lamlocaltime TEXT, trafficvolume1 INTEGER, trafficvolume2 INTEGER, averagespeed1 INTEGER, averagespeed2 INTEGER)');
                    // Delete double values
                    tx.executeSql('DELETE FROM Valuetable WHERE rowid NOT IN (SELECT max(rowid) FROM Valuetable GROUP BY valamid, lamlocaltime)')
                    // Delete zeros between 7 and 17 localtime, (is the behaviour same in all zones??
                    //var rs = tx.executeSql('SELECT * FROM Valuetable WHERE ((strftime(?,lamlocaltime,?))%?) > ? AND ((strftime(?,lamlocaltime,?))%?) < ? AND trafficvolume1 = ? AND trafficvolume2 = ?', ['%s', 'localtime', 86400, 25199, '%s', 'localtime', 86400,61201, 0, 0])
                    tx.executeSql('DELETE FROM Valuetable WHERE ((strftime(?,lamlocaltime,?))%?) > ? AND ((strftime(?,lamlocaltime,?))%?) < ? AND trafficvolume1 = ? AND trafficvolume2 = ?', ['%s', 'localtime', 86400, 25199, '%s', 'localtime', 86400,61201, 0, 0])

                }
                )
}
