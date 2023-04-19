using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Npgsql;
using Npgsql.Replication.PgOutput.Messages;
using System.Collections.Generic;
using System.Data;
using WebApi_hemitr.Models;
using WebApi_hemitr.ServiceLayer;

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
        [HttpGet("{id}")]
        public JsonResult Get(int id)
        {
            string query = @"
               --select * from Patients where patient_id=@patient_id and isdeleted=false

                select *  from GetById(@patient_id);
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


       
        /*Pagination and orderby*/
        [HttpGet("GetList")]
        public JsonResult GET(int? PageNumber=1,int? PageSize=10,string? Orderby= "Patients.patient_id")
        {
            string query = @"
                select * FROM getlist_search_patient_and_pagination2(PageNumber=>@PageNumber,PageSize=>@PageSize,orderby=>@orderby);
            ";

            DataTable table = new DataTable();
            string sqlDataSource = _configuration.GetConnectionString("PatientsAppConnection");
            NpgsqlDataReader myReader;
            using (NpgsqlConnection myCon = new NpgsqlConnection(sqlDataSource))
            {
                myCon.Open();
                using (NpgsqlCommand myCommand = new NpgsqlCommand(query, myCon))
                {
                    myCommand.Parameters.AddWithValue("@PageNumber", PageNumber);
                    myCommand.Parameters.AddWithValue("@PageSize", PageSize);
                    
                    myCommand.Parameters.AddWithValue("@orderby", Orderby);

                    myReader = myCommand.ExecuteReader();
                    table.Load(myReader);

                    myReader.Close();
                    myCon.Close();

                }
            }
            
            return new JsonResult((table));
        }

        /*public readonly I_CRUDapplicaionSL _CRUDapplicaionSL;

        public PatientController*/

        /*Insert record*/
        [HttpPost]
        public JsonResult Post(Patients patient_obj)
        {
            /*AddInformationResponse response = new AddInformationResponse();
            try
            {

            }
            catch (Exception ex)
            {

            }*/

            string query = @"
                select Insert_PatientData(@firstname,@lastname,@middlename,@sex_id,@dob::date)
            ";
            /*INSERT INTO Patients(firstname, lastname, middlename, sex_id) VALUES(@firstname, @lastname, @middlename, @sex_id)*/
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
                    myCommand.Parameters.AddWithValue("@dob", patient_obj.dob);

                    myReader = myCommand.ExecuteReader();
                    table.Load(myReader);

                    myReader.Close();
                    myCon.Close();

                }
            }
            //string prettyJson = JToken.Parse(table).ToString(Formatting.Indented);
            return new JsonResult("Added succesfully");
        }

        /*Insert record*//*
        [HttpPost("insert")]
        public async JsonResult Post(AddPatientInformation request)
        {
            AddInformationResponse response = new AddInformationResponse();
            try
            {
                response = await _configuration.AddInformation(request);
            }
            catch (Exception ex)
            {

            }

            
            //string prettyJson = JToken.Parse(table).ToString(Formatting.Indented);
            return Ok();
        }*/

        /*Update record*/

        [HttpPut]
        public JsonResult Put(Patients patient_obj)
        {
            string query = @"
               --update Patients set firstname = @firstname where patient_id=@patient_id and isdeleted=false
                    select UpdateRecord(patientid=>@patient_id,first_name=>@firstname,last_name=>@lastname,middle_name=>@middlename,sex=>@sex,dateofbirth=>@dob::date);
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
            //string prettyJson = JToken.Parse(table).ToString(Formatting.Indented);
            return new JsonResult("Updated succesfully");
        }


        /*Delete by id*/

        [HttpDelete("{id}")]
        public JsonResult Delete(int id)
        {
            string query = @"
               --delete from Patients where patient_id=@patient_id
                --update Patients set isdeleted = true where patient_id=@patient_id

                select * from DeleteRecord(patientid=>@patient_id);
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

        

    }
}


//error codes

/*Get all data*/
/* [HttpGet("ALL")]
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
 }*/

/*Pagination and orderby*/
/*[HttpGet()]
public JsonResult GET(Patients patient_obj)
{
    string query = @"
        select * FROM getlist_search_patient_and_pagination(@PageNumber,@PageSize,first_Name=>@first_name,last_Name=>@last_name,gender=>@sex,dateofbirth=>@dob::date,orderby=>@orderby);
    ";

    DataTable table = new DataTable();
    string sqlDataSource = _configuration.GetConnectionString("PatientsAppConnection");
    NpgsqlDataReader myReader;
    using (NpgsqlConnection myCon = new NpgsqlConnection(sqlDataSource))
    {
        myCon.Open();
        using (NpgsqlCommand myCommand = new NpgsqlCommand(query, myCon))
        {
            myCommand.Parameters.AddWithValue("@PageNumber", patient_obj.PageNumber);
            myCommand.Parameters.AddWithValue("@PageSize", patient_obj.PageSize);
            myCommand.Parameters.AddWithValue("@first_name", patient_obj.first_name);
            myCommand.Parameters.AddWithValue("@last_name",patient_obj.last_name);
            myCommand.Parameters.AddWithValue("@sex", patient_obj.sex);
            myCommand.Parameters.AddWithValue("@dob", patient_obj.dob);
            myCommand.Parameters.AddWithValue("@orderby",patient_obj.Orderby);

            myReader = myCommand.ExecuteReader();
            table.Load(myReader);

            myReader.Close();
            myCon.Close();

        }
    }
    //string prettyJson = JToken.Parse(table).ToString(Formatting.Indented);
    return new JsonResult((table));
}*/