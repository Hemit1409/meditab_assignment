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

// function getFormValue(){
//       var originalvalue = document.getElementById("getValues").value;
//       console.log("The value in the text box is =" + originalvalue);
//     }

function ageCount() {
  var date1 = new Date();
  var dob = document.getElementById("dob").value;
  var contact = document.getElementById("contact").value;
  var sex = document.getElementById("sex").value;
  var date2 = new Date(dob);
  //var pattern = /^\d{1,2}\/\d{1,2}\/\d{4}$/; //Regex to validate date format (dd/mm/yyyy)
  //if (pattern.test(dob)) {
  var y1 = date1.getFullYear(); //getting current year
  var y2 = date2.getFullYear(); //getting dob year
  var age = y1 - y2; //calculating age
  console.log("Age : " + age);
  console.log(contact);
  console.log("sex: " + sex);
  if (age < 18 && contact == "") {
    if (sex == "Male") {
      alert("Please add a contact for the Patient as he, is a minor");
    } else if (sex == "Female") {
      alert("Please add a contact for the Patient as she, is a minor");
    } else {
      alert("Please add a contact for the Patient as he/she, is a minor");
    }
  } else {
    console.log("thankyou");
  }
}
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
