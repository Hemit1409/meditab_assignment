using Npgsql;
using WebApi_hemitr.Common_Utility;
using WebApi_hemitr.Models;

namespace WebApi_hemitr.DataAccessLayer
{
    public class CRUDapplicationDAL //: I_CRUDapplicationDAL
    {
        public readonly IConfiguration _configuration;
        string sqlDataSource;
        public readonly NpgsqlConnection _NpgsqlConnection;

        public CRUDapplicationDAL(IConfiguration configuration)
        {
            _configuration = configuration;
            _NpgsqlConnection = new NpgsqlConnection(_configuration["ConnectionStrings:PatientsAppConnection"]);
        }
        
        public async Task<AddInformationResponse> AddInformation(AddPatientInformation request)
        {
            AddInformationResponse response = new AddInformationResponse();
            try
            {
                if(_NpgsqlConnection.State != System.Data.ConnectionState.Open)
                {
                    await _NpgsqlConnection.OpenAsync();
                }

                using (NpgsqlCommand myCommand = new NpgsqlCommand(SqlQueries.AddInformation,_NpgsqlConnection))
                {
                    myCommand.CommandType = System.Data.CommandType.Text;
                    myCommand.CommandTimeout = 100;

                    myCommand.Parameters.AddWithValue("@firstname", request.first_name);
                    myCommand.Parameters.AddWithValue("@lastname", request.last_name);
                    myCommand.Parameters.AddWithValue("@middlename", request.middle_name);
                    myCommand.Parameters.AddWithValue("@sex_id", request.sex_id);
                    myCommand.Parameters.AddWithValue("@dob", request.dob);

                    int Status = await myCommand.ExecuteNonQueryAsync();
                    if(Status <= 0) {
                        response.IsSuccess = false;
                        response.Message = "Query not executed";
                        return response;
                    }
                }
            }
            catch (Exception ex)
            {
                response.IsSuccess = false;
                response.Message = ex.Message;
            }
            finally
            {
                await _NpgsqlConnection.CloseAsync();
                await _NpgsqlConnection.DisposeAsync();
            }
            return response;
        }
    }
}
