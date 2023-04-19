namespace WebApi_hemitr.Models
{
    public class Patients
    {
        public int patient_id { get; set; }

        public string first_name { get; set; } = string.Empty;
        public string last_name { get; set; } = string.Empty;
        public string middle_name { get; set; } = string.Empty;

        public int sex_id { get; set; }

        public string sex { get; set; } = string.Empty;

        public DateTime dob { get; set; } 

        public bool isdeleted { get; set; }

        public DateTime created_on { get; set; }

        public DateTime modified_on { get; set; }
        /*public int PageNumber { get; set; } = 1;

        public int PageSize { get; set; } = 20;

        public string Orderby { get; set; } = "Patients.patient_id";*/

    }

    public class Pagination
    {
        
    }
}
