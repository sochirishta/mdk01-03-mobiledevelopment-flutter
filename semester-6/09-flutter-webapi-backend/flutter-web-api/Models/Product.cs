using System;
using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace flutter_web_api.Models;

public partial class Product
{
    public int IdProduct { get; set; }

    public string NameProduct { get; set; } = null!;

    public decimal Price { get; set; }

    public int Quantity { get; set; }

    public string Imageurl { get; set; } = null!;
    
    public virtual ICollection<Cartitem> Cartitems { get; set; } = new List<Cartitem>();
}
