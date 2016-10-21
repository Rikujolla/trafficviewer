    function saveSettings() {
        //console.log("Save Settings")
        var db = LocalStorage.openDatabaseSync("RushDB", "1.0", "Rush hour database", 1000000);

        db.transaction(
            function(tx) {
                // Create the table, if not existing
                tx.executeSql('CREATE TABLE IF NOT EXISTS Settings(name TEXT, subname TEXT, valte TEXT, valre REAL, valint INTEGER)');

                // gpsUpdateRate
                var rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'gpsUpdateRate');
                if (rs.rows.length > 0) {tx.executeSql('UPDATE Settings SET valint=? WHERE name=?', [gpsUpdateRate, 'gpsUpdateRate'])}
                else {tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'gpsUpdateRate', '', '', '', gpsUpdateRate ])}
                // favourSelected
                rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'favourSelected');
                if (rs.rows.length > 0) {tx.executeSql('UPDATE Settings SET valint=? WHERE name=?', [favourSelected, 'favourSelected'])}
                else {tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'favourSelected', '', '', '', favourSelected ])}
                // favourPair
                rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'favourPair');
                if (rs.rows.length > 0) {tx.executeSql('UPDATE Settings SET valint=? WHERE name=?', [favourPair, 'favourPair'])}
                else {tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'favourPair', '', '', '', favourPair ])}
                // favourLatti
                rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'favourLatti');
                if (rs.rows.length > 0) {tx.executeSql('UPDATE Settings SET valint=? WHERE name=?', [favourLatti, 'favourLatti'])}
                else {tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'favourLatti', '', '', favourLatti, '' ])}
                // favourLongi
                rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'favourLongi');
                if (rs.rows.length > 0) {tx.executeSql('UPDATE Settings SET valint=? WHERE name=?', [favourLongi, 'favourLongi'])}
                else {tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'favourLongi', '', '', favourLongi, '' ])}
                // coverLam
                rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'coverLam');
                if (rs.rows.length > 0) {tx.executeSql('UPDATE Settings SET valint=? WHERE name=?', [coverLam, 'coverLam'])}
                else {tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'coverLam', '', '', '', coverLam ])}
                // coverPair
                rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'coverPair');
                if (rs.rows.length > 0) {tx.executeSql('UPDATE Settings SET valint=? WHERE name=?', [coverPair, 'coverPair'])}
                else {tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'coverPair', '', '', '', coverPair ])}
                /*// playMode
                rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'playMode');
                if (rs.rows.length > 0) {tx.executeSql('UPDATE Settings SET valte=? WHERE name=?', [playMode, 'playMode'])}
                else {tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'playMode', '', playMode, '', '' ])}*/

            }
        )

    }

function loadSettings() {
    //console.log("Load Settings")
    var db = LocalStorage.openDatabaseSync("RushDB", "1.0", "Rush hour database", 1000000);

    db.transaction(
        function(tx) {
            // Create the table, if not existing
            tx.executeSql('CREATE TABLE IF NOT EXISTS Settings(name TEXT, subname TEXT, valte TEXT, valre REAL, valint INTEGER)');

            // gpsUpdateRate
            var rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'gpsUpdateRate');
            if (rs.rows.length > 0) {gpsUpdateRate = rs.rows.item(0).valint}
            else {}
            // favourSelected
            rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'favourSelected');
            if (rs.rows.length > 0) {favourSelected = rs.rows.item(0).valint}
            else {}
            // favourPair
            rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'favourPair');
            if (rs.rows.length > 0) {favourPair = rs.rows.item(0).valint}
            else {}
            // favourLatti
            rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'favourLatti');
            if (rs.rows.length > 0) {favourLatti = rs.rows.item(0).valre}
            else {}
            // favourLongi
            rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'favourLongi');
            if (rs.rows.length > 0) {favourLongi = rs.rows.item(0).valre}
            else {}
            // coverLam
            rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'coverLam');
            if (rs.rows.length > 0) {coverLam = rs.rows.item(0).valint}
            else {}
            // coverPair
            rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'coverPair');
            if (rs.rows.length > 0) {coverPair = rs.rows.item(0).valint}
            else {}
            /*// playMode
            rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'playMode');
            if (rs.rows.length > 0) {playMode = rs.rows.item(0).valte}
            else {}*/

        }

    )

}
