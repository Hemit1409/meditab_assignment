using WebApi_hemitr.Models;

namespace WebApi_hemitr.DataAccessLayer
{
    public interface I_CRUDapplicationDAL
    {
        public Task<AddInformationResponse> AddInformation(AddPatientInformation request);
    }
}
