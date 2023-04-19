using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Npgsql;
using Npgsql.Replication.PgOutput.Messages;
using System.Collections.Generic;
using System.Data;
using System.Runtime.CompilerServices;
using System.Transactions;
using WebApi_hemitr.Models;


namespace WebApi_hemitr.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PatientController : ControllerBase
    {
        private readonly IConfiguration _configuration;

        public PatientController(IConfiguration configuration)
        {
            _configuration = configuration;
        }


        /*get by ID*/

        /// <summary>
        /// This method returns the patient record by the patient_id
        /// <example>
        /// For example:
        /// id = 3
        /// results in records of patient having patient_id 3.
        /// </example>
        /// </summary>
        /// <param name="id">
        ///         3
        /// </param>
        /// <returns>
        /// [{"patient_id":3,"firstname":"SUMEET","lastname":"SHAH","middlename":"S","sex_id":1,"dob":"2002-01-01"}]
        /// </returns>

        [HttpGet("{id}")]
        public List<Patients> PatientGetbyID(int id)
        {
            string query = @"

                select *  from PatientGetbyID(@patient_id);
            ";

            DataTable table = new DataTable();
            string sqlDataSource = _configuration.GetConnectionString("PatientsAppConnection");
            NpgsqlDataReader myReader;

            System.IO.StringWriter writer = new System.IO.StringWriter();

                
                    using (NpgsqlConnection myCon = new NpgsqlConnection(sqlDataSource))
                    {
                        myCon.Open();
                        using (NpgsqlCommand myCommand = new NpgsqlCommand(query, myCon))
                        {
                            myCommand.Parameters.AddWithValue("@patient_id", id);
                            myReader = myCommand.ExecuteReader();
                            table.Load(myReader);
                            
                            myReader.Close();
                            myCon.Close();
                            

                        }
                    }
            List<Patients> patientList = new List<Patients>();

            patientList = Patients.GetListByID(table);

            return patientList;

        }





        /*getlist with Pagination and orderby*/

        /// <summary>
        /// This method returns the patient record by the firstname, lastname, sex and dateofbirth according to the pagenumber and pagesize and orderby sorting
        /// </summary>
        /// <example>
        /// For example:
        /// /api/Patient/GetList?PageNumber=1&PageSize=5
        /// results in records of patient having paginayion of pagesize of 5 records and 1 page number
        /// </example>
        /// <param name="patient_obj"></param>
        /// <param name="PageNumber">1</param>
        /// <param name="PageSize">10</param>
        /// 
        /// <returns>
        /// [{"patientid":1,"firstname":"HEMIT","lastname":"RANA","dob":"2000-01-01T00:00:00","chart_number":"CHART001","sex":"MALE"},
        /// {"patientid":20,"firstname":"RUTI","lastname":"SHAH","dob":"2000-01-01T00:00:00","chart_number":"CHART0020","sex":"FEMALE"}]
        /// </returns>

        [HttpPost("GetList")]
        public List<Patients> patientget(Patients patient_obj,int PageNumber = 1, int PageSize = 10)
        {
            string query = @"
                select * FROM patientget(@PageNumber,@PageSize,first_Name=>@first_name,last_Name=>@last_name,gender=>@sex,dateofbirth=>@dob,orderby=>@orderby);
            ";

            DataTable table = new DataTable();
            string sqlDataSource = _configuration.GetConnectionString("PatientsAppConnection");
            NpgsqlDataReader myReader;

            System.IO.StringWriter writer = new System.IO.StringWriter();

           
                
                    using (NpgsqlConnection myCon = new NpgsqlConnection(sqlDataSource))
                    {
                        myCon.Open();
                        using (NpgsqlCommand myCommand = new NpgsqlCommand(query, myCon))
                        {
                            myCommand.Parameters.AddWithValue("@PageNumber", PageNumber);
                            myCommand.Parameters.AddWithValue("@PageSize", PageSize);
                            myCommand.Parameters.AddWithValue("@first_name", patient_obj.first_name);
                            myCommand.Parameters.AddWithValue("@last_name", patient_obj.last_name);
                            myCommand.Parameters.AddWithValue("@sex", patient_obj.sex);
                            myCommand.Parameters.AddWithValue("@dob", patient_obj.dob);
                            myCommand.Parameters.AddWithValue("@orderby", patient_obj.Orderby);

                            myReader = myCommand.ExecuteReader();
                            table.Load(myReader);

                            myReader.Close();
                            myCon.Close();

                        }
                    }

            List<Patients> patientList = new List<Patients>();

            patientList = Patients.GetListByTable(table);

            return patientList;

        }



        /*Insert record*/

        /// <summary>
        /// This method inserts the patient record with the firstname, lastname, middlename, sex, dob and returns the newly created primary key
        /// </summary>
        /// <param name="patient_obj">insert a JSON body containing "firstname": "KRUNAL","lastname": "RANA","middlename": "T","sex_id": 1,"dob": "2009-01-01"</param>
        /// <returns>
        /// [{"patientcreate":22}]
        /// </returns>

        [HttpPost("create")]
        public JsonResult patientcreate(Patients patient_obj)
        {

            string query = @"
                select patientcreate(@firstname,@lastname,@middlename,@sex_id,@dob::date)
            ";
            /*INSERT INTO Patients(firstname, lastname, middlename, sex_id) VALUES(@firstname, @lastname, @middlename, @sex_id)*/
            DataTable table = new DataTable();
            string sqlDataSource = _configuration.GetConnectionString("PatientsAppConnection");
            NpgsqlDataReader myReader;

            System.IO.StringWriter writer = new System.IO.StringWriter();

            

            try
            {
                using (TransactionScope scope = new TransactionScope())
                {
                    using (NpgsqlConnection myCon = new NpgsqlConnection(sqlDataSource))
                    {
                        myCon.Open();
                        using (NpgsqlCommand myCommand = new NpgsqlCommand(query, myCon))
                        {
                            myCommand.Parameters.AddWithValue("@firstname", patient_obj.first_name);
                            myCommand.Parameters.AddWithValue("@lastname", patient_obj.last_name);
                            myCommand.Parameters.AddWithValue("@middlename", patient_obj.middle_name);
                            myCommand.Parameters.AddWithValue("@sex_id", patient_obj.sex_id);
                            myCommand.Parameters.AddWithValue("@dob", patient_obj.dob);

                            /*if (patient_obj.first_name == "")
                            {
                                throw new InvalidOperationException("firstname is required");
                            }*/

                            myReader = myCommand.ExecuteReader();
                            table.Load(myReader);

                            myReader.Close();
                            myCon.Close();

                        }
                    }
                    scope.Complete();
                }
            }
            catch (TransactionAbortedException ex)
            {
                writer.WriteLine("TransactionAbortedException Message: {0}", ex.Message);
            }

            return new JsonResult((table));


        }



        /*Update record*/

        /// <summary>
        /// This method inserts the patient record with the firstname, lastname, middlename, sex, dob and returns the updated record patient id
        /// passing sex as the string (MALE,FEMALE,UNKNOWN) and in the query retrieving the sexid through the string by joining sex table
        /// </summary>
        /// <param name="patient_obj">insert a JSON body containing "patient_id": 21,"firstname": "SHWETA","lastname": "SHAH","middlename": "S","sex": MALE,"dob": "2002-01-01"</param>
        /// <returns>
        /// [{"patientupdate":21}]
        /// </returns>

        [HttpPut("Update")]
        public JsonResult patientupdate(Patients patient_obj)
        {
            string query = @"
    
                    select patientupdate(patientid=>@patient_id,first_name=>@firstname,last_name=>@lastname,middle_name=>@middlename,sex=>@sex,dateofbirth=>@dob::date);
            ";

            DataTable table = new DataTable();
            string sqlDataSource = _configuration.GetConnectionString("PatientsAppConnection");
            NpgsqlDataReader myReader;

            System.IO.StringWriter writer = new System.IO.StringWriter();

            try
            {
                using (TransactionScope scope = new TransactionScope())
                {
                    using (NpgsqlConnection myCon = new NpgsqlConnection(sqlDataSource))
                    {
                        myCon.Open();
                        using (NpgsqlCommand myCommand = new NpgsqlCommand(query, myCon))
                        {
                            myCommand.Parameters.AddWithValue("@patient_id", patient_obj.patient_id);
                            
                            myCommand.Parameters.AddWithValue("@firstname", patient_obj.first_name);
                            myCommand.Parameters.AddWithValue("@lastname", patient_obj.last_name);
                            myCommand.Parameters.AddWithValue("@middlename", patient_obj.middle_name);
                            myCommand.Parameters.AddWithValue("@sex", patient_obj.sex);
                            myCommand.Parameters.AddWithValue("@dob", patient_obj.dob);

                            myReader = myCommand.ExecuteReader();
                            table.Load(myReader);

                            myReader.Close();
                            myCon.Close();

                        }
                    }
                    scope.Complete();
                }
            }
            catch (TransactionAbortedException ex)
            {
                writer.WriteLine("TransactionAbortedException Message: {0}", ex.Message);
            }


            
            //string prettyJson = JToken.Parse(table).ToString(Formatting.Indented);
            return new JsonResult((table));
            
        }


        /*Delete by id*/

        /// <summary>
        /// This method takes the id as input and soft deletes the patient record with the updating the value of "isdeleted" column to TRUE
        /// </summary>
        /// <param name="id">21</param>
        /// <returns>
        /// "patient_id 21 is Deleted succesfully"
        /// </returns>

        [HttpDelete("{id}")]
        public JsonResult patientdelete(int id)
        {
            string query = @"

                select * from patientdelete(patientid=>@patient_id);
            ";

            DataTable table = new DataTable();
            string sqlDataSource = _configuration.GetConnectionString("PatientsAppConnection");
            NpgsqlDataReader myReader;

            System.IO.StringWriter writer = new System.IO.StringWriter();

            
                    using (NpgsqlConnection myCon = new NpgsqlConnection(sqlDataSource))
                    {
                        myCon.Open();
                        using (NpgsqlCommand myCommand = new NpgsqlCommand(query, myCon))
                        {
                            myCommand.Parameters.AddWithValue("@patient_id", id);


                            myReader = myCommand.ExecuteReader();
                            table.Load(myReader);

                            myReader.Close();
                            myCon.Close();

                        }
                    }
                

            return new JsonResult("patient_id " + id + " is Deleted succesfully");
        }

    }
}
