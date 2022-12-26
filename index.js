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
    
    if(age.years < 18 ){
      document.getElementById("result").innerHTML = ageString; 
      console.log("Minor!!")
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


const sidebar = document.querySelector('.sidebar');
const mainContent = document.querySelector('.content');
document.getElementById("sidebar-collapse").onclick = function () {
  sidebar.classList.toggle('sidebar_small');
  mainContent.classList.toggle('content_large');
}

const other = document.querySelector('.formdiv2');
// const otherContent = document.querySelector('.content');
document.getElementById("fax-collapse").onclick = function () {
  other.classList.toggle('formdiv2-small');
  // otherContent.classList.toggle('content_large');
}

function addAddressField() {
  // alert('hi');
  addressHTML = `<div class="address w-100">
                  <fieldset>
                    <legend>
                      <div>
                        <select name="addressType" id="">
                          <option value="Home">Home</option>
                          <option value="Work">Work</option>
                          <option value="Other">Other</option>
                        </select>
                      </div>
                    </legend>
                    <div>
                      <div class="flex">
                        <div style="width: 98%;">
                          Address
                        </div>
                        <div style="width: 2%;cursor: pointer;">
                          <i class="fa-solid fa-trash-can def-color"
                            onclick="removeAddressField(this)"></i>
                        </div>
                      </div>
                      <div>
                        Street
                        <div class="flex" style="margin-right: 50%;">
                          <input type="text" name="street">
                        </div>
                      </div>
                      <div class="flex" style="column-gap: 2%;">
                        <div style="width: 24%;">
                          Zip
                          <input type="text" name="zip" id="">
                        </div>
                        <div style="width: 24%;">
                          City
                          <input type="text" name="city" id="">
                        </div>
                        <div style="width: 24%;">
                          State
                          <input type="text" name="state" id="">
                        </div>
                        <div style="width: 24%;">
                          Country
                          <select name="country" id="">
                            <option value="IN">IN</option>
                            <option value="US">US</option>
                          </select>
                        </div>
                        <div style="width: 4%;">
                          <i class="fa-solid fa-trash-can def-color"></i>
                        </div>
                      </div>
                    </div>
                    <div>
                      <div>
                        <div>
                          Phone <i class="fa-solid fa-circle-plus def-color"></i>
                        </div>
                        <div class="flex" style="column-gap: 2%;">
                          <div style="width: 20%;">
                            Type
                          </div>
                          <div style="width: 20%;">
                            Code
                          </div>
                          <div style="width: 20%;">
                            Number
                          </div>
                          <div style="width: 20%;">
                            Ext.
                          </div>
                        </div>
                        <hr>
                        <div class="flex" style="column-gap: 2%;">
                          <div style="width: 20%;">
                            <select name="phonetype" id="">
                              <option value="Cell">Cell</option>
                              <option value="Landline">Landline</option>
                            </select>
                          </div>
                          <div style="width: 20%;">
                            <select name="countrtycode" id="">
                              <option value="+91">+91 India</option>
                              <option value="+1">+1 United States</option>
                            </select>
                          </div>
                          <div style="width: 20%;">
                            <input type="text" name="phoneNumber" placeholder="Number">
                          </div>
                          <div style="width: 20%;">
                          </div>
                        </div>
                      </div>
                      <div>
                        <div>
                          Fax <i class="fa-solid fa-circle-plus def-color"></i>
                        </div>
                        <div class="flex" style="column-gap: 2%;">
                          <div style="width: 20%;">
                            Code
                          </div>
                          <div style="width: 20%;">
                            Number
                          </div>
                        </div>
                        <hr>
                        <div class="flex" style="column-gap: 2%;">
                          <div style="width: 20%;">
                            <input type="text" placeholder="Code" name="faxcode">
                          </div>
                          <div style="width: 20%;">
                            <input type="text" placeholder="Number" name="faxnumber">
                          </div>
                          <div style="width: 2%;">
                            <i class="fa-solid fa-trash-can def-color"></i>
                          </div>
                        </div>
                      </div>
                      <div>
                        <div>
                          Email <i class="fa-solid fa-circle-plus def-color"></i>
                        </div>
                        <div class="flex" style="column-gap: 2%;">
                          <div style="width: 50%;">
                            <input type="email" name="email">
                          </div>
                          <div style="width: 2%;">
                            <i class="fa-solid fa-trash-can def-color"></i>
                          </div>
                        </div>
                      </div>
                      <div>
                        <div>
                          Website <i class="fa-solid fa-circle-plus def-color"></i>
                        </div>
                        <div class="flex" style="column-gap: 2%;">
                          <div style="width: 50%;">
                            <input type="text" name="website">
                          </div>
                          <div style="width: 2%;">
                            <i class="fa-solid fa-trash-can def-color"></i>
                          </div>
                        </div>
                      </div>
                    </div>
                  </fieldset>
                </div>

`
  document.getElementById("multiadress").innerHTML += addressHTML
}

function removeAddressField(btn) {
  btn.closest('.address').remove();
}

function addFaxField(){
  addressHTML = `<div class="flex" style="column-gap: 2%;">
  <div style="width: 20%;">
    Code
  </div>
  <div style="width: 20%;">
    Number
  </div>
</div>
<hr>
<div class="flex" style="column-gap: 2%;">
  <div style="width: 20%;">
    <input type="text" placeholder="Code" name="faxcode">
  </div>
  <div style="width: 20%;">
    <input type="text" placeholder="Number" name="faxnumber">
  </div>
  <div style="width: 2%;cursor: pointer;margin-left: 30px;">
    <i class="fa-solid fa-trash-can def-color" onclick="removeFaxField(this)"></i>
  </div>
</div>

`
  document.getElementById("multifax").innerHTML += addressHTML
}

function removeFaxField(btn) {
  btn.closest('.fax').remove();
}

function addPhoneField(){
  addressHTML = `<div class="flex" style="column-gap: 2%;">
  <div style="width: 20%;">
    Type
  </div>
  <div style="width: 20%;">
    Code
  </div>
  <div style="width: 20%;">
    Number
  </div>
  <div style="width: 20%;">
    Ext.
  </div>
</div>
<hr>
<div class="flex" style="column-gap: 2%;">
  <div style="width: 20%;">
    <select name="phonetype" id="">
      <option value="Cell">Cell</option>
      <option value="Landline">Landline</option>
    </select>
  </div>
  <div style="width: 20%;">
    <select name="countrtycode" id="">
      <option value="+91">+91 India</option>
      <option value="+1">+1 United States</option>
    </select>
  </div>
  <div style="width: 20%;">
    <input type="text" name="phoneNumber" placeholder="Number"
      value="1">
  </div>
  <div style="width: 20%;">
    <div style="width: 2%;cursor: pointer;margin-left: 30px;">
      <i class="fa-solid fa-trash-can def-color" onclick="removePhoneField(this)"></i>
    </div>
  </div>
`
  document.getElementById("multiphone").innerHTML += addressHTML
}

function removePhoneField(btn) {
  btn.closest('.phone').remove();
}

function addEmailField(){
  addressHTML = `<div class="flex" style="column-gap: 2%;">
  <div style="width: 50%;">
    <input type="email" name="email">
  </div>
  <div style="width: 2%;">
    <i class="fa-solid fa-trash-can def-color"></i>
  </div>
</div>
`
  document.getElementById("multiemail").innerHTML += addressHTML
}

function removeEmailField(btn) {
  btn.closest('.email').remove();
}

function addWebsiteField(){
  addressHTML = `<div class="flex" style="column-gap: 2%;">
  <div style="width: 50%;">
    <input type="text" name="website">
  </div>
  <div style="width: 2%;cursor: pointer;">
    <i class="fa-solid fa-trash-can def-color"onclick="removeWebsiteField(this)"></i>
  </div>
</div>
`
  document.getElementById("multiweb").innerHTML += addressHTML
}

function removeWebsiteField(btn) {
  btn.closest('.web').remove();
}



var coll = document.getElementsByClassName("formdiv2");
var i;
var faxbutton = document.getElementById("fax-button")

for (i = 0; i < coll.length; i++) {

  coll[i].addEventListener("click", function() {
    
    var content = this.nextElementSibling;
    if (content.style.display === "block") {
      content.style.display = "none";
      faxbutton.style.transform = "rotate(360deg)"
    } else {
      content.style.display = "block";
      faxbutton.style.transform = "rotate(90deg)";
    }
  });
}