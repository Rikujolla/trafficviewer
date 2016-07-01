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

                    for(i = 0; i < rs.rows.length; i++) {
                        //
                        //lamPoints.append({"iidee": lamStations.get(i).LAM_NUMERO, "pair": 0, "latti":lamStations.get(i).latitude + lamStations.get(i).offlat1, "longi":lamStations.get(i).longitude + lamStations.get(i).offlong1, "veloc":rs.rows.item(i).averagespeed1})
                        //lamPoints.append({"iidee": lamStations.get(i).LAM_NUMERO, "pair": 1, "latti":lamStations.get(i).latitude + lamStations.get(i).offlat2, "longi":lamStations.get(i).longitude + lamStations.get(i).offlong2, "veloc":rs.rows.item(i).averagespeed2})
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
                    //tx.executeSql('DELETE FROM Valuetable')


                    //var rs = tx.executeSql('SELECT *, max(lamlocaltime) FROM Valuetable INNER JOIN Location ON Valuetable.valamid = Location.lamid WHERE abs(Location.latti-?) < 0.2 and abs(Location.longi-?) < 0.2 GROUP BY Valuetable.valamid', [currentLat, currentLong])
                    //var rs = tx.executeSql('SELECT *, max(lamlocaltime) FROM Valuetable INNER JOIN Location ON Valuetable.valamid = Location.lamid GROUP BY Valuetable.valamid')
                    var rs = tx.executeSql('SELECT *, max(lamlocaltime) FROM Valuetable INNER JOIN Subloc ON Valuetable.valamid = Subloc.lamid GROUP BY Valuetable.valamid')
                        //rs = tx.executeSql('SELECT * FROM Locations INNER JOIN Priorities ON Locations.theplace = Priorities.theplace INNER JOIN Cellinfo ON Priorities.theplace = Cellinfo.theplace WHERE Priorities.cell = ? AND Cellinfo.thecelli = ? ORDER BY tolerlong ASC LIMIT 1', ['1',currentCell]);
                    console.log("rspituus ", rs.rows.length)
                    lamPoints.clear();
                    for(var i = 0; i < rs.rows.length; i++) {
                        //
                        //lamPoints.append({"iidee": lamStations.get(i).LAM_NUMERO, "pair": 0, "latti":lamStations.get(i).latitude + lamStations.get(i).offlat1, "longi":lamStations.get(i).longitude + lamStations.get(i).offlong1, "veloc":rs.rows.item(i).averagespeed1})
                        //lamPoints.append({"iidee": lamStations.get(i).LAM_NUMERO, "pair": 1, "latti":lamStations.get(i).latitude + lamStations.get(i).offlat2, "longi":lamStations.get(i).longitude + lamStations.get(i).offlong2, "veloc":rs.rows.item(i).averagespeed2})
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

                    //var lamiiree = 901 //LAMID
                    // Create the table, if not existing
                    //tx.executeSql('CREATE TABLE IF NOT EXISTS datatable (timestamp TEXT, value TEXT, annotation TEXT)');
                    //tx.executeSql('CREATE TABLE IF NOT EXISTS parameters (parameter TEXT, description TEXT, visualize INTEGER, plotcolor TEXT, datatable TEXT PRIMARY KEY, pairedtable TEXT)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Location (lamid INTEGER, latti REAL, longi REAL, offlat1 REAL, offlong1 REAL, offlat2 REAL, offlong2 REAL)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Valuetable (valamid INTEGER, lamlocaltime TEXT, trafficvolume1 INTEGER, trafficvolume2 INTEGER, averagespeed1 INTEGER, averagespeed2 INTEGER)');
                    //tx.executeSql('DELETE FROM Valuetable')

                    //console.log("LAM measurement", lamSpecs.count, lamStations.count, "status", lamSpecs.status)

                    /*for(var i = 0; i < lamSpecs.count; i++) {

                        tx.executeSql('INSERT OR REPLACE INTO Valuetable VALUES (?,?,?,?,?,?)', [lamSpecs.get(i).lamid, lamSpecs.get(i).lamLocaltime, lamSpecs.get(i).trafficvolume1, lamSpecs.get(i).trafficvolume2, lamSpecs.get(i).averagespeed1, lamSpecs.get(i).averagespeed2])
                    }*/

                    var rs = tx.executeSql('SELECT * FROM Valuetable WHERE valamid =?', lammiSelected)
                    var ry = tx.executeSql('SELECT *, datetime(lamlocaltime,?,?) AS lamtime FROM Valuetable WHERE valamid =?', ["+1 day","localtime", lammiSelected])

                    dataList.clear();
                    dataYesterday.clear();
                    for(var i = 0; i < rs.rows.length; i++) {
                        if (speedView){
                            if (lammiPair == 0) {
                                dataList.append({"timestamp":rs.rows.item(i).lamlocaltime, "speed":rs.rows.item(i).averagespeed1})
                                dataYesterday.append({"timestamp":ry.rows.item(i).lamtime, "speed":ry.rows.item(i).averagespeed1})
                            }
                            else {
                                dataList.append({"timestamp":rs.rows.item(i).lamlocaltime, "speed":rs.rows.item(i).averagespeed2})
                                dataYesterday.append({"timestamp":ry.rows.item(i).lamtime, "speed":ry.rows.item(i).averagespeed2})
                            }
                        }
                        else {
                            if (lammiPair == 0) {
                                dataList.append({"timestamp":rs.rows.item(i).lamlocaltime, "speed":rs.rows.item(i).trafficvolume1})
                                dataYesterday.append({"timestamp":ry.rows.item(i).lamtime, "speed":ry.rows.item(i).trafficvolume1})
                            }
                            else {
                                dataList.append({"timestamp":rs.rows.item(i).lamlocaltime, "speed":rs.rows.item(i).trafficvolume2})
                                dataYesterday.append({"timestamp":ry.rows.item(i).lamtime, "speed":ry.rows.item(i).trafficvolume2})
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

    db.transaction(
                function(tx) {
                    // Create the table, if not existing
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Valuetable (valamid INTEGER, lamlocaltime TEXT, trafficvolume1 INTEGER, trafficvolume2 INTEGER, averagespeed1 INTEGER, averagespeed2 INTEGER)');

                    tx.executeSql('DELETE FROM Valuetable WHERE rowid NOT IN (SELECT max(rowid) FROM Valuetable GROUP BY valamid, lamlocaltime)')

                    var rs = tx.executeSql('SELECT * FROM Valuetable')

                    console.log("Valuetable length ", rs.rows.length)

                    /*for(var i = 0; i < lamSpecs.count; i++) {
                        tx.executeSql('INSERT INTO Valuetable VALUES (?,?,?,?,?,?)', [lamSpecs.get(i).lamid, lamSpecs.get(i).lamLocaltime, lamSpecs.get(i).trafficvolume1, lamSpecs.get(i).trafficvolume2, lamSpecs.get(i).averagespeed1, lamSpecs.get(i).averagespeed2])
                    }*/

                }
                )
}

function subsetLocation() {
    console.log("Maintain data")
    var db = LocalStorage.openDatabaseSync("TrafficviewerDB", "1.0", "Traffic viewer database", 1000000);

    db.transaction(
                function(tx) {
                    // Create the table, if not existing
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Location (lamid INTEGER, latti REAL, longi REAL, offlat1 REAL, offlong1 REAL, offlat2 REAL, offlong2 REAL)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Subloc (lamid INTEGER, latti REAL, longi REAL, offlat1 REAL, offlong1 REAL, offlat2 REAL, offlong2 REAL)');
                    tx.executeSql('DROP TABLE Subloc')
                    //tx.executeSql('DELETE FROM Valuetable WHERE rowid NOT IN (SELECT max(rowid) FROM Valuetable GROUP BY valamid, lamlocaltime)')
                    tx.executeSql('CREATE TABLE Subloc AS SELECT * FROM Location WHERE abs(latti-?) < 0.2 and abs(longi-?) < 0.2', [currentLat, currentLong])

                    var rs = tx.executeSql('SELECT * FROM Subloc')

                    console.log("Subtable table length ", rs.rows.length)

                    /*for(var i = 0; i < lamSpecs.count; i++) {
                        tx.executeSql('INSERT INTO Valuetable VALUES (?,?,?,?,?,?)', [lamSpecs.get(i).lamid, lamSpecs.get(i).lamLocaltime, lamSpecs.get(i).trafficvolume1, lamSpecs.get(i).trafficvolume2, lamSpecs.get(i).averagespeed1, lamSpecs.get(i).averagespeed2])
                    }*/

                }
                )
}
