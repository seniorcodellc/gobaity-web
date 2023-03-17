using Microsoft.EntityFrameworkCore;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Linq.Dynamic.Core;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;
using YallaBaity.Models;

namespace YallaBaity.Areas.Api.Repository
{
    public class BaseRepository<T> : IBaseRepository<T> where T : class
    {
        protected YallaBaityDBContext _context;
        public BaseRepository(YallaBaityDBContext context)
        {
            _context = context;
        }

        public T Add(T entries)
        {
            _context.Set<T>().Add(entries);
            return entries;
        }

        public IEnumerable<T> AddRange(IEnumerable<T> entries)
        {
            _context.Set<T>().AddRange(entries);
            return entries;
        }

        public bool Any(Expression<Func<T, bool>> expression)
        {
            return _context.Set<T>().Any(expression);
        }

        public int Count()
        {
            return _context.Set<T>().Count();
        }

        public int Count(Expression<Func<T, bool>> expression)
        {
            return _context.Set<T>().Where(expression).Count();
        }

        public int Count(string predicate,params object[] args)
        {
            return _context.Set<T>().Where(predicate, args).Count();
        }

        public T Find(Expression<Func<T, bool>> expression)
        {
            return _context.Set<T>().SingleOrDefault(expression);
        }

        public IQueryable<T> SqlCondition(string condition, params object[] parameters)
        {
            var entityType= _context.Set<T>().EntityType; 
            return _context.Set<T>().FromSqlRaw($"SELECT * FROM {(string.IsNullOrEmpty(entityType.GetViewSchema())?entityType.GetSchema(): entityType.GetViewSchema())}.{entityType.FullName()} where "+ condition, parameters);
        }

        public IQueryable<T> FromSqlRaw(string sql, params object[] parameters)
        {
            return _context.Set<T>().FromSqlRaw(sql, parameters);
        }

        public IQueryable<T> GetAll()
        {
            return _context.Set<T>();
        }
        

        public IQueryable<T> GetAll(Expression<Func<T, bool>> expression)
        {
            return _context.Set<T>().Where(expression);
        }
        public IQueryable<T> GetAll(string order,Expression<Func<T, bool>> expression)
        {
            return _context.Set<T>().Where(expression).OrderBy(order);
        }
        public IQueryable<T> GetAll(string order, string predicate, params object[] args)
        {
            return _context.Set<T>().Where(predicate, args).OrderBy(order); 
        }
        public IQueryable<T> GetAll(string predicate, params object[] args)
        {
            return _context.Set<T>().Where(predicate, args);
        }

        public IQueryable<Result> GetAll<Result>(Expression<Func<T, bool>> expression, Expression<Func<T, Result>> selector)
        {
            return _context.Set<T>().Where(expression).Select(selector);
        }

        public IQueryable<Result> GetAll<Result>( Expression<Func<T, Result>> selector)
        {
            return _context.Set<T>().Select(selector);
        }

        public T GetById(int id)
        {
            return _context.Set<T>().Find(id);
        }

        public int NewId(Expression<Func<T, int>> expression)
        { 
            return _context.Set<T>().Select(expression).ToList().DefaultIfEmpty(0).Max() + 1;
        }

        public void Remove(T entries)
        {
            _context.Remove(entries);
        }

        public void Remove(int id)
        {
            _context.Remove(_context.Set<T>().Find(id));
        }

        public void RemoveRange(IQueryable<T> entries)
        {
            _context.RemoveRange(entries);
        }

        public bool Save()
        {
            return _context.SaveChanges() > 0 ? true : false;
        }

        public T Update(T entries)
        { 
            _context.Update(entries);
            return entries;
        } 
    }
}
