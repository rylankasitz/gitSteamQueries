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
            GenreID.AutoIncrementSeed = 1
            table.Columns.Add(GenreID);

            DataColumn Name = new DataColumn();
            Name.DataType = System.Type.GetType("System.String");
            Name.ColumnName = "Name";
            table.Columns.Add(Name);

            table.AcceptChanges();
            DataManager.GenreDataTable = table;

            _AddGenre("Action");
            _AddGenre("Adventure");
            _AddGenre("Strategy");
            _AddGenre("Racing");
            _AddGenre("Indie");
            _AddGenre("RPG");
            _AddGenre("Casual");
            _AddGenre("Simulation");
            _AddGenre("Sports");
            _AddGenre("Education");
        }

        private void _AddGenre(string name)
        {
            DataRow row = DataManager.GenreDataTable.NewRow();
            row["Name"] = name;
            DataManager.GenreDataTable.Rows.Add(row);
        }
    }
}
