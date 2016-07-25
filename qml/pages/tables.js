function loadLocation() {
    console.log("lokaatio")
    var db = LocalStorage.openDatabaseSync("TrafficviewerDB", "1.0", "Traffic viewer database", 1000000);

    db.transaction(
                function(tx) {
                    // Create the table, if not existing
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Location (lamid INTEGER, latti REAL, longi REAL, offlat1 REAL, offlong1 REAL, offlat2 REAL, offlong2 REAL)');

                    tx.executeSql('DELETE FROM Location')
                    console.log(lamStations.count, "status", lamStations.status)

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

function addData() {
    console.log("Add data")
    var db = LocalStorage.openDatabaseSync("TrafficviewerDB", "1.0", "Traffic viewer database", 1000000);

    db.transaction(
                function(tx) {
                    // Create the table, if not existing
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Valuetable (valamid INTEGER, lamlocaltime TEXT, trafficvolume1 INTEGER, trafficvolume2 INTEGER, averagespeed1 INTEGER, averagespeed2 INTEGER)');

                    console.log("LAM measurement", lamSpecs.count, lamStations.count, "status", lamSpecs.status)

                    for(var i = 0; i < lamSpecs.count; i++) {
                        tx.executeSql('INSERT INTO Valuetable VALUES (?,?,?,?,?,?)', [lamSpecs.get(i).lamid, lamSpecs.get(i).lamLocaltime, lamSpecs.get(i).trafficvolume1, lamSpecs.get(i).trafficvolume2, lamSpecs.get(i).averagespeed1, lamSpecs.get(i).averagespeed2])
                    }

                }
                )
    subsetLocation()
}

function readData() {
    console.log("Read data to map")
    var db = LocalStorage.openDatabaseSync("TrafficviewerDB", "1.0", "Traffic viewer database", 1000000);

    db.transaction(
                function(tx) {
                    // Create the table, if not existing
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Location (lamid INTEGER, latti REAL, longi REAL, offlat1 REAL, offlong1 REAL, offlat2 REAL, offlong2 REAL)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Valuetable (valamid INTEGER, lamlocaltime TEXT, trafficvolume1 INTEGER, trafficvolume2 INTEGER, averagespeed1 INTEGER, averagespeed2 INTEGER)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Subloc (lamid INTEGER, latti REAL, longi REAL, offlat1 REAL, offlong1 REAL, offlat2 REAL, offlong2 REAL)');

                    //var rs = tx.executeSql('SELECT *, max(lamlocaltime) FROM Valuetable INNER JOIN Location ON Valuetable.valamid = Location.lamid WHERE abs(Location.latti-?) < 0.2 and abs(Location.longi-?) < 0.2 GROUP BY Valuetable.valamid', [currentLat, currentLong])
                    //var rs = tx.executeSql('SELECT *, max(lamlocaltime) FROM Valuetable INNER JOIN Location ON Valuetable.valamid = Location.lamid GROUP BY Valuetable.valamid')
                    var rs = tx.executeSql('SELECT *, max(lamlocaltime) FROM Valuetable INNER JOIN Subloc ON Valuetable.valamid = Subloc.lamid GROUP BY Valuetable.valamid')
                        //rs = tx.executeSql('SELECT * FROM Locations INNER JOIN Priorities ON Locations.theplace = Priorities.theplace INNER JOIN Cellinfo ON Priorities.theplace = Cellinfo.theplace WHERE Priorities.cell = ? AND Cellinfo.thecelli = ? ORDER BY tolerlong ASC LIMIT 1', ['1',currentCell]);
                    console.log("rspituus ", rs.rows.length)
                    lamPoints.clear();
                    for(var i = 0; i < rs.rows.length; i++) {
                        lamPoints.append({"iidee": rs.rows.item(i).lamid, "pair": 0, "latti":rs.rows.item(i).latti + rs.rows.item(i).offlat1, "longi":rs.rows.item(i).longi + rs.rows.item(i).offlong1, "veloc":rs.rows.item(i).averagespeed1})
                        lamPoints.append({"iidee": rs.rows.item(i).lamid, "pair": 1, "latti":rs.rows.item(i).latti + rs.rows.item(i).offlat2, "longi":rs.rows.item(i).longi + rs.rows.item(i).offlong2, "veloc":rs.rows.item(i).averagespeed2})
                    }
                }
                )
}

function drawSpeed() {
    console.log("Draw speed")
    var db = LocalStorage.openDatabaseSync("TrafficviewerDB", "1.0", "Traffic viewer database", 1000000);

    db.transaction(
                function(tx) {

                    // Create the table, if not existing
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Location (lamid INTEGER, latti REAL, longi REAL, offlat1 REAL, offlong1 REAL, offlat2 REAL, offlong2 REAL)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Valuetable (valamid INTEGER, lamlocaltime TEXT, trafficvolume1 INTEGER, trafficvolume2 INTEGER, averagespeed1 INTEGER, averagespeed2 INTEGER)');
                    //tx.executeSql('DELETE FROM Valuetable')

                    var time = new Date().getTime()
                    var offset = new Date().getTimezoneOffset()
                    var zeero = new Date(time + offset*60*1000 - time%(24*60*60*1000)) //RLAH

                    //var rs = tx.executeSql('SELECT * FROM Valuetable WHERE valamid =?', lammiSelected)
                    var rs = tx.executeSql('SELECT * FROM Valuetable WHERE valamid =? AND lamlocaltime > date(?,?,?)', [lammiSelected, 'now', 'localtime','-1 day'])
                    //var ry = tx.executeSql('SELECT *, datetime(lamlocaltime,?,?) AS lamtime FROM Valuetable WHERE valamid =?', ["+1 day","localtime", lammiSelected])
                    var ry = tx.executeSql('SELECT *, datetime(lamlocaltime,?,?) AS lamtime FROM Valuetable WHERE valamid =? AND lamlocaltime > date(?,?,?)', ["+1 day","localtime", lammiSelected, 'now', 'localtime','-2 day'])
                    var rw = tx.executeSql('SELECT strftime(?,?,?)AS wdaynow', ['%w', 'now', 'localtime'])
                    console.log('Tänään', rw.rows.item(0).wdaynow)
                    // toimii var rt = tx.executeSql('SELECT *, datetime(htime+?,?,?) AS hhtime FROM History WHERE valamid=? AND wday=?', [(time - time%(24*60*60*1000))/1000, 'unixepoch', 'localtime', lammiSelected, rw.rows.item(0).wdaynow])
                    var rt = tx.executeSql('SELECT *, datetime(htime+?,?,?) AS hhtime FROM Historystable WHERE valamid=? AND wday=?', [(time - time%(24*60*60*1000))/1000, 'unixepoch', 'localtime', lammiSelected, rw.rows.item(0).wdaynow])
                    //console.log("time2", rt.rows.item(0).htime)

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
                                //dataList.append({"timestamp":rs.rows.item(i).lamlocaltime, "speed":rs.rows.item(i).averagespeed1})
                                dataYesterday.append({"timestamp":ry.rows.item(i).lamtime, "speed":ry.rows.item(i).averagespeed1})
                            }
                            else {
                                //dataList.append({"timestamp":rs.rows.item(i).lamlocaltime, "speed":rs.rows.item(i).averagespeed2})
                                dataYesterday.append({"timestamp":ry.rows.item(i).lamtime, "speed":ry.rows.item(i).averagespeed2})
                            }
                        }
                        else {
                            if (lammiPair == 0) {
                                //dataList.append({"timestamp":rs.rows.item(i).lamlocaltime, "speed":rs.rows.item(i).trafficvolume1})
                                dataYesterday.append({"timestamp":ry.rows.item(i).lamtime, "speed":ry.rows.item(i).trafficvolume1})
                            }
                            else {
                                //dataList.append({"timestamp":rs.rows.item(i).lamlocaltime, "speed":rs.rows.item(i).trafficvolume2})
                                dataYesterday.append({"timestamp":ry.rows.item(i).lamtime, "speed":ry.rows.item(i).trafficvolume2})
                            }
                        }
                    }

                    dataHistory.clear();
                    for(i = 0; i < rt.rows.length; i++) {
                        //var time2 = new Date(rt.rows.item(i).htime*1000 + time + offset*60*1000 - time%(24*60*60*1000))
                        //var time4 = JSON.stringify(time2)

                        if (speedView){
                            if (lammiPair == 0) {
                                dataHistory.append({"timestamp":rt.rows.item(i).hhtime, "speed":rt.rows.item(i).msp2/rt.rows.item(i).nhist})
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
                    console.log("Modified time",ry.rows.item(0).lamtime)
                }
                )
}

function maintainDb() {
    console.log("Maintain data")
    var db = LocalStorage.openDatabaseSync("TrafficviewerDB", "1.0", "Traffic viewer database", 1000000);
    //db.vacuum()
    db.transaction(
                function(tx) {
                    // Create the table, if not existing
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Valuetable (valamid INTEGER, lamlocaltime TEXT, trafficvolume1 INTEGER, trafficvolume2 INTEGER, averagespeed1 INTEGER, averagespeed2 INTEGER)');

                    tx.executeSql('DELETE FROM Valuetable WHERE rowid NOT IN (SELECT max(rowid) FROM Valuetable GROUP BY valamid, lamlocaltime)')

                    var rs = tx.executeSql('SELECT * FROM Valuetable')

                    console.log("Valuetable length ", rs.rows.length)
                    //tx.executeSql('VACUUM')

                }
                )
}

function subsetLocation() {
    console.log("Select closest LAMs")
    var db = LocalStorage.openDatabaseSync("TrafficviewerDB", "1.0", "Traffic viewer database", 1000000);

    db.transaction(
                function(tx) {
                    // Create the table, if not existing
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Location (lamid INTEGER, latti REAL, longi REAL, offlat1 REAL, offlong1 REAL, offlat2 REAL, offlong2 REAL)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Subloc (lamid INTEGER, latti REAL, longi REAL, offlat1 REAL, offlong1 REAL, offlat2 REAL, offlong2 REAL)');
                    tx.executeSql('DROP TABLE Subloc')
                    tx.executeSql('CREATE TABLE Subloc AS SELECT * FROM Location WHERE abs(latti-?) < 0.2 and abs(longi-?) < 0.2', [currentLat, currentLong])

                    var rs = tx.executeSql('SELECT * FROM Subloc')
                    console.log("Subtable table length ", rs.rows.length)
                }
                )
}

function makeHistory() {
    console.log("Make history")
    var db = LocalStorage.openDatabaseSync("TrafficviewerDB", "1.0", "Traffic viewer database", 1000000);

    db.transaction(
                function(tx) {
                    // Create the table, if not existing
                    //var time = new Date().getTime()
                    //var offset = new Date().getTimezoneOffset()
                    //var zeero = new Date(time + offset*60*1000 - time%(24*60*60*1000)) //RLAH
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Valuetable (valamid INTEGER, lamlocaltime TEXT, trafficvolume1 INTEGER, trafficvolume2 INTEGER, averagespeed1 INTEGER, averagespeed2 INTEGER)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Location (lamid INTEGER, latti REAL, longi REAL, offlat1 REAL, offlong1 REAL, offlat2 REAL, offlong2 REAL)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS History (lamid INTEGER, latti REAL, longi REAL, offlat1 REAL, offlong1 REAL, offlat2 REAL, offlong2 REAL)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Historystable (valamid INTEGER, wday TEXT, htime INTEGER, mtr1 REAL, mtr2 REAL, msp1 REAL, msp2 REAL, nhist INTEGER)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Historytemp (valamid INTEGER, wday TEXT, htime INTEGER, mtr1 REAL, mtr2 REAL, msp1 REAL, msp2 REAL, nhist INTEGER)');
                    tx.executeSql('DROP TABLE History')
                    tx.executeSql('DROP TABLE Historytemp')
                    tx.executeSql('CREATE TABLE History AS SELECT valamid, strftime(?,lamlocaltime) AS wday, ((strftime(?,lamlocaltime)%?)-(strftime(?,lamlocaltime)%?)%?) AS htime, total(trafficvolume1) AS mtr1, total(trafficvolume2) AS mtr2, total(averagespeed1) AS msp1, total(averagespeed2) AS msp2, count(rowid) AS nhist FROM Valuetable WHERE (strftime(?,?) - strftime(?,lamlocaltime))> ? GROUP BY valamid, htime, wday', ['%w', '%s', 86400, '%s', 86400, 600, '%s', 'now', '%s', 702000])
                    tx.executeSql('INSERT INTO Historystable SELECT * FROM History')
                    tx.executeSql('CREATE TABLE Historytemp AS SELECT valamid, wday, htime, total(mtr1) AS mtr1, total(mtr2) AS mtr2, total(msp1) AS msp1, total(msp2) AS msp2, sum(nhist) AS nhist FROM Historystable GROUP BY valamid, htime, wday')
                    tx.executeSql('DELETE FROM Historystable')
                    tx.executeSql('INSERT INTO Historystable SELECT * FROM Historytemp')
                    tx.executeSql('DELETE FROM Valuetable WHERE (strftime(?,?) - strftime(?,lamlocaltime))> ?', ['%s', 'now', '%s', 702000])

                }
                )
}
