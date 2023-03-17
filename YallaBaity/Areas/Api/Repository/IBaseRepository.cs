using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace YallaBaity.Areas.Api.Repository
{
    public interface IBaseRepository<T> where T : class
    {
        T GetById(int id); 
        int NewId(Expression<Func<T, int>> expression); 
        int Count();
        int Count(Expression<Func<T, bool>> expression);
        int Count(string predicate, params object[] args); 
        T Find(Expression<Func<T, bool>> expression);
        IQueryable<T> FromSqlRaw(string sql, params object[] parameters);
        IQueryable<T> SqlCondition(string condition, params object[] parameters);
        IQueryable<T> GetAll(); 
        IQueryable<T> GetAll(string predicate, params object[] args);
        IQueryable<T> GetAll(string order,string predicate, params object[] args);
        IQueryable<T> GetAll(Expression<Func<T, bool>> expression);
        IQueryable<Result> GetAll<Result>(Expression<Func<T, bool>> expression, Expression<Func<T, Result>> selector);
        IQueryable<Result> GetAll<Result>(Expression<Func<T, Result>> selector);
        IQueryable<T> GetAll(string order,Expression<Func<T, bool>> expression);
        IEnumerable<T> AddRange(IEnumerable<T> entries);
        T Add(T entries);
        T Update(T entries);
        void Remove(T entries);
        void RemoveRange(IQueryable<T> entries);
        void Remove(int id);
        bool Any(Expression<Func<T, bool>> expression);
        bool Save();
    }
}
