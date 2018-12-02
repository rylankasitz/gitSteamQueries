using System;
using System.Collections.Generic;
using System.Data;
using System.Text;

namespace GitSteamedDatabase.CSTableObjects
{
    public class LibraryCSTable : TableCreater
    {
        public LibraryCSTable(DataManager dataManager) : base(dataManager)
        {
        }

        public override void MakeTable()
        {
            DataTable table = new DataTable("Users");

            DataColumn LibraryID = new DataColumn();
            LibraryID.DataType = System.Type.GetType("System.Int32");
            LibraryID.ColumnName = "LibraryID";
            LibraryID.AutoIncrementSeed = 1;
            LibraryID.AutoIncrement = true;
            table.Columns.Add(LibraryID);

            DataColumn Username = new DataColumn();
            Username.DataType = System.Type.GetType("System.String");
            Username.ColumnName = "Username";
            table.Columns.Add(Username);

            DataColumn ItemId = new DataColumn();
            ItemId.DataType = System.Type.GetType("System.Int32");
            ItemId.ColumnName = "ItemID";
            table.Columns.Add(ItemId);

            DataColumn TimePlayedForever = new DataColumn();
            TimePlayedForever.DataType = System.Type.GetType("System.Int32");
            TimePlayedForever.ColumnName = "TimePlayedForever";
            table.Columns.Add(TimePlayedForever);

            DataColumn TimePlayed2Weeks = new DataColumn();
            TimePlayed2Weeks.DataType = System.Type.GetType("System.Int32");
            TimePlayed2Weeks.ColumnName = "TimePlayed2Weeks";
            table.Columns.Add(TimePlayed2Weeks);

            table.AcceptChanges();
            DataManager.LibraryDataTable = table;
        }
    }
}
