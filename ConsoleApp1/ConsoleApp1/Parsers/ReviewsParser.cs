using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using GitSteamedDatabase.JsonObjects;

namespace GitSteamedDatabase.Parsers
{
    public class ReviewsParser : Parser
    {
        public ReviewsParser(DataManager dataManager) : base(dataManager)
        {
        }

        public override void Parse()
        {
            int funny = 0;
            DateTime posted = DateTime.Now;
            DateTime lastEdited = DateTime.Now;
            int helpful = 0;
            int reviewCount = 0;
            foreach (UserReview users in DataManager.UserReviews)
            {
                List<int> addedItems = new List<int>();
                int length = users.reviews.Count * DataManager.UserReviews.Count;
                int freq = length / 1000;
                foreach (Review review in users.reviews)
                {
                    if (review.review.Length > 4000) review.review = review.review.Substring(0, 4000);
                    review.posted = review.posted.Replace("Posted ", "");
                    review.funny = review.funny.Split(" ")[0];
                    review.helpful = review.helpful.Split(" ")[0];
                    if (!Int32.TryParse(review.funny, out funny)) funny = 0;
                    if (!DateTime.TryParse(review.posted, out posted)) posted = DateTime.Now;
                    if (!DateTime.TryParse(review.last_edited, out lastEdited)) lastEdited = posted;
                    if (!Int32.TryParse(review.helpful, out helpful)) helpful = 0;        
                     _AddReview(users.user_id, Int32.Parse(review.item_id), funny, posted, lastEdited, helpful, Convert.ToByte(review.recommend), review.review);
                    addedItems.Add(Int32.Parse(review.item_id));
                    reviewCount++;
                    DataManager.DisplayProgress("Reviews Progress: ", reviewCount, length, freq);
                }
            }
            DataManager.DisplayProgress("Reviews Progress: ", 1, 1, 1);
            Console.WriteLine("\nAdded " + reviewCount + " reviews");
            DataManager.AddTable("Reviews", DataManager.ReviewsDataTable);
        }

        #region Private Helper Methods

        private void _AddReview(string username, int itemid, int funny, DateTime posted, DateTime lastedited, int hepful, int recommended, string description)
        {
            DataRow row = DataManager.ReviewsDataTable.NewRow();
            row["Username"] = username;
            row["ItemID"] = itemid;
            row["Funny"] = funny;
            row["Posted"] = posted;
            row["LastEdited"] = lastedited;
            row["Helpful"] = hepful;
            row["Recommend"] = recommended;
            row["Description"] = description;
            DataManager.ReviewsDataTable.Rows.Add(row);
        }

        #endregion
    }
}
