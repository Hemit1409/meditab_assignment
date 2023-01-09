using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Npgsql;
using System.Data;
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

        [HttpGet]
        public JsonResult Get()
        {
            string query = @"
                select *
                from Patients where isdeleted=false
            ";

            DataTable table = new DataTable();
            string sqlDataSource = _configuration.GetConnectionString("PatientsAppConnection");
            NpgsqlDataReader myReader;
            using (NpgsqlConnection myCon = new NpgsqlConnection(sqlDataSource))
            {
                myCon.Open();
                using (NpgsqlCommand myCommand = new NpgsqlCommand(query, myCon))
                {
                    myReader = myCommand.ExecuteReader();
                    table.Load(myReader);

                    myReader.Close();
                    myCon.Close();

                }
            }
            //string prettyJson = JToken.Parse(table).ToString(Formatting.Indented);
            return new JsonResult((table));
        }

        [HttpPost]
        public JsonResult Post(Patients patient_obj)
        {
            string query = @"
               INSERT INTO Patients(firstname,lastname,middlename,sex_id) VALUES(@firstname,@lastname,@middlename,@sex_id)
            ";

            DataTable table = new DataTable();
            string sqlDataSource = _configuration.GetConnectionString("PatientsAppConnection");
            NpgsqlDataReader myReader;
            using (NpgsqlConnection myCon = new NpgsqlConnection(sqlDataSource))
            {
                myCon.Open();
                using (NpgsqlCommand myCommand = new NpgsqlCommand(query, myCon))
                {
                    myCommand.Parameters.AddWithValue("@firstname", patient_obj.first_name);
                    myCommand.Parameters.AddWithValue("@lastname", patient_obj.last_name);
                    myCommand.Parameters.AddWithValue("@middlename", patient_obj.middle_name);
                    myCommand.Parameters.AddWithValue("@sex_id", patient_obj.sex_id);
                    //myCommand.Parameters.AddWithValue("@dob", patient_obj.dob);

                    myReader = myCommand.ExecuteReader();
                    table.Load(myReader);

                    myReader.Close();
                    myCon.Close();

                }
            }
            //string prettyJson = JToken.Parse(table).ToString(Formatting.Indented);
            return new JsonResult("Added succesfully");
        }

        [HttpPut]
        public JsonResult Put(Patients patient_obj)
        {
            string query = @"
               update Patients set firstname = @firstname where patient_id=@patient_id and isdeleted=false
            ";

            DataTable table = new DataTable();
            string sqlDataSource = _configuration.GetConnectionString("PatientsAppConnection");
            NpgsqlDataReader myReader;
            using (NpgsqlConnection myCon = new NpgsqlConnection(sqlDataSource))
            {
                myCon.Open();
                using (NpgsqlCommand myCommand = new NpgsqlCommand(query, myCon))
                {
                    myCommand.Parameters.AddWithValue("@patient_id", patient_obj.patient_id);
                    
                    myCommand.Parameters.AddWithValue("@firstname", patient_obj.first_name);

                    myReader = myCommand.ExecuteReader();
                    table.Load(myReader);

                    myReader.Close();
                    myCon.Close();

                }
            }
            //string prettyJson = JToken.Parse(table).ToString(Formatting.Indented);
            return new JsonResult("Updated succesfully");
        }

        [HttpDelete("{id}")]
        public JsonResult Delete(int id)
        {
            string query = @"
               --delete from Patients where patient_id=@patient_id
                update Patients set isdeleted = true where patient_id=@patient_id
            ";

            DataTable table = new DataTable();
            string sqlDataSource = _configuration.GetConnectionString("PatientsAppConnection");
            NpgsqlDataReader myReader;
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
            //string prettyJson = JToken.Parse(table).ToString(Formatting.Indented);
            return new JsonResult("Deleted succesfully");
        }

        [HttpGet("{id}")]
        public JsonResult Get(int id)
        {
            string query = @"
               select *
                from Patients where patient_id=@patient_id and isdeleted=false
            ";

            DataTable table = new DataTable();
            string sqlDataSource = _configuration.GetConnectionString("PatientsAppConnection");
            NpgsqlDataReader myReader;
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
            //string prettyJson = JToken.Parse(table).ToString(Formatting.Indented);
            return new JsonResult((table));
        }

    }
}
