using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using GitSteamedDatabase.JsonObjects;

namespace GitSteamedDatabase
{
    public class DataManager
    {
        public List<UserItem> UserItems { get; }
        public DataManager()
        {
            UserItems =  _LoadJsonFile<UserItem>("australian_users_items.json");
        }

        private List<T> _LoadJsonFile<T>(string src)
        {
            List<T> objects = new List<T>();
            using (StreamReader r = new StreamReader("JsonFiles\\" + src))
            {
                string line;
                while ((line = r.ReadLine()) != null)
                {
                    objects.Add(JsonConvert.DeserializeObject<T>(line.Replace("\\x", "")));
                }            
            }
            return objects;
        }
    }
}
