using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Text;
using System.Transactions;
using GitSteamedDatabase.JsonObjects;
using System.Data;

namespace GitSteamedDatabase.Parsers
{
    public class UserItemsParser : Parser
    {
        public UserItemsParser(DataManager dataManager) : base(dataManager)
        {
        }

        public override void Parse()
        {
            foreach (UserItem userItem in DataManager.UserItems)
            {
                _AddUser(userItem.user_id, userItem.user_url, userItem.item_count);
                foreach (Item item in userItem.items)
                {
                    BundleItem bundleItem = _GetBundleItem(item.item_name);
                    //if (bundleItem != null)
                        //_AddItem(item.item_id, item.item_name, bundleItem.item_url, bundleItem.genre, float.Parse(bundleItem.discounted_price));
                    //else
                       // _AddItem(item.item_id, item.item_name, null, null, 0);
                }
            }
        }

        private void _AddUser(string userName, string userURL, int itemCount)
        {
            using (var transaction = new TransactionScope())
            {
                using (var connection = new SqlConnection(DataManager.Connection))
                {
                    using (var command = new SqlCommand("gitSteamed.AddUser", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.AddWithValue("username", userName);
                        command.Parameters.AddWithValue("url", userURL);
                        command.Parameters.AddWithValue("itemcount", itemCount);

                        connection.Open();
                        command.ExecuteNonQuery();
                        transaction.Complete();
                    }
                }
            }
        }

        private void _AddItem(int itemID, string itemName, string itemUrl, string genre, float price)
        {
            using (var transaction = new TransactionScope())
            {
                using (var connection = new SqlConnection(DataManager.Connection))
                {
                    using (var command = new SqlCommand("gitSteamed.AddItem", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.AddWithValue("price", itemName);
                        command.Parameters.AddWithValue("url", itemUrl);
                        command.Parameters.AddWithValue("itemname", itemName);
                        command.Parameters.AddWithValue("genre", genre);
                        command.Parameters.AddWithValue("itemid", itemID);

                        connection.Open();
                        command.ExecuteNonQuery();
                        transaction.Complete();
                    }
                }
            }
        }

        private BundleItem _GetBundleItem(string itemName)
        {
            foreach(Bundle bundle in DataManager.Bundles)
            {
                foreach(BundleItem bundleItem in bundle.items)
                {
                    if (bundleItem.item_name == itemName) return bundleItem;
                }
            }
            return null;
        }
    }
}
