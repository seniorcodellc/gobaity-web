using System.Collections.Generic;
using System.Data.Common;
using System.Data;
using System.Diagnostics;
using Microsoft.EntityFrameworkCore;
using YallaBaity.Models;
using System;
using System.Linq;

namespace YallaBaity.Areas.Api.Services
{
    public class ProcedureServices: IProcedureServices
    {
        YallaBaityDBContext _context;
        public ProcedureServices(YallaBaityDBContext context)
        {
            _context = context;
        }
        public List<T> RawSqlQuery<T>(string query, Func<DbDataReader, T> map)
        {
            using (var command = _context.Database.GetDbConnection().CreateCommand())
            {
                command.CommandText = query;
                command.CommandType = CommandType.Text;

                _context.Database.OpenConnection();

                using (var result = command.ExecuteReader())
                {
                    var entities = new List<T>();

                    while (result.Read())
                    {
                        entities.Add(map(result));
                    }

                    return entities;
                }
            }
        } 
    }
}