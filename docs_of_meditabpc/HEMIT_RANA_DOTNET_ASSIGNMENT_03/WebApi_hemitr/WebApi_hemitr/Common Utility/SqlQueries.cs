namespace WebApi_hemitr.Common_Utility
{
    public class SqlQueries
    {
        public static IConfiguration _Configuration = new ConfigurationBuilder().AddXmlFile("SqlQueries.xml",true,true).Build();  

        public static string AddInformation { get { return _Configuration["AddInformation"]; } }
    }
}
