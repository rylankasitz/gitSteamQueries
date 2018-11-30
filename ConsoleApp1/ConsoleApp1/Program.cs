using System;
using System.Collections.Generic;
using System.Linq;
using GitSteamedDatabase.JsonObjects;
using GitSteamedDatabase.Parsers;

namespace GitSteamedDatabase
{
    class Program
    {
        static void Main(string[] args)
        {
            DataManager dataManager = new DataManager();
            InitializeData initializeData = new InitializeData(dataManager);
            var parsers = typeof(Parser).Assembly.GetTypes().Where(type => type.IsSubclassOf(typeof(Parser)));
            var tableCreators = typeof(TableCreater).Assembly.GetTypes().Where(type => type.IsSubclassOf(typeof(TableCreater)));

            initializeData.Parse();

            foreach (Type tableCreater in tableCreators)
            {
                var newTableCreator = Activator.CreateInstance(tableCreater, dataManager) as TableCreater;
                newTableCreator?.MakeTable();
            }
            foreach (Type parser in parsers)
            {
                var newParser = Activator.CreateInstance(parser, dataManager) as Parser;
                newParser?.Parse();
            }
        }
    }
}
