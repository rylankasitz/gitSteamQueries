using System;
using System.Collections.Generic;
using System.Data;
using System.Text;

namespace GitSteamedDatabase.CSTableObjects
{
    public class BundleCSTable : TableCreater
    {
        public BundleCSTable(DataManager dataManager) : base(dataManager)
        {
        }

        public override void MakeTable()
        {
            DataTable table = new DataTable("Bundles");

            DataColumn BundleID = new DataColumn();
            BundleID.DataType = System.Type.GetType("System.Int32");
            BundleID.ColumnName = "BundleID";
            table.Columns.Add(BundleID);

            DataColumn Name = new DataColumn();
            Name.DataType = System.Type.GetType("System.String");
            Name.ColumnName = "Name";
            table.Columns.Add(Name);

            DataColumn URL = new DataColumn();
            URL.DataType = System.Type.GetType("System.String");
            URL.ColumnName = "URL";
            table.Columns.Add(URL);

            DataColumn FinalPrice = new DataColumn();
            FinalPrice.DataType = System.Type.GetType("System.Double");
            FinalPrice.ColumnName = "FinalPrice";
            table.Columns.Add(FinalPrice);

            DataColumn DiscountPrice = new DataColumn();
            DiscountPrice.DataType = System.Type.GetType("System.Double");
            DiscountPrice.ColumnName = "DiscountPrice";
            table.Columns.Add(DiscountPrice);

            table.AcceptChanges();
            DataManager.BundleDataTable = table;
        }
    }
}
