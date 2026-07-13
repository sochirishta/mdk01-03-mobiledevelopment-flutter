using System;
using System.Collections.Generic;

namespace flutter_web_api.Models;

public partial class Cartitem
{
    public int IdCartitem { get; set; }

    public int? ProductId { get; set; }

    public int? UserId { get; set; }

    public int Addedquantity { get; set; }

    public virtual Product? Product { get; set; }

    public virtual User? User { get; set; }
}
