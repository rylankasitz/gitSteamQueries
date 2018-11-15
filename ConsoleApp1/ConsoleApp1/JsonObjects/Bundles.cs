using System;
using System.Collections.Generic;
using System.Text;

namespace GitSteamedDatabase.JsonObjects
{
    public class BundleItem
    {
        public string item_id { get; set; }
        public string genre { get; set; }
        public string discounted_price { get; set; }
        public string item_url { get; set; }
        public string item_name { get; set; }
    }

    public class Bundle
    {
        public int bundle_id { get; set; }
        public string bundle_name { get; set; }
        public string bundle_final_price { get; set; }
        public string bundle_url { get; set; }
        public string bundle_price { get; set; }
        public string bundle_discount { get; set; }
        public List<BundleItem> items { get; set; }

    }
    
}
