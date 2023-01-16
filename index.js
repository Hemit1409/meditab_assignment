const formE1 = document.queryelector(".form");

formE1.addEventListener('submit', event => {
    event.preventDefault();

    const FormData = new FormData(formE1);
    console.log(formData.get('username'));
})

fetch(`http://localhost:29713/api/Patient/1`)
    .then(res => console.log(res.json))
    .then(data => console.log(data))




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


    if (userinput == null || userinput == '') {
        document.getElementById("message").innerHTML = "**Choose a date please!";
        return false;
    } else {
        var dobYear = dob.getYear();
        var dobMonth = dob.getMonth();
        var dobDate = dob.getDate();

        var now = new Date(); //current date
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


        if ((age.years > 0) && (age.months > 0) && (age.days > 0))
            ageString = age.years + " Y, " + age.months + " M, " + age.days + " D";
        else if ((age.years == 0) && (age.months == 0) && (age.days > 0))
            ageString = age.days + " D";
        //when current month and date is same as birth date and month
        else if ((age.years > 0) && (age.months == 0) && (age.days == 0))
            ageString = age.years + " Y";
        else if ((age.years > 0) && (age.months > 0) && (age.days == 0))
            ageString = age.years + " Y " + age.months + " M";
        else if ((age.years == 0) && (age.months > 0) && (age.days > 0))
            ageString = age.months + " M " + age.days + " D";
        else if ((age.years > 0) && (age.months == 0) && (age.days > 0))
            ageString = age.years + " Y " + age.days + " D";
        else if ((age.years == 0) && (age.months > 0) && (age.days == 0))
            ageString = age.months + " M";
        //when current date is same as dob(date of birth)
        else ageString = "Welcome to Earth! <br> It's first day on Earth!";
        console.log("Age: " + ageString);
        if (age.years < 18) {
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

/*const other = document.querySelector('.formdiv2');
// const otherContent = document.querySelector('.content');
document.getElementById("fax-collapse").onclick = function () {
    other.classList.toggle('formdiv2-small');
    // otherContent.classList.toggle('content_large');
}*/

function openOtherDetails() {
    document.querySelector(".other-detail-content").style.display = "";
    document.getElementById("closeOtherDetails").style.display = "";
    document.getElementById("openOtherDetails").style.display = "none";
}

function closeOtherDetails() {
    document.querySelector(".other-detail-content").style.display = "none";
    document.getElementById("closeOtherDetails").style.display = "none";
    document.getElementById("openOtherDetails").style.display = "";
}

function openSidebar() {
    document.querySelector(".sidebar").style.width = "10%";

    document.getElementById("closeSidebar").style.display = "";
    document.getElementById("openSidebar").style.display = "none";
}

function closeSidebar() {
    document.querySelector(".sidebar").style.width = "0.7%";

    document.getElementById("closeSidebar").style.display = "none";
    document.getElementById("openSidebar").style.display = "";
}

function closeSideMenu() {
    const sidemenuclosebtn = document.getElementById('side-menu-close-btn').classList;
    const leftsidenav = document.getElementById('leftsidenav');
    if (sidemenuclosebtn.contains('fa-angle-left')) {
        sidemenuclosebtn.remove('fa-angle-left');
        sidemenuclosebtn.add('fa-angle-right');
        leftsidenav.style.width = "1%";
    } else {
        sidemenuclosebtn.remove('fa-angle-right');
        sidemenuclosebtn.add('fa-angle-left');
        leftsidenav.style.width = "16%";
    }

}

var coll = document.getElementsByClassName("formdiv2");
var i;
var faxbutton = document.getElementById("fax-button")

for (i = 0; i < coll.length; i++) {

    coll[i].addEventListener("click", function () {

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


// ************************************************


function addContactField() {
    // alert('hi');
    contactHTML = `<div class="single-contact w-100">
  <fieldset>
      <legend>
          <div class="contact-type-div">
              <select name="contact-type">
                  <option value="Home">Home</option>
                  <option value="Work">Work</option>
                  <option value="Other">Other</option>
              </select>
          </div>
      </legend>
      <div class="address">
          <div class="flex">
              <div class="text-bolder" style="width: 98%;">
                  Address <i
                      class="fa-solid fa-circle-plus addAddressFieldBtn"
                      onclick="addAddressField(this)"
                      style="display: none;"></i>
              </div>
              <div style="width: 2%;">
                  <i class="fa-solid fa-trash-can def-color"
                      onclick="removeContactField(this)"></i>
              </div>
          </div>
          <div class="address-section">
              <div class="single-address">
                  <div>
                      Street
                      <div class="flex" style="margin-right: 50%;">
                          <input type="text" name="street">
                      </div>
                  </div>
                  <div class="flex" style="column-gap: 2%;">
                      <div style="width: 24%;">
                          Zip
                          <input type="text" name="zip">
                      </div>
                      <div style="width: 24%;">
                          City
                          <input type="text" name="city">
                      </div>
                      <div style="width: 24%;">
                          State
                          <input type="text" name="state">
                      </div>
                      <div style="width: 24%;">
                          Country
                          <select name="country">
                              <option value="IN">IN</option>
                              <option value="US">US</option>
                          </select>
                      </div>
                      <div style="width: 4%;">
                          <i class="fa-solid fa-trash-can def-color"
                              onclick="removeAddressField(this)"></i>
                      </div>
                  </div>
              </div>

          </div>
      </div>
      <div>
          <div class="phone-main-section">
              <div class="text-bolder">
                  Phone <i class="fa-solid fa-circle-plus def-color"
                      onclick="addPhoneField(this)"></i>
              </div>
              <div class="phone-section">
                  <div class="phone-label-section flex"
                      style="column-gap: 2%; margin-bottom: 0.5rem; border-bottom: solid 1px rgba(212,215,220,.5098039215686274);">
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
                  <div class="phone-input-section flex"
                      style="column-gap: 2%;">
                      <div style="width: 20%;">
                          <select name="phonetype">
                              <option value="Cell">Cell</option>
                              <option value="Landline">Landline</option>
                          </select>
                      </div>
                      <div style="width: 20%;">
                          <select name="countrtycode">
                              <option value="+91">+91 India</option>
                              <option value="+1">+1 United States</option>
                          </select>
                      </div>
                      <div style="width: 20%;">
                          <input type="text" name="phoneNumber"
                              placeholder="Number" value="">
                      </div>
                      <div style="width: 20%;">
                          <input type="text" name="phoneNumber"
                              placeholder="Ext." value=""
                              style="display: none;">
                      </div>
                      <i class="fa-solid fa-trash-can def-color"
                          onclick="removePhoneField(this)"></i>
                  </div>
              </div>
          </div>

          <div class="fax-main-section">
              <div class="text-bolder">
                  Fax <i class="fa-solid fa-circle-plus def-color"
                      onclick="addFaxField(this)"></i>
              </div>
              <div class="fax-section">
                  <div class="fax-label-section flex"
                      style="column-gap: 2%; margin-bottom: 0.5rem; border-bottom: solid 1px rgba(212,215,220,.5098039215686274);">
                      <div style="width: 20%;">
                          Code
                      </div>
                      <div style="width: 20%;">
                          Number
                      </div>
                  </div>
                  <div class="fax-input-section flex" style="column-gap: 2%;">
                      <div style="width: 20%;">
                          <input type="text" placeholder="Code"
                              name="faxcode">
                      </div>
                      <div style="width: 20%;">
                          <input type="text" placeholder="Number"
                              name="faxnumber">
                      </div>
                      <div style="width: 2%;">
                          <i class="fa-solid fa-trash-can def-color"
                          onclick="removeFaxField(this)"></i>
                      </div>
                  </div>
              </div>
          </div>

          <div class="email-section">
              <div class="text-bolder">
                  Email <i class="fa-solid fa-circle-plus def-color"
                      onclick="addEmailField(this)"></i>
              </div>
              <div class="multi-email">
                  <div class="single-email flex" style="column-gap: 2%;">
                      <div style="width: 50%;">
                          <input type="email" name="email">
                      </div>
                      <div style="width: 2%;">
                          <i class="fa-solid fa-trash-can def-color"
                              onclick="removeEmailField(this)"></i>
                      </div>
                  </div>
              </div>
          </div>
          <div class="website-section">
              <div class="text-bolder">
                  Website <i class="fa-solid fa-circle-plus def-color"
                      onclick="addWebsiteField(this)"></i>
              </div>
              <div class="multi-website">

                  <div class="single-website flex"
                      style="column-gap: 2%;">
                      <div style="width: 50%;">
                          <input type="text" name="website">
                      </div>
                      <div style="width: 2%;">
                          <i class="fa-solid fa-trash-can def-color"
                              onclick="removeWebsiteField(this)"></i>
                      </div>
                  </div>
              </div>
          </div>
      </div>
  </fieldset>
</div>`
    document.querySelector(".multi-contact").innerHTML += contactHTML
}

function addAddressField(btn) {
    addressHTML = `<div class="single-address">
  <div>
      Street
      <div class="flex" style="margin-right: 50%;">
          <input type="text" name="street">
      </div>
  </div>
  <div class="flex" style="column-gap: 2%;">
      <div style="width: 24%;">
          Zip
          <input type="text" name="zip">
      </div>
      <div style="width: 24%;">
          City
          <input type="text" name="city">
      </div>
      <div style="width: 24%;">
          State
          <input type="text" name="state">
      </div>
      <div style="width: 24%;">
          Country
          <select name="country">
              <option value="IN">IN</option>
              <option value="US">US</option>
          </select>
      </div>
      <div style="width: 4%;">
          <i class="fa-solid fa-trash-can def-color"
              onclick="removeAddressField(this)"></i>
      </div>
  </div>
</div>`
    btn.closest('.address').querySelector('.address-section').innerHTML += addressHTML;
    btn.style.display = "none";
}

function removeAddressField(btn) {
    btn.closest('.address').querySelector('.addAddressFieldBtn').style.display = "";
    btn.closest('.single-address').remove();
}

function removeContactField(btn) {
    btn.closest('.single-contact').remove();
}

function addPhoneField(btn) {
    phoneInputSectionHTML = `<div class="phone-input-section flex"
  style="column-gap: 2%;">
  <div style="width: 20%;">
      <select name="phonetype">
          <option value="Cell">Cell</option>
          <option value="Landline">Landline</option>
      </select>
  </div>
  <div style="width: 20%;">
      <select name="countrtycode">
          <option value="+91">+91 India</option>
          <option value="+1">+1 United States</option>
      </select>
  </div>
  <div style="width: 20%;">
      <input type="text" name="phoneNumber"
          placeholder="Number" value="">
  </div>
  <div style="width: 20%;">
      <input type="text" name="phoneNumber"
          placeholder="Ext." value=""
          style="display: none;">
  </div>
  <i class="fa-solid fa-trash-can def-color"
      onclick="removePhoneField(this)"></i>
</div>`;

    phoneLabelSectionHTML = `<div class="phone-label-section flex" style="column-gap: 2%; margin-bottom: 0.5rem; border-bottom: solid 1px rgba(212,215,220,.5098039215686274);">
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
</div>`

    if (btn.closest('.phone-main-section').querySelector('.phone-section').childElementCount == 0) {
        btn.closest('.phone-main-section').querySelector('.phone-section').innerHTML += phoneLabelSectionHTML;
    }
    btn.closest('.phone-main-section').querySelector('.phone-section').innerHTML += phoneInputSectionHTML;
}

function removePhoneField(btn) {
    if (btn.closest('.phone-section').childElementCount == 2) {
        btn.closest('.phone-section').querySelector('.phone-label-section').remove();
    }
    btn.closest('.phone-input-section').remove();
}

function addFaxField(btn) {
    faxInputSectionHTML = `<div class="fax-input-section flex" style="column-gap: 2%;">
  <div style="width: 20%;">
      <input type="text" placeholder="Code"
          name="faxcode">
  </div>
  <div style="width: 20%;">
      <input type="text" placeholder="Number"
          name="faxnumber">
  </div>
  <div style="width: 2%;">
      <i class="fa-solid fa-trash-can def-color"
      onclick="removeFaxField(this)"></i>
  </div>`;

    faxLabelSectionHTML = `<div class="fax-label-section flex"
  style="column-gap: 2%; margin-bottom: 0.5rem; border-bottom: solid 1px rgba(212,215,220,.5098039215686274);">
  <div style="width: 20%;">
      Code
  </div>
  <div style="width: 20%;">
      Number
  </div>
</div>`

    if (btn.closest('.fax-main-section').querySelector('.fax-section').childElementCount == 0) {
        btn.closest('.fax-main-section').querySelector('.fax-section').innerHTML += faxLabelSectionHTML;
    }
    btn.closest('.fax-main-section').querySelector('.fax-section').innerHTML += faxInputSectionHTML;
}

function removeFaxField(btn) {
    if (btn.closest('.fax-section').childElementCount == 2) {
        btn.closest('.fax-section').querySelector('.fax-label-section').remove();
    }
    btn.closest('.fax-input-section').remove();
}

function addEmailField(add) {
    emailHTML = `<div class="single-email flex" name="single-email"
  style="column-gap: 2%;">
  <div style="width: 50%;">
      <input type="email" name="email">
  </div>
  <div style="width: 2%;">
      <i class="fa-solid fa-trash-can def-color"
          onclick="removeEmailField(this)"></i>
  </div>
</div>`
    add.closest('.email-section').querySelector('.multi-email').innerHTML += emailHTML;
}

function removeEmailField(btn) {
    btn.closest('.single-email').remove();
}

function addWebsiteField(add) {
    websiteHTML = `<div class="single-website flex" style="column-gap: 2%;">
  <div style="width: 50%;">
      <input type="text" name="website">
  </div>
  <div style="width: 2%;">
      <i class="fa-solid fa-trash-can def-color" onclick="removeWebsiteField(this)"></i>
  </div>
</div>`
    add.closest('.website-section').querySelector('.multi-website').innerHTML += websiteHTML;
}

function removeWebsiteField(btn) {
    btn.closest('.single-website').remove();
}