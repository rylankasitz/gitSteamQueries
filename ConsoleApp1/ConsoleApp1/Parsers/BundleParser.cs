using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using GitSteamedDatabase.JsonObjects;

namespace GitSteamedDatabase.Parsers
{
    public class BundleParser : Parser
    {
        public BundleParser(DataManager dataManager) : base(dataManager)
        {
        }

        public override void Parse()
        {
            int bundleCount = 0;
            foreach(Bundle bundle in DataManager.Bundles)
            {
                float finalPrice = float.Parse(bundle.bundle_final_price.Replace("$", ""));
                float disountPrice = (1 - (float.Parse(bundle.bundle_discount.Replace("%", "")) / 100)) * finalPrice;
                _AddBundle(bundle.bundle_id, bundle.bundle_name, bundle.bundle_url, finalPrice, disountPrice);
                foreach(BundleItem item in bundle.items)
                {
                    int itemID = _GetItemID(item.item_name); 
                    if (itemID != -1)
                        _AddBundleContent(bundle.bundle_id, itemID);
                }
                DataManager.DisplayProgress("Bundle Progress: ", bundleCount, DataManager.Bundles.Count, 1);
                bundleCount++;
            }
            DataManager.DisplayProgress("Bundle Progress: ", 1, 1, 1);
            Console.WriteLine("\nAdded " + bundleCount + " Bundles");
            DataManager.AddTable("Bundles", DataManager.BundleDataTable);
            DataManager.AddTable("BundleContents", DataManager.BundleContentsDataTable);
        }

        #region Private Helper Methods

        private void _AddBundle(int bundleID, string name, string url, double finalPrice, double discountedPrice)
        {
            DataRow row = DataManager.BundleDataTable.NewRow();
            row["BundleID"] = bundleID;
            row["Name"] = name;
            row["URL"] = url;
            row["FinalPrice"] = Math.Round(finalPrice, 2);
            row["DiscountPrice"] = Math.Round(discountedPrice, 2);
            DataManager.BundleDataTable.Rows.Add(row);
        }

        private void _AddBundleContent(int bundleID, int itemID)
        {
            DataRow row = DataManager.BundleContentsDataTable.NewRow();
            row["BundleID"] = bundleID;
            row["ItemID"] = itemID; 
            DataManager.BundleContentsDataTable.Rows.Add(row);
        }

        private int _GetItemID(string itemName)
        {
            foreach(UserItem userItem in DataManager.UserItems)
            {
                foreach(Item item in userItem.items)
                {
                    if (item.item_name == itemName) return item.item_id;
                }
            }
            return -1;
        }

        #endregion
    }
}
