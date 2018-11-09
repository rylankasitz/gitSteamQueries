using System;
using System.Collections.Generic;
using System.Linq;
using GitSteamedDatabase.JsonObjects;

namespace GitSteamedDatabase
{
    class Program
    {
        static void Main(string[] args)
        {
            DataManager dataManager = new DataManager();
            var parsers = typeof(Parser).Assembly.GetTypes().Where(type => type.IsSubclassOf(typeof(Parser)));

            foreach(Type parser in parsers)
            {
                var newParser = Activator.CreateInstance(parser, dataManager) as Parser;
                newParser?.Parse();
            }
        }
    }
}
