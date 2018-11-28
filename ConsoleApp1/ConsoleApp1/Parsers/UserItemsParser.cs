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
            int userCount = 0;
            List<Item> addedItems = new List<Item>();
            List<Item> addedBundleItems = new List<Item>();
            Console.WriteLine("Adding User and Items Data");      
            foreach(UserItem userItem in DataManager.UserItems)
            {
                _AddUser(userItem.user_id, userItem.user_url, userItem.items_count);
                foreach (Item item in userItem.items)
                {
                    BundleItem bundleItem = _GetBundleItem(item.item_name);
                    if (bundleItem != null && !addedBundleItems.Contains(item))
                    {
                        _AddItem(item.item_name, bundleItem.item_url, bundleItem.genre, float.Parse(bundleItem.discounted_price.Replace("$", "")));
                        addedBundleItems.Add(item);
                    }
                    else if(!addedBundleItems.Contains(item) && !addedItems.Contains(item))
                    {
                        _AddItem(item.item_name, null, null, 0);
                        addedItems.Add(item);
                    }                      
                }
                userCount++;
                if ((userCount % 10) == 0)
                {
                    Console.Write("\r" + new string(' ', Console.WindowWidth - 1) + "\r");
                    Console.Write("User Count: " + userCount);
                }
                if (userCount == 100) break;
            }
            Console.WriteLine("Added " + userCount + " users");
            _AddTable("Users", DataManager.UserDataTable);
            _AddTable("Items", DataManager.ItemDataTable);

                /*using (var connection = new SqlConnection(DataManager.Connection))
                {
                    connection.Open();
                    Console.WriteLine("Adding data user and item data to the database");
                    int i = 0;
                    foreach (UserItem userItem in DataManager.UserItems)
                    {
                        _AddUser(connection, userItem.user_id, userItem.user_url, userItem.items_count);
                        foreach (Item item in userItem.items)
                        {
                            BundleItem bundleItem = _GetBundleItem(item.item_name);
                            if (bundleItem != null)
                                _AddItem(connection, item.item_name, bundleItem.item_url, bundleItem.genre, float.Parse(bundleItem.discounted_price.Replace("$", "")));
                            else
                                _AddItem(connection, item.item_name, null, null, 0);
                        }
                        if ((i % 10) == 0)
                        {
                            Console.Write("\r" + new string(' ', Console.WindowWidth - 1) + "\r");
                            Console.Write("User row count: " + i);
                        }
                        i++;
                    }
                    Console.WriteLine("Finished adding user and item data to the database");
                }*/
        }

        /*private void _AddUser(SqlConnection connection, string userName, string userURL, int itemCount)
        {
            using (var transaction = new TransactionScope())
            {
                using (var command = new SqlCommand("gitSteamed.AddUser", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("username", userName);
                    command.Parameters.AddWithValue("url", userURL);
                    command.Parameters.AddWithValue("itemcount", itemCount);

                    command.ExecuteNonQuery();
                    transaction.Complete();
                }
            }
        }

        private void _AddItem(SqlConnection connection, string itemName, string itemUrl, string genre, float price)
        {
            using (var transaction = new TransactionScope())
            {
                using (var command = new SqlCommand("gitSteamed.AddItem", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("price", price);
                    if (itemUrl != null) command.Parameters.AddWithValue("url", itemUrl);
                    command.Parameters.AddWithValue("name", itemName);
                    if (genre != null) command.Parameters.AddWithValue("genre", genre);

                    command.ExecuteNonQuery();
                    transaction.Complete();
                }
            }
        }*/

        private void _AddTable(string name, DataTable data)
        {
            data.AcceptChanges();
            using (SqlConnection connection = new SqlConnection(DataManager.Connection))
            {
                connection.Open();
                using (SqlBulkCopy bulkCopy = new SqlBulkCopy(DataManager.Connection))
                {
                    bulkCopy.DestinationTableName = "gitSteamed." + name;
                    try
                    {
                        bulkCopy.WriteToServer(data, DataRowState.Unchanged);               
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine(ex.Message);
                    }
                }
            }
        }
        
        private void _AddUser(string username, string url, int itemcount)
        {
            DataRow row = DataManager.UserDataTable.NewRow();
            row["Username"] = username;
            row["Url"] = url;
            row["ItemCount"] = itemcount;
            DataManager.UserDataTable.Rows.Add(row);
        }

        private void _AddItem(string itemname, string url, string genre, float price)
        {
            DataRow row = DataManager.ItemDataTable.NewRow();
            row["Genre"] = genre;
            row["URL"] = url;
            row["Name"] = itemname;
            row["Price"] = price;
            DataManager.ItemDataTable.Rows.Add(row);
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
