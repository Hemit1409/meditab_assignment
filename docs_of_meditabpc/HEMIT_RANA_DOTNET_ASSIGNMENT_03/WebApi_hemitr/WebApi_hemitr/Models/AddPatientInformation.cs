namespace WebApi_hemitr.Models
{
    public class AddPatientInformation
    {
        public int patient_id { get; set; }

        public string first_name { get; set; }
        public string last_name { get; set; }
        public string middle_name { get; set; }

        public int sex_id { get; set; }

        public DateTime dob { get; set; }

        public bool isdeleted { get; set; }

        public DateTime created_on { get; set; }

        public DateTime modified_on { get; set; }
    }

    public class AddInformationResponse
    {
        public bool IsSuccess { get; set; }
        public string Message { get; set; }
    }
}
