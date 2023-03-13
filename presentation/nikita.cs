public async Task<List<nikita_patient>> GetByIdAsync(int id)
        {
            /*string cmd = objTFilter.PostgresParametersRead(dc, RequestType.Read);
            cmd = "(" + cmd + ", patientid => "+id+ ")";
            cmd = ExecuteSP.POSTGRESQL + DatabaseHelper.GetCrudSPName(CrudSPType.Read,dc) + cmd;
            */
            string query = "select * from Nikita_patientgetbyId(patientid=>" + id + ")";
            var PatientList = new List<nikita_patient>();
            try
            {
                using (IDbConnection db = _db.OpenConnection(read: true))
                {
                    //var jsonstring = db.Query<string>(query).ToList().FirstOrDefault();
                    List<nikita_patient> patient_list = db.Query<dynamic>(query)
                                   .Select(item => new nikita_patient()
                                   {
                                       //model fields     //return fields procedure
                                       Patient_id = (int)item.patient_id,
                                       chart_number = (string)item.chart_number,
                                       first_name = (string)item.firstname,
                                       last_name = (string)item.lastname,
                                       middle_name = (string)item.middlename,
                                       sex = (int)item.sex_id,
                                       _sex = (string)item.sex,
                                       dob = item.dob.ToString(),
                                       AllergyName = (string)item.allergyname,
                                       Allergy = new List<nikita_AllergiesBORequest>()
                                        {
                                            new nikita_AllergiesBORequest()
                                            {
                                                PatientAllergyId = (int)item.patientallergyid,
                                                AllergyMaster_id = (int)item.allergymasterid,
                                                allergyName = (string)item.allergyname,
                                                Note = (string)item.note
                                            }

                                        }

                                   })
                                    .ToList();
                    if (patient_list.Count == 0)
                    {
                        return patient_list;
                    }
                    else
                    {
                        
                        int pointer1 = 0, pointer2 = 0;
                        nikita_patient pobj = new nikita_patient();
                        List<nikita_AllergiesBORequest> allergyModelList = new List<nikita_AllergiesBORequest>();

                        pobj.Patient_id = Convert.ToInt32(id);
                        pobj.chart_number = Convert.ToString(patient_list[0].chart_number);
                        pobj.first_name = Convert.ToString(patient_list[0].first_name);
                        pobj.middle_name = Convert.ToString(patient_list[0].middle_name);
                        pobj.last_name = Convert.ToString(patient_list[0].last_name);
                        pobj._sex = Convert.ToString(patient_list[0]._sex);
                        pobj.sex = Convert.ToInt32(patient_list[0].sex);
                        pobj.dob = Convert.ToString(patient_list[0].dob);

                        Console.WriteLine("......" + patient_list.Count);
                        //Console.WriteLine("=> " + patient_list[1].Allergy[0].AllergyMaster_id.ToString());
                        for (pointer2 = pointer1; pointer2 < patient_list.Count; pointer2++)
                        {
                            pointer1 = pointer2;

                            if (pobj.Patient_id == Convert.ToInt32(patient_list[pointer2].Patient_id.ToString()))
                            {
                                //Console.WriteLine("888 "+ patient_list[0].Allergy[pointer2].AllergyMaster_id.ToString());

                                nikita_AllergiesBORequest aobj = new nikita_AllergiesBORequest();
                                aobj.PatientAllergyId = Convert.ToInt32(patient_list[pointer2].Allergy[0].PatientAllergyId.ToString());
                                aobj.AllergyMaster_id = Convert.ToInt32(patient_list[pointer2].Allergy[0].AllergyMaster_id.ToString());
                                aobj.allergyName = patient_list[pointer2].Allergy[0].allergyName.ToString();
                                aobj.Note = Convert.ToString(patient_list[pointer2].Allergy[0].Note);

                                if (Convert.ToInt32(patient_list[pointer2].Allergy[0].PatientAllergyId.ToString()) != 0)
                                {
                                    allergyModelList.Add(aobj);
                                    Console.WriteLine("add only when patientallergyid is not zero");
                                }

                            }
                            else
                            {
                                pointer1 = pointer2;
                                break;
                            }

                            pobj.Allergy = allergyModelList.ToList();

                            if (pointer2 == (patient_list.Count))
                            {
                                break;
                            }
                        }
                        PatientList.Add(pobj);
                        }
                }
            }
            catch (Exception e)
            {
                //ObjectExtentions.NotifySystemAdminForError(exError: e, subject: "IMPORTANT - Application BE Database Error", strSQLCommand: command);
                throw new CustomDataException(e, query);
                
            }
            return PatientList;
