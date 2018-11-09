using System;
using System.Collections.Generic;
using System.Text;

namespace GitSteamedDatabase
{
    public abstract class Parser
    {
        public DataManager DataManager { get; protected set; }
        public Parser(DataManager dataManager) { DataManager = dataManager; }
        public abstract void Parse();
    }
}
