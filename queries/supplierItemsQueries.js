const suppliersQ = require("../queries/suppliersQueries.js");
const itemQ = require("../queries/itemsQueries.js");

var queries = (function () {
  function getSupplierItemsByIdImpl(connection, id, callback) {
    suppliersQ.getSupplierById(connection, id, (data) => {
      if (data == null) {
        callback(1);
      } else {
        connection.query(
          "SELECT pd.proizvod_id, p.naziv as 'naziv_proizvoda', p.proizvodjac," +
            " p.kategorija, d.naziv as 'naziv_dobavljaca', pd.dobavljac_id" +
            " FROM proizvodi_dobavljaca pd" +
            " INNER JOIN proizvodi p ON p.id = pd.proizvod_id " +
            " INNER JOIN dobavljaci d ON d.id = pd.dobavljac_id " +
            " WHERE pd.dobavljac_id=?",
          [id],
          callback
        );
      }
    });
  }

  function addSupplierItemsByIdImpl(connection, supplierId, itemId, callback) {
    suppliersQ.getSupplierById(connection, supplierId, (data) => {
      if (data == null) {
        callback(1);
      } else {
        itemQ.getItemById(connection, itemId, (data) => {
          if (data == null) {
            callback(1);
          } else {
            connection.query(
              "INSERT INTO proizvodi_dobavljaca(proizvod_id, dobavljac_id)" +
                " VALUES(?,?)",
              [itemId, supplierId],
              callback
            );
          }
        });
      }
    });
  }

  function deleteSupplierItemsByIdImpl(
    connection,
    supplierId,
    itemId,
    callback
  ) {
    suppliersQ.getSupplierById(connection, supplierId, (data) => {
      if (data == null) {
        callback(1);
      } else {
        itemQ.getItemById(connection, itemId, (data) => {
          if (data == null) {
            callback(1);
          } else {
            connection.query(
              "SELECT * FROM proizvodi_dobavljaca WHERE dobavljac_id=? AND proizvod_id=?",
              [supplierId, itemId],
              (error, results) => {
                if (results[0] == null) {
                  callback(2);
                } else {
                  connection.query(
                    "DELETE FROM proizvodi_dobavljaca " +
                      "WHERE dobavljac_id=? and proizvod_id=?",
                    [supplierId, itemId],
                    callback
                  );
                }
              }
            );
          }
        });
      }
    });
  }

  return {
    getSupplierItemsById: getSupplierItemsByIdImpl,
    addSupplierItemsById: addSupplierItemsByIdImpl,
    deleteSupplierItemsById: deleteSupplierItemsByIdImpl,
  };
})();

module.exports = queries;