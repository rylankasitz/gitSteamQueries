using System;
using System.Collections.Generic;
using System.Text;

namespace GitSteamedDatabase.JsonObjects
{
    public class UserItem
    {
        public string user_id { get; set; }
        public int items_count { get; set; }
        public string steam_id { get; set; }
        public string user_url { get; set; }
        public List<Item> items { get; set; }
    }
    public class Item
    {
        public int item_id { get; set; }
        public string item_name { get; set; }
        public int playtime_forever { get; set; }
        public int playtime_2weeks { get; set; }
    }
}
