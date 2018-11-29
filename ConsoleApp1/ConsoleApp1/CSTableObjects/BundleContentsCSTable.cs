using System;
using System.Collections.Generic;
using System.Data;
using System.Text;

namespace GitSteamedDatabase.CSTableObjects
{
    public class BundleContentsCSTable : TableCreater
    {
        public BundleContentsCSTable(DataManager dataManager) : base(dataManager)
        {
        }

        public override void MakeTable()
        {
            DataTable table = new DataTable("BundleContents");

            DataColumn BundleContentsID = new DataColumn();
            BundleContentsID.DataType = System.Type.GetType("System.Int32");
            BundleContentsID.ColumnName = "BundleContentsID";
            BundleContentsID.AutoIncrement = true;
            table.Columns.Add(BundleContentsID);

            DataColumn BundleID = new DataColumn();
            BundleID.DataType = System.Type.GetType("System.Int32");
            BundleID.ColumnName = "BundleID";
            table.Columns.Add(BundleID);

            DataColumn ItemID = new DataColumn();
            ItemID.DataType = System.Type.GetType("System.Int32");
            ItemID.ColumnName = "ItemID";
            table.Columns.Add(ItemID);

            table.AcceptChanges();
            DataManager.BundleContentsDataTable = table;
        }
    }
}
