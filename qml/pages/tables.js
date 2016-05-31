function loadLocation() {
    console.log("lokaatio")
    var db = LocalStorage.openDatabaseSync("TrafficviewerDB", "1.0", "Traffic viewer database", 1000000);

    db.transaction(
                function(tx) {
                    // Create the table, if not existing
                    tx.executeSql('CREATE TABLE IF NOT EXISTS datatable (timestamp TEXT, value TEXT, annotation TEXT)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS parameters (parameter TEXT, description TEXT, visualize INTEGER, plotcolor TEXT, datatable TEXT PRIMARY KEY, pairedtable TEXT)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Location (lamid INTEGER, latti REAL, longi REAL, offlat1 REAL, offlong1 REAL, offlat2 REAL, offlong2 REAL)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Valuetable (valamid INTEGER, lamlocaltime TEXT, trafficvolume1 INTEGER, trafficvolume2 INTEGER, averagespeed1 INTEGER, averagespeed2 INTEGER)');

                    tx.executeSql('DELETE FROM Location')
                    console.log(lamStations.count, "status", lamStations.status)

                    for(var i = 0; i < lamStations.count; i++) {

                        tx.executeSql('INSERT OR REPLACE INTO Location VALUES (?,?,?,?,?,?,?)', [lamStations.get(i).LAM_NUMERO, lamStations.get(i).latitude, lamStations.get(i).longitude, lamStations.get(i).offlat1, lamStations.get(i).offlong1, lamStations.get(i).offlat2, lamStations.get(i).offlong2])
                    }

                    lamPoints.clear();
                    for(i = 0; i < lamStations.count; i++) {
                        lamPoints.append({"iidee": lamStations.get(i).LAM_NUMERO, "latti":lamStations.get(i).latitude + lamStations.get(i).offlat1, "longi":lamStations.get(i).longitude + lamStations.get(i).offlong1, "veloc":i})
                        lamPoints.append({"iidee": lamStations.get(i).LAM_NUMERO, "latti":lamStations.get(i).latitude + lamStations.get(i).offlat2, "longi":lamStations.get(i).longitude + lamStations.get(i).offlong2, "veloc":i})
                        //lamPoints.append({"iidee": lamStations.get(i).LAM_NUMERO, "neim":lamStations.get(i).TSA_NIMI, "latti":lamStations.get(i).latitude + lamStations.get(i).offlat1, "longi":lamStations.get(i).longitude + lamStations.get(i).offlong1, "veloc":i})
                        //lamPoints.append({"iidee": lamStations.get(i).LAM_NUMERO, "neim":lamStations.get(i).TSA_NIMI, "latti":lamStations.get(i).latitude + lamStations.get(i).offlat2, "longi":lamStations.get(i).longitude + lamStations.get(i).offlong2, "veloc":i})
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
                    tx.executeSql('CREATE TABLE IF NOT EXISTS datatable (timestamp TEXT, value TEXT, annotation TEXT)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS parameters (parameter TEXT, description TEXT, visualize INTEGER, plotcolor TEXT, datatable TEXT PRIMARY KEY, pairedtable TEXT)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Location (lamid INTEGER, latti REAL, longi REAL, offlat1 REAL, offlong1 REAL, offlat2 REAL, offlong2 REAL)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Valuetable (valamid INTEGER, lamlocaltime TEXT, trafficvolume1 INTEGER, trafficvolume2 INTEGER, averagespeed1 INTEGER, averagespeed2 INTEGER)');
                    tx.executeSql('DELETE FROM Valuetable')

                    console.log("LAM measurement", lamSpecs.count, "status", lamSpecs.status)

                    for(var i = 0; i < lamSpecs.count; i++) {

                        tx.executeSql('INSERT OR REPLACE INTO Valuetable VALUES (?,?,?,?,?,?)', [lamSpecs.get(i).lamid, lamSpecs.get(i).lamLocaltime, lamSpecs.get(i).trafficvolume1, lamSpecs.get(i).trafficvolume2, lamSpecs.get(i).averagespeed1, lamSpecs.get(i).averagespeed2])
                    }

                    var rs = tx.executeSql('SELECT * FROM Valuetable INNER JOIN Location ON Valuetable.valamid = Location.lamid')
                        //rs = tx.executeSql('SELECT * FROM Locations INNER JOIN Priorities ON Locations.theplace = Priorities.theplace INNER JOIN Cellinfo ON Priorities.theplace = Cellinfo.theplace WHERE Priorities.cell = ? AND Cellinfo.thecelli = ? ORDER BY tolerlong ASC LIMIT 1', ['1',currentCell]);

                    lamPoints.clear();
                    for(i = 0; i < lamStations.count; i++) {
                        rs.rows.item(0)
                        lamPoints.append({"iidee": rs.rows.item(i).lamid, "latti":rs.rows.item(i).latti + rs.rows.item(i).offlat1, "longi":rs.rows.item(i).longi + rs.rows.item(i).offlong1, "veloc":rs.rows.item(i).averagespeed1})
                        lamPoints.append({"iidee": rs.rows.item(i).lamid, "latti":rs.rows.item(i).latti + rs.rows.item(i).offlat2, "longi":rs.rows.item(i).longi + rs.rows.item(i).offlong2, "veloc":rs.rows.item(i).averagespeed2})
                    }
                }
                )
}


