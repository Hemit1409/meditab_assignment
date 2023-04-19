using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using System.Security.Claims;
using WebApi_hemitr.Models;
using WebApi_hemitr.ServiceLayer;

namespace CrudOperation_MysqlDB.Controllers
{
    [Route("api/[controller]/[Action]")]
    [ApiController]
    //[Authorize(AuthenticationSchemes = Microsoft.AspNetCore.Authentication.JwtBearer.JwtBearerDefaults.AuthenticationScheme)] //Jwt
    [Authorize(AuthenticationSchemes = CookieAuthenticationDefaults.AuthenticationScheme)]  //Cookies
    public class CrudApplicationController : ControllerBase
    {
        public readonly I_CRUDapplicaionSL _crudApplicationSL;
        /*public readonly ILogger<CrudApplicationController> _logger;*/
        public CrudApplicationController(I_CRUDapplicaionSL cRudApplicationSL)
        {
            _crudApplicationSL = cRudApplicationSL;
            /*_logger = logger;*/
        }

        [AllowAnonymous]
        [HttpPost]
        //[Route("AddUserInformation")]
        public async Task<IActionResult> RegisterUser(AddPatientInformation request)
        {
            AddInformationResponse response = new AddInformationResponse();
            //_logger.LogInformation($"RegisterUser Api Calling {JsonConvert.SerializeObject(request)}");
            try
            {

                response = await _crudApplicationSL.AddInformation(request);
                /*if (!response.IsSuccess)
                {
                    return BadRequest(new { IsSuccess = response.IsSuccess, Message = response.Message });
                }*/

            }
            catch (Exception ex)
            {
                response.IsSuccess = false;
                response.Message = ex.Message;
               /* _logger.LogError($"RegisterUser Controller Error => {ex.Message}");
                return BadRequest(new { IsSuccess = response.IsSuccess, Message = ex.Message });*/
            }

            return Ok(response);
        }

        

    }
}