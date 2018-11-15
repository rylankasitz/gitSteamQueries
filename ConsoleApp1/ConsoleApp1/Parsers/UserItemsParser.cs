using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Text;
using System.Transactions;
using GitSteamedDatabase.JsonObjects;
using System.Data;

namespace GitSteamedDatabase.Parsers
{
    public class UserItemsParser : Parser
    {
        public UserItemsParser(DataManager dataManager) : base(dataManager)
        {
        }

        public override void Parse()
        {
            foreach (UserItem userItem in DataManager.UserItems)
            {
                _AddUser(userItem.user_id, userItem.user_url, userItem.item_count);
                foreach (Item item in userItem.items)
                {

                }
            }
        }

        private void _AddUser(string userName, string userURL, int itemCount)
        {
            using (var transaction = new TransactionScope())
            {
                using (var connection = new SqlConnection(DataManager.Connection))
                {
                    using (var command = new SqlCommand("Demo.AddUser", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.AddWithValue("username", userName);
                        command.Parameters.AddWithValue("url", userURL);
                        command.Parameters.AddWithValue("itemcount", itemCount);

                        connection.Open();
                        command.ExecuteNonQuery();
                        transaction.Complete();
                    }
                }
            }
        }
    }
}
