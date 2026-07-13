using System;
using System.Collections.Generic;

namespace flutter_web_api.Models;

public partial class User
{
    public int IdUser { get; set; }

    public string UserName { get; set; } = null!;

    public string UserPwd { get; set; } = null!;

    public virtual ICollection<Cartitem> Cartitems { get; set; } = new List<Cartitem>();
}