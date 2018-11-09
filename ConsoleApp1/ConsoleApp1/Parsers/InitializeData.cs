using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.SqlServer.Management.Common;
using Microsoft.SqlServer.Management.Smo;
using System.Data.SqlClient;
using System.Data;
using System.Data.SqlTypes;
using System.IO;

namespace GitSteamedDatabase.Parsers
{
    public class InitializeData : Parser
    {
        public InitializeData(DataManager dataManager) : base(dataManager)
        {
        }

        public override void Parse()
        {
            using(var connection = new SqlConnection(DataManager.Connection))
            {
                string script = File.ReadAllText(DataManager.QueryLocations + "Tables\\CreateTables.sql");
                Server server = new Server(new ServerConnection(connection));
                server.ConnectionContext.ExecuteNonQuery(script);
            }
        }
    }
}
