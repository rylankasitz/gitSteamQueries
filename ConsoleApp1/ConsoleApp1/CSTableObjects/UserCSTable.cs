using System;
using System.Collections.Generic;
using System.Data;
using System.Text;

namespace GitSteamedDatabase.CSTableObjects
{
    public class UserCSTable : TableCreater
    {
        public UserCSTable(DataManager dataManager) : base(dataManager)
        {
        }

        public override void MakeTable()
        {
            DataTable table = new DataTable("Users");

            DataColumn Username = new DataColumn();
            Username.DataType = System.Type.GetType("System.String");
            Username.ColumnName = "Username";
            table.Columns.Add(Username);

            DataColumn ItemCount = new DataColumn();
            ItemCount.DataType = System.Type.GetType("System.Int32");
            ItemCount.ColumnName = "ItemCount";
            table.Columns.Add(ItemCount);

            DataColumn Url = new DataColumn();
            Url.DataType = System.Type.GetType("System.String");
            Url.ColumnName = "Url";
            table.Columns.Add(Url);

            table.AcceptChanges();
            DataManager.UserDataTable = table;
        }
    }
}
