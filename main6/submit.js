const form = document.getElementById("detailsForm");
const dob = form.elements['dob']
const age = form.elements['age']

dob.addEventListener('change', (e) => {
    function getAge(date) {
        const dob = new Date(date);
        bYear = dob.getFullYear();
        now = new Date();
        cYear = now.getFullYear();
        dYear = cYear - bYear;
        return { dYear };
    }
    ageYear = getAge(dob.value);
    age.value = ageYear.dYear + " Y"
})

form.addEventListener('submit', (event) => {
    event.preventDefault()
    const formData = new FormData(form);
    cbs = document.querySelectorAll('input[type=checkbox]')
    cbs.forEach(cb => {
        formData.append(cb.name, cb.checked);
    });
    const entries = formData.entries();
    const data = Object.fromEntries(entries);

    const phoneNumber = form.elements['phoneNumber']
    const sex = form.elements['sex']

    if (ageYear.dYear < 18 && phoneNumber.value == "") {
        if (sex.value == "Male") {
            ageWiseText = "he"
        } else if (sex.value == "Female") {
            ageWiseText = "she"
        } else {
            ageWiseText = "he/she"
        }
        alert("Please add a contact for the patient as " + ageWiseText + " is minor")
    } else {
        // console.log(details);
        console.log(data);
    }


    // active = form.elements['active']['checked'];
    // prefix = form.elements['prefix']['value'];
    // fname = form.elements['fname']['value'];
    // mname = form.elements['mname']['value'];
    // lname = form.elements['lname']['value'];
    // lname2 = form.elements['lname2']['value'];
    // suffix = form.elements['suffix']['value'];
    // aka = form.elements['aka']['value'];
    // sex = form.elements['sex']['value'];
    // dob = form.elements['dob']['value'];
    // age = form.elements['age']['value'];
    // age = getAge(dob);
    // prefLang = form.elements['prefLang']['value'];
    // interpreter = form.elements['interpreter']['checked'];
    // appointmentStatus = form.elements['appointmentStatus']['value'];
    // risk = form.elements['risk']['value'];
    // maritalStatus = form.elements['maritalStatus']['value'];
    // ssn = form.elements['ssn']['value'];
    // race = form.elements['race']['value'];
    // ethnicity = form.elements['ethnicity']['value'];
    // selfPay = form.elements['selfPay']['checked'];
    // defaultFacility = form.elements['defaultFacility']['value'];
    // defaultProvider = form.elements['defaultProvider']['value'];
    // timezone = form.elements['timezone']['value'];
    // defaultPharmacy = form.elements['defaultPharmacy']['value'];
    // useCurrentPharmacy = form.elements['useCurrentPharmacy']['checked'];
    // samePCP = form.elements['samePCP']['checked'];
    // pcp = form.elements['pcp']['value'];
    // feeSchedule = form.elements['feeSchedule']['value'];
    // addressType = form.elements['addressType']['value'];
    // street = form.elements['street']['value'];
    // zip = form.elements['zip']['value'];
    // city = form.elements['city']['value'];
    // state = form.elements['state']['value'];
    // country = form.elements['country']['value'];
    // phonetype = form.elements['phonetype']['value'];
    // countrtycode = form.elements['countrtycode']['value'];
    // phoneNumber = form.elements['phoneNumber']['value'];
    // faxcode = form.elements['faxcode']['value'];
    // faxnumber = form.elements['faxnumber']['value'];
    // email = form.elements['email']['value'];
    // website = form.elements['website']['value'];

    // address = {
    //     addressType: addressType,
    //     street: street,
    //     zip: zip,
    //     city: city,
    //     state: state,
    //     country: country,
    //     phonetype: phonetype,
    //     countrtycode: countrtycode,
    //     phoneNumber: phoneNumber,
    //     faxcode: faxcode,
    //     faxnumber: faxnumber,
    //     email: email,
    //     website: website,
    // }

    // details = {
    //     active: active,
    //     prefix: prefix,
    //     fname: fname,
    //     mname: mname,
    //     lname: lname,
    //     lname2: lname2,
    //     suffix: suffix,
    //     aka: aka,
    //     dob: dob,
    //     sex: sex,
    //     timezone: timezone,
    //     age: age,
    //     prefLang: prefLang,
    //     interpreter: interpreter,
    //     appointmentStatus: appointmentStatus,
    //     risk: risk,
    //     maritalStatus: maritalStatus,
    //     ssn: ssn,
    //     race: race,
    //     ethnicity: ethnicity,
    //     selfPay: selfPay,
    //     defaultFacility: defaultFacility,
    //     defaultProvider: defaultProvider,
    //     timezone: timezone,
    //     defaultPharmacy: defaultPharmacy,
    //     useCurrentPharmacy: useCurrentPharmacy,
    //     samePCP: samePCP,
    //     pcp: pcp,
    //     feeSchedule: feeSchedule,
    //     addresses: [address],
    // }


    // }
})
