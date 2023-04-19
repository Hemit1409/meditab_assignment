function newFunction() {
  var element = document.getElementById("form_id");
  element.reset();
  console.log("form is reset");
}

function getFormValue() {
  const form = document.getElementById("form_id");

  for (var i = 0; i < form.length; i++) {
    // if (form.elements[i].value != 'Submit') {
    console.log(form.elements[i].value);
    // }
  }
}

function ageCount() {
    
  var userinput = document.getElementById("dob").value;
  var dob = new Date(userinput);
    
  
    if(userinput==null || userinput==''){
      document.getElementById("message").innerHTML = "**Choose a date please!";  
      return false; 
    }else {
    var dobYear = dob.getYear();
    var dobMonth = dob.getMonth();
    var dobDate = dob.getDate();

    var now = new Date();//current date
    var currentYear = now.getYear();
    var currentMonth = now.getMonth();
    var currentDate = now.getDate();
	
    //declare a variable to collect the age in year, month, and days
    var age = {};
    var ageString = "";
  
    //get years
    yearAge = currentYear - dobYear; //2022-2002 =20
	
    //get months : 12 < 13 
    if (currentMonth >= dobMonth)
      var monthAge = currentMonth - dobMonth; 
    else {
      yearAge--; //19
      var monthAge = 12 + currentMonth - dobMonth; //12+12-
    }

    //get days:12>10
    if (currentDate >= dobDate) 
      var dateAge = currentDate - dobDate; //2
    else {
      monthAge--;
      var dateAge = 31 + currentDate - dobDate;

      if (monthAge < 0) {
        monthAge = 11;
        yearAge--;
      }
    }
    //group the age in a single variable
    age = {
    years: yearAge,
    months: monthAge,
    days: dateAge
    };
    var agenum=yearAge;
      
    if ( (age.years > 0) && (age.months > 0) && (age.days > 0) )
       ageString = age.years + " Y, " + age.months + " M, " + age.days + " D";
    else if ( (age.years == 0) && (age.months == 0) && (age.days > 0) )
       ageString = age.days + " D";
    //when current month and date is same as birth date and month
    else if ( (age.years > 0) && (age.months == 0) && (age.days == 0) )
       ageString = age.years +  " Y";
    else if ( (age.years > 0) && (age.months > 0) && (age.days == 0) )
       ageString = age.years + " Y " + age.months + " M";
    else if ( (age.years == 0) && (age.months > 0) && (age.days > 0) )
       ageString = age.months + " M " + age.days + " D";
    else if ( (age.years > 0) && (age.months == 0) && (age.days > 0) )
       ageString = age.years + " Y " + age.days + " D";
    else if ( (age.years == 0) && (age.months > 0) && (age.days == 0) )
       ageString = age.months + " M";
    //when current date is same as dob(date of birth)
    else ageString = "Welcome to Earth! <br> It's first day on Earth!"; 
    // console.log();
    if(age.years < 18 ){
      document.getElementById("result").innerHTML = ageString; 
      console.log("Minors!!"+ ageString)
      
      alert("Please add Contact Detail for Patient as he/she is a minor!")
    }
    document.getElementById("result").innerHTML = ageString; 
             
  }
}

// function getFormValue(){
//       var originalvalue = document.getElementById("getValues").value;
//       console.log("The value in the text box is =" + originalvalue);
//     }


//return true;
// } else {
//   alert("Invalid date format. Please Input in (dd/mm/yyyy) format!");
//   return false;
// }

const form = document.getElementById("form_id");

form.addEventListener("submit", (e) => {
  e.preventDefault();
  const fd = new FormData(form);
  const entries = fd.entries();
  const data = Object.fromEntries(entries);
  console.log(data);
});