﻿using System;
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
            List<int> addedItems = new List<int>();
            int genreID = 1;
            foreach(UserItem userItem in DataManager.UserItems)
            {
                _AddUser(userItem.user_id, userItem.user_url, userItem.items_count);
                foreach (Item item in userItem.items)
                {
                    BundleItem bundleItem = _GetBundleItem(item.item_name);
                    if (bundleItem != null && !addedItems.Contains(item.item_id))
                    {
                        _AddItem(item.item_id, item.item_name, bundleItem.item_url, genreID, Math.Round(float.Parse(bundleItem.discounted_price.Replace("$", "")), 2));
                        _AddGenreContents(bundleItem.genre, item.item_id);
                        addedItems.Add(item.item_id);
                        genreID++;
                    }
                    else if(!addedItems.Contains(item.item_id))
                    {
                        _AddItem(item.item_id, item.item_name, null, -1, -1);
                        addedItems.Add(item.item_id);
                    }
                    _AddLibrary(userItem.user_id, item.item_id, item.playtime_forever, item.playtime_2weeks);
                }
                userCount++;
                DataManager.DisplayProgress("User Items Progress: ", userCount, DataManager.UserItems.Count, DataManager.UserItems.Count / 1000);
            }
            DataManager.DisplayProgress("User Items Progress: ", 1, 1, 1);
            Console.WriteLine("\nAdded " + userCount + " users"); 
            DataManager.AddTable("Genres", DataManager.GenreDataTable);
            DataManager.AddTable("Users", DataManager.UserDataTable);
            DataManager.AddTable("Items", DataManager.ItemDataTable);
            DataManager.AddTable("ItemsGenreContents", DataManager.GenreContentsTable);
            DataManager.AddTable("Libraries", DataManager.LibraryDataTable);
        }

        #region Private Helper Methods

        private void _AddUser(string username, string url, int itemcount)
        {
            DataRow row = DataManager.UserDataTable.NewRow();
            row["Username"] = username;
            row["Url"] = url;
            row["ItemCount"] = itemcount;
            DataManager.UserDataTable.Rows.Add(row);
        }

        private void _AddItem(int itemid, string itemname, string url, int genre, double price)
        {
            DataRow row = DataManager.ItemDataTable.NewRow();
            row["ItemID"] = itemid;
            row["URL"] = url;
            row["Name"] = itemname;
            if(price != -1) row["Price"] = price;
            DataManager.ItemDataTable.Rows.Add(row);
        }

        private void _AddLibrary(string username, int itemid, int playtimeforever, int playtime2weeks)
        {
            DataRow row = DataManager.LibraryDataTable.NewRow();
            row["ItemID"] = itemid;
            row["Username"] = username;
            row["TimePlayedForever"] = playtimeforever;
            row["TimePlayed2Weeks"] = playtime2weeks;
            DataManager.LibraryDataTable.Rows.Add(row);
        }

        private void _AddGenreContents(string genreName, int itemID)
        {
            string[] genres = new string[1];
            if (genreName.Contains(", ")) genres = genreName.Split(", ");
            else genres[0] = genreName;
            foreach (string g in genres)
            {
                foreach (DataRow dataRow in DataManager.GenreDataTable.Rows)
                {
                    if (dataRow["Name"].ToString() == g)
                    {
                        DataRow row = DataManager.GenreContentsTable.NewRow();
                        row["GenreID"] = dataRow["GenreID"];
                        row["ItemID"] = itemID;
                        DataManager.GenreContentsTable.Rows.Add(row);
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

        #endregion
    }
}
