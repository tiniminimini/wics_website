PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
COMMIT;
    /*// The first thing we want to do is create the local
    // database (if it doesn't exist) or open the connection
    // if it does exist. Let's define some options for our
    // test database.*/
    var databaseOptions = {
        fileName: "wics",
        version: "1.0",
        displayName: "Database storage capacity is maxed out.",
        maxSize: 1024
    };

    /*// Now that we have our database properties defined, let's
    // create or open our database, getting a reference to the
    // generated connection.
    //
    // NOTE: This might throw errors.*/
    var database = openDatabase(
        databaseOptions.fileName,
        databaseOptions.version,
        databaseOptions.displayName,
        databaseOptions.maxSize
    );

    /*// Now that we have the databse connection, let's create our
    // first table if it doesn't exist. According to Safari, all
    // queries must be part of a transaction. To execute a
    // transaction, we have to call the transaction() function
    // and pass it a callback that is, itself, passed a reference
    // to the transaction object.*/
    database.transaction(
        function( transaction ){

            /* Create table if it doesn't exist.
            (Not sure what this is doing.)
            */
            transaction.executeSql(
                "CREATE TABLE IF NOT EXISTS form (" +
                    "id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT," +
                    "name TEXT NOT NULL" +
                ");"
            );

        }
    );


    /*// Now that we have our database table created, let's
    // create some "service" functions that we can use.

    // NOTE: Since SQLite database interactions are performed
    // asynchronously by default (it seems), we have to provide
    // callbacks to execute when the results are available.

    Miya - really confused about this part, it's not insertion?
	*/
    var saveGirl = function( name, callback ){
        // Insert a new girl.
        database.transaction(
            function( transaction ){

                // Insert a new girl with the given values.
                transaction.executeSql(
                    (
                        "INSERT INTO girls (" +
                            "name " +
                        " ) VALUES ( " +
                            "? " +
                        ");"
                    ),
                    [
                        name
                    ],
                    function( transaction, results ){
                        // Execute the success callback,
                        // passing back the newly created ID.
                        callback( results.insertId );
                    }
                );

            }
        );
    };

    /* Get functions
    */
    var getGirls = function( callback ){
        // Get all the girls.
        database.transaction(
            function( transaction ){

                // Get all the girls in the table.
                transaction.executeSql(
                    (
                        "SELECT " +
                            "* " +
                        "FROM " +
                            "girls " +
                        "ORDER BY " +
                            "name ASC"
                    ),
                    [],
                    function( transaction, results ){
                        // Return the girls results set.
                        callback( results );
                    }
                );

            }
        );
    };


 	/* Delete functions
 	*/
    var deleteGirls = function( callback ){
        // Get all the girls.
        database.transaction(
            function( transaction ){

                // Delete all the girls.
                transaction.executeSql(
                    (
                        "DELETE FROM " +
                            "girls "
                    ),
                    [],
                    function(){
                        // Execute the success callback.
                        callback();
                    }
                );

            }
        );
    };

    /*// When the DOM is ready, init the scripts. */
    $(function(){
        // Get the form.
        var form = $( "form" );

        // Get the girl list.
        var list = $( "#girls" );

        // Get the Clear Girls link.
        var clearGirls = $( "#clearGirls" );


        // I refresh the girls list.
        var refreshGirls = function( results ){
            // Clear out the list of girls.
            list.empty();

            // Check to see if we have any results.
            if (!results){
                return;
            }

            // Loop over the current list of girls and add them
            // to the visual list.
            $.each(
                results.rows,
                function( rowIndex ){
                    var row = results.rows.item( rowIndex );

                    // Append the list item.
                    list.append( "<li>" + row.name + "</li>" );
                }
            );
        };


        // Bind the form to save the girl.
        form.submit(
            function( event ){
                // Prevent the default submit.
                event.preventDefault();

                // Save the girl.
                saveGirl(
                    form.find( "input.name" ).val(),
                    function(){
                        // Reset the form and focus the input.
                        form.find( "input.name" )
                            .val( "" )
                            .focus()
                        ;

                        // Refresh the girl list.
                        getGirls( refreshGirls );
                    }
                );
            }
        );


        // Bind to the clear girls link.
        clearGirls.click(
            function( event ){
                // Prevent default click.
                event.preventDefault();

                // Clear the girls
                deleteGirls( refreshGirls );
            }
        );


        // Refresh the girls list - this will pull the persisted
        // girl data out of the SQLite database and put it into
        // the UL element.
        getGirls( refreshGirls );
    });

</script>