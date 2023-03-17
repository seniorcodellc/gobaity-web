using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace YallaBaity.Areas.Api.ViewModel
{
    public class VmDataTable
    { 
        public int draw { get; set; }
        public int start { get; set; }
        public int length { get; set; }
        public List<Column> columns { get; set; }
        public Search search { get; set; }
         public List<YallaBaity.Areas.Api.ViewModel.Order> order { get; set; }
    }

    public class Column
    {
        public string data { get; set; }
        public string name { get; set; }
        public string dataType { get; set; }
        public bool searchable { get; set; }
        public bool orderable { get; set; }
        public Search search { get; set; }
    }

    public class Search
    {
        public string value { get; set; }
        public string regex { get; set; }
    }

    public class Order
    {
        public int column { get; set; }
        public string dir { get; set; }
    }
}
