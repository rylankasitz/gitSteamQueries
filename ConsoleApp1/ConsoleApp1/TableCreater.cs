using System;
using System.Collections.Generic;
using System.Text;

namespace GitSteamedDatabase
{
    public abstract class TableCreater
    {
        public DataManager DataManager { get; protected set; }
        public TableCreater(DataManager dataManager) { DataManager = dataManager; }
        public abstract void MakeTable();
    }
}
