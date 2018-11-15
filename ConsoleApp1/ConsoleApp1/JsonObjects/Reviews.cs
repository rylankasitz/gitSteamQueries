using System;
using System.Collections.Generic;
using System.Text;

namespace GitSteamedDatabase.JsonObjects
{
    public class UserReview
    {
        public string user_id { get; set; }
        public string user_url { get; set; }
        public List<Review> reviews { get; set; }
    }

    public class Review
    {
        public string funny { get; set; }
        public string posted { get; set; }
        public string last_edited { get; set; }
        public string item_id { get; set; }
        public string helpful { get; set; }
        public bool recommend { get; set; }
        public string review { get; set; }
    }
}
