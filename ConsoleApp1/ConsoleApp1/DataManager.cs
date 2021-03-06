﻿using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using GitSteamedDatabase.JsonObjects;
using System.Data;
using System.Linq;
using System.Data.SqlClient;

namespace GitSteamedDatabase
{
    public class DataManager
    {
        public List<UserItem> UserItems { get; }
        public List<Bundle> Bundles { get; }
        public List<UserReview> UserReviews { get; }
        public DataTable UserDataTable { get; set; }
        public DataTable ItemDataTable { get; set; }
        public DataTable LibraryDataTable { get; set; }
        public DataTable BundleDataTable { get; set; }
        public DataTable BundleContentsDataTable { get; set; }
        public DataTable ReviewsDataTable { get; set; }
        public DataTable GenreDataTable { get; set; }
        public DataTable GenreContentsTable { get; set; }
        public string Connection { get; } = "Server=tcp:70.179.161.243,5000;Database=master;User Id=rylan;Password=sqlgod";
        public string QueryLocations { get; set; } = "..\\..\\..\\Queries\\";

        public DataManager()
        {
            UserItems =  _LoadJsonFile<UserItem>("australian_users_items.json");
            Bundles = _LoadJsonFile<Bundle>("bundle_data.json");
            UserReviews = _LoadJsonFile<UserReview>("australian_user_reviews.json");

            UserItems = UserItems.GroupBy(x => x.user_id).Select(x => x.First()).ToList();
        }

        public void AddTable(string name, DataTable data)
        {
            data.AcceptChanges();
            using (SqlConnection connection = new SqlConnection(Connection))
            {
                connection.Open();
                using (SqlBulkCopy bulkCopy = new SqlBulkCopy(Connection))
                {
                    bulkCopy.DestinationTableName = "gitSteamed." + name;
                    bulkCopy.BulkCopyTimeout = 2000;
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

        public void DisplayProgress(string message, int count, int total, int frequency)
        {
            if ((count % frequency) == 0)
            {
                Console.Write("\r" + new string(' ', Console.WindowWidth - 1) + "\r");
                Console.Write(message + Math.Round((count / (float) total)*100, 2) + "%");
            }
        }

        private List<T> _LoadJsonFile<T>(string src)
        {
            List<T> objects = new List<T>();
            using (StreamReader r = new StreamReader("JsonFiles\\" + src))
            {
                string line;
                var lineCount = File.ReadLines(@"JsonFiles\\" + src).Count();
                int lineNumber = 0;
                while ((line = r.ReadLine()) != null)
                {
                    objects.Add(JsonConvert.DeserializeObject<T>(line.Replace("\\x", "").Replace("True", "true").Replace("False", "false").Replace("\\U", "")));
                    lineNumber++;
                    DisplayProgress("Loading Json File " + src + " : ", lineNumber, lineCount, lineCount / 75);
                }
                DisplayProgress("Loading Json File " + src + " : ", 1, 1, 1);
                Console.Write("\n");
            }
            return objects;
        }
    }
}
