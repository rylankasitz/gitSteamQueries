using System;
using System.Collections.Generic;
using System.Data;
using System.Text;

namespace GitSteamedDatabase.CSTableObjects
{
    public class GenreContentsCSTable : TableCreater
    {
        public GenreContentsCSTable(DataManager dataManager) : base(dataManager)
        {
        }

        public override void MakeTable()
        {
            DataTable table = new DataTable("ItemsGenreContents");

            DataColumn ItemsGenreID = new DataColumn();
            ItemsGenreID.DataType = System.Type.GetType("System.Int32");
            ItemsGenreID.ColumnName = "ItemsGenreID";
            ItemsGenreID.AutoIncrement = true;
            ItemsGenreID.AutoIncrementSeed = 1;
            table.Columns.Add(ItemsGenreID);

            DataColumn GenreID = new DataColumn();
            GenreID.DataType = System.Type.GetType("System.Int32");
            GenreID.ColumnName = "GenreID";
            table.Columns.Add(GenreID);

            DataColumn ItemID = new DataColumn();
            ItemID.DataType = System.Type.GetType("System.Int32");
            ItemID.ColumnName = "ItemID";
            table.Columns.Add(ItemID);

            table.AcceptChanges();
            DataManager.GenreContentsTable = table;
        }
    }
}
