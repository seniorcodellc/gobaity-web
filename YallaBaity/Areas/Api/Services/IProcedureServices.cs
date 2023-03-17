using System.Collections.Generic;
using System.Data.Common;
using System;

namespace YallaBaity.Areas.Api.Services
{
    public interface IProcedureServices
    {
        public List<T> RawSqlQuery<T>(string query, Func<DbDataReader, T> map);
    }
}
