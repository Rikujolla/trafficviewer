    function saveSettings() {
        //console.log("Save Settings")
        var db = LocalStorage.openDatabaseSync("ChessDB", "1.0", "Chess database", 1000000);

        db.transaction(
            function(tx) {
                // Create the table, if not existing
                tx.executeSql('CREATE TABLE IF NOT EXISTS Settings(name TEXT, subname TEXT, valte TEXT, valre REAL, valint INTEGER)');

                // valkomax
                var rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'valkomax');
                if (rs.rows.length > 0) {tx.executeSql('UPDATE Settings SET valint=? WHERE name=?', [valkomax, 'valkomax'])}
                else {tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'valkomax', '', '', '', valkomax ])}
                // playMode
                rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'playMode');
                if (rs.rows.length > 0) {tx.executeSql('UPDATE Settings SET valte=? WHERE name=?', [playMode, 'playMode'])}
                else {tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'playMode', '', playMode, '', '' ])}

            }
        )

    }

function loadSettings() {
    //console.log("Load Settings")
    var db = LocalStorage.openDatabaseSync("ChessDB", "1.0", "Chess database", 1000000);

    db.transaction(
        function(tx) {
            // Create the table, if not existing
            tx.executeSql('CREATE TABLE IF NOT EXISTS Settings(name TEXT, subname TEXT, valte TEXT, valre REAL, valint INTEGER)');

            // valkomax
            var rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'valkomax');
            if (rs.rows.length > 0) {valkomax = rs.rows.item(0).valint}
            else {}
            // playMode
            rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'playMode');
            if (rs.rows.length > 0) {playMode = rs.rows.item(0).valte}
            else {}

        }

    )

}
