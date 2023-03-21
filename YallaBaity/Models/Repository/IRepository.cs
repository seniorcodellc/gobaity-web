using System.Collections.Generic;
using System.Linq.Expressions;
using System.Linq;
using System;

namespace YallaBaity.Models.Repository
{
    public interface IRepository<T> where T : class
    {
        IEnumerable<T> GetAll(
            Expression<Func<T, bool>> filter = null,
            Func<IQueryable<T>, IOrderedQueryable<T>> orderby = null,
            string IncludeProperties = null
            );
        IQueryable<T> GetAllAsIQueryable(
            Expression<Func<T, bool>> filter = null,
            Func<IQueryable<T>, IOrderedQueryable<T>> orderby = null,
            string IncludeProperties = null);

        T GetFirstOrDefault(
                 Expression<Func<T, bool>> filter = null,
                 string IncludeProperties = null
            );
        T GetElement(int id);

        void Add(T entity);
        void Update(T entity);
        void Delete(int id);
        void Delete(T entity);

        void DeleteRange(IEnumerable<T> entity);
        void AddRange(IEnumerable<T> entity);

    }
}
