using WebApi_hemitr.DataAccessLayer;
using WebApi_hemitr.Models;

namespace WebApi_hemitr.ServiceLayer
{
    public class CRUDapplicationSL //: I_CRUDapplicaionSL
    {
        public readonly I_CRUDapplicationDAL _CRUDapplicaionDAL;
        public CRUDapplicationSL(I_CRUDapplicationDAL CRUDapplicaionDAL)
        {

            _CRUDapplicaionDAL = CRUDapplicaionDAL;

        }

        public async Task<AddInformationResponse> AddInformation(AddPatientInformation request)
        {
            return await _CRUDapplicaionDAL.AddInformation(request);
        }
    }
}
