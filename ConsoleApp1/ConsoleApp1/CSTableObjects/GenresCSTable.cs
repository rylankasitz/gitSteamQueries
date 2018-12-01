using System;
using System.Collections.Generic;
using System.Data;
using System.Text;

namespace GitSteamedDatabase.CSTableObjects
{
    public class GenresCSTable : TableCreater
    {
        public GenresCSTable(DataManager dataManager) : base(dataManager)
        {
        }

        public override void MakeTable()
        {
            DataTable table = new DataTable("Genres");

            DataColumn GenreID = new DataColumn();
            GenreID.DataType = System.Type.GetType("System.Int32");
            GenreID.ColumnName = "GenreID";
            GenreID.AutoIncrement = true;
            table.Columns.Add(GenreID);

            DataColumn Action = new DataColumn();
            Action.DataType = System.Type.GetType("System.Byte");
            Action.ColumnName = "Action";
            Action.DefaultValue = 0;
            table.Columns.Add(Action);

            DataColumn Indie = new DataColumn();
            Indie.DataType = System.Type.GetType("System.Byte");
            Indie.ColumnName = "Indie";
            Indie.DefaultValue = 0;
            table.Columns.Add(Indie);

            DataColumn Strategy = new DataColumn();
            Strategy.DataType = System.Type.GetType("System.Byte");
            Strategy.ColumnName = "Strategy";
            Strategy.DefaultValue = 0;
            table.Columns.Add(Strategy);

            DataColumn RPG = new DataColumn();
            RPG.DataType = System.Type.GetType("System.Byte");
            RPG.ColumnName = "RPG";
            RPG.DefaultValue = 0;
            table.Columns.Add(RPG);

            DataColumn Casual = new DataColumn();
            Casual.DataType = System.Type.GetType("System.Byte");
            Casual.ColumnName = "Casual";
            Casual.DefaultValue = 0;
            table.Columns.Add(Casual);

            DataColumn Simulation = new DataColumn();
            Simulation.DataType = System.Type.GetType("System.Byte");
            Simulation.ColumnName = "Simulation";
            Simulation.DefaultValue = 0;
            table.Columns.Add(Simulation);

            DataColumn EarlyAccess = new DataColumn();
            EarlyAccess.DataType = System.Type.GetType("System.Byte");
            EarlyAccess.ColumnName = "Early Access";
            EarlyAccess.DefaultValue = 0;
            table.Columns.Add(EarlyAccess);

            DataColumn Racing = new DataColumn();
            Racing.DataType = System.Type.GetType("System.Byte");
            Racing.ColumnName = "Racing";
            Racing.DefaultValue = 0;
            table.Columns.Add(Racing);

            DataColumn Sports = new DataColumn();
            Sports.DataType = System.Type.GetType("System.Byte");
            Sports.ColumnName = "Sports";
            Sports.DefaultValue = 0;
            table.Columns.Add(Sports);

            DataColumn Education = new DataColumn();
            Education.DataType = System.Type.GetType("System.Byte");
            Education.ColumnName = "Education";
            Education.DefaultValue = 0;
            table.Columns.Add(Education);

            DataColumn Adventure = new DataColumn();
            Adventure.DataType = System.Type.GetType("System.Byte");
            Adventure.ColumnName = "Adventure";
            Adventure.DefaultValue = 0;
            table.Columns.Add(Adventure);

            table.AcceptChanges();
            DataManager.GenreDataTable = table;
        }
    }
}
