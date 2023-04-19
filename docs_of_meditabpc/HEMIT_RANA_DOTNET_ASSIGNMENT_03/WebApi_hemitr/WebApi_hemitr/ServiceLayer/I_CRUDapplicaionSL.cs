using WebApi_hemitr.Models;

namespace WebApi_hemitr.ServiceLayer
{
    public interface I_CRUDapplicaionSL
    {

        public Task<AddInformationResponse> AddInformation(AddPatientInformation request);

    }
}
