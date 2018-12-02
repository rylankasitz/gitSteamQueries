using System;
using System.Collections.Generic;
using System.Data;
using System.Text;

namespace GitSteamedDatabase.CSTableObjects
{
    public class ReviewsCSTable : TableCreater
    {
        public ReviewsCSTable(DataManager dataManager) : base(dataManager)
        {
        }

        public override void MakeTable()
        {
            DataTable table = new DataTable("Items");

            DataColumn ReviewID = new DataColumn();
            ReviewID.DataType = System.Type.GetType("System.Int32");
            ReviewID.ColumnName = "ReviewID";
            ReviewID.AutoIncrement = true;
            ReviewID.AutoIncrementSeed = 1;
            table.Columns.Add(ReviewID);

            DataColumn Username = new DataColumn();
            Username.DataType = System.Type.GetType("System.String");
            Username.ColumnName = "Username";
            table.Columns.Add(Username);

            DataColumn ItemID = new DataColumn();
            ItemID.DataType = System.Type.GetType("System.Int32");
            ItemID.ColumnName = "ItemID";
            table.Columns.Add(ItemID);

            DataColumn Funny = new DataColumn();
            Funny.DataType = System.Type.GetType("System.Int32");
            Funny.ColumnName = "Funny";
            Funny.DefaultValue = 0;
            table.Columns.Add(Funny);

            DataColumn Posted = new DataColumn();
            Posted.DataType = System.Type.GetType("System.DateTime");
            Posted.ColumnName = "Posted";
            Posted.DefaultValue = DateTime.Now;
            table.Columns.Add(Posted);

            DataColumn LastEdited = new DataColumn();
            LastEdited.DataType = System.Type.GetType("System.DateTime");
            LastEdited.ColumnName = "LastEdited";
            LastEdited.DefaultValue = DateTime.Now;
            table.Columns.Add(LastEdited);

            DataColumn Helpful = new DataColumn();
            Helpful.DataType = System.Type.GetType("System.Int32");
            Helpful.ColumnName = "Helpful";
            table.Columns.Add(Helpful);

            DataColumn Recommend = new DataColumn();
            Recommend.DataType = System.Type.GetType("System.Byte");
            Recommend.ColumnName = "Recommend";
            Recommend.DefaultValue = 0;
            table.Columns.Add(Recommend);

            DataColumn Description = new DataColumn();
            Description.DataType = System.Type.GetType("System.String");
            Description.ColumnName = "Description";
            table.Columns.Add(Description);

            table.AcceptChanges();
            DataManager.ReviewsDataTable = table;
        }
    }
}
