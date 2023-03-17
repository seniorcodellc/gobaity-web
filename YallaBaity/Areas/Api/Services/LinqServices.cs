using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using YallaBaity.Models;

namespace YallaBaity.Areas.Api.Services
{
    public class LinqServices : ILinqServices
    {
        YallaBaityDBContext _context;
        public LinqServices(YallaBaityDBContext context)
        {
            _context = context;
        }

        public string GenerateQuery<T>(string includes = "", string additions = "")
        {
            Type type = typeof(T);
            List<string> array = new List<string>();
            List<string> lstInclutes = includes.Split(",").ToList();
            IEnumerable<PropertyInfo> props;

            if (string.IsNullOrEmpty(includes))
            {
                props = type.GetProperties();
            }
            else
            {
                props = type.GetProperties().Where(x => lstInclutes.Any(y => y == x.Name));
            }

            foreach (var item in props)
            {
                if (item.PropertyType == typeof(long) || item.PropertyType == typeof(int) || item.PropertyType == typeof(double) || item.PropertyType == typeof(decimal) || item.PropertyType == typeof(float))
                {
                    array.Add(item.Name + ".ToString()=@0");
                }
                else if (item.PropertyType == typeof(string))
                {
                    array.Add(item.Name + ".ToLower().StartsWith(@0)");
                }
            }

            return string.Join(" or ", array)+ additions;
        }

        

        public T GetDefaultIsEmpty<T>(int id) where T : class
        {
            return (id == 0 ? (T)Activator.CreateInstance(typeof(T)) : _context.Set<T>().Find(id));
        }
    }
}
