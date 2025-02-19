Core.SQL = {}
 
Core.SQL.Execute = function(query, args, cb)
    MySQL.query(query, args, cb)
end

Core.SQL.AwaitExecute = function(query, args)
    return MySQL.query.await(query, args)
    -- RETURN return data in case query is not SELECT
    -- {"warningStatus":0,"info":"","changedRows":0,"serverStatus":2,"fieldCount":0,"insertId":0,"affectedRows":1}
end