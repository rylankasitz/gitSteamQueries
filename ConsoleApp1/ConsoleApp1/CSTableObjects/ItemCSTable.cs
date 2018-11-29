using System;
using System.Collections.Generic;
using System.Data;
using System.Text;

namespace GitSteamedDatabase.CSTableObjects
{
    public class ItemCSTable : TableCreater
    {
        public ItemCSTable(DataManager dataManager) : base(dataManager)
        {
        }

        public override void MakeTable()
        {
            DataTable table = new DataTable("Items");

            DataColumn ItemID = new DataColumn();
            ItemID.DataType = System.Type.GetType("System.Int32");
            ItemID.ColumnName = "ItemID";
            table.Columns.Add(ItemID);

            DataColumn Genre = new DataColumn();
            Genre.DataType = System.Type.GetType("System.String");
            Genre.ColumnName = "Genre";
            table.Columns.Add(Genre);

            DataColumn Price = new DataColumn();
            Price.DataType = System.Type.GetType("System.Double");
            Price.ColumnName = "Price";
            table.Columns.Add(Price);

            DataColumn URL = new DataColumn();
            URL.DataType = System.Type.GetType("System.String");
            URL.ColumnName = "URL";
            table.Columns.Add(URL);

            DataColumn Name = new DataColumn();
            Name.DataType = System.Type.GetType("System.String");
            Name.ColumnName = "Name";
            table.Columns.Add(Name);

            DataColumn Archived = new DataColumn();
            Archived.DataType = System.Type.GetType("System.DateTime");
            Archived.ColumnName = "Archived";
            table.Columns.Add(Archived);

            table.AcceptChanges();
            DataManager.ItemDataTable = table;
        }
    }
}
