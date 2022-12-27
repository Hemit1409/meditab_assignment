function resetFunction() {
    document.getElementById("mainform").reset();
}



const form = document.getElementById("mainform");

form.addEventListener('submit', (e) => {
    e.preventDefault();
    const fd = new FormData(form);
    const entries = fd.entries();
    const data = Object.fromEntries(entries);
    console.log(data)
    
})



function checkAge(){
    var inputDate = document.getElementById("dob").value;
    var dob = new Date(inputDate)
    var dobYear = dob.getFullYear()
    
    var today = new Date();
    var year = today.getFullYear()
    
    var age = year - dobYear;
    
    if(age < 18){
        alert("The Patient is minor please enter parent's contact number.")
    }
}


const sidebar = document.querySelector('.sidebar');
const mainform = document.querySelector('.mainform');

document.querySelector('.toggle').onclick = function()
{
    sidebar.classList.toggle('sidebar-small');
    mainform.classList.toggle('mainform-large');
}



var coll = document.getElementsByClassName("other-details-header");
var i;
var chevron = document.getElementById("chevron")

for (i = 0; i < coll.length; i++) {

  coll[i].addEventListener("click", function() {
    
    var content = this.nextElementSibling;
    if (content.style.display === "block") {
      content.style.display = "none";
      chevron.style.transform = "rotate(360deg)"
    } else {
      content.style.display = "block";
      chevron.style.transform = "rotate(90deg)";
    }
  });
}



// function for adding and deleting contact field
const contactFormHTML = `<div class="address1">
<fieldset>
    <legend>
        <select name="" id="address-option">
            <option value="">Home</option>
            <option value="">Work</option>
        </select>
    </legend>
    <div class="address-field">
        <div class="address-field-header">
            <h3>Address<i class="fa-solid fa-circle-plus" style="display:none;" onclick="addAddressField(this)"></i></h3><i class="fa-solid fa-trash-can" onclick="removeContactField(this)"></i>
        </div>
        <div class="address-field-container">
           <div class="address-street">
                <label for="street">Street</label>
                <input type="text" name="street" id="street">
           </div>
           <div class="address-rest">
                <div>
                    <label for="zip">Zip</label>
                    <input type="text" name="zip" id="zip">
                </div>
                <div>
                    <label for="city">City</label>
                    <input type="text" name="city" id="city">
                </div>
                <div id="state">
                    <label for="state">State</label>
                    <select name="state" id="state">
                        <option value="Washington">Washington</option>
                        <option value="Illoniss">Illoniss</option>
                    </select>
                </div>
                <div >
                    <label for="Country">Country</label>
                    <select name="country" id="country">
                        <option value="US">US</option>
                        <option value="India">India</option>
                    </select>
                </div>
                <div>
                    <label for=""><i class="fa-solid fa-trash-can" onclick="removeAddressField(this)"></i></label>
                </div>
           </div>
        </div>  
    </div>
    <div class="phone">
        <h3>Phone</h3>
        <i class="fa-solid fa-circle-plus" onclick="addPhone(this)"></i>
        <div class="phone-wrapper">
            <div class="phone-header-wrapper">
                <div class="phone-header">
                    <p class="type">Type</p>
                    <p class="code">Code</p>
                    <p class="number">Number</p>
                </div>
                <hr>
            </div>
        
        
            <div class="phone-inputs-wrapper" id="phone-inputs-wrapper">
                <div id="phone-inputs" class="phone-inputs"> 
                    <select name="type" id="type" class="type-input">
                        <option value="Cell">Cell</option>
                        <option value="Landline">Landline</option>
                    </select>
                    <select name="code" id="code" class="code-input">
                        <option value="+1">+1</option>
                        <option value="+91">+91</option>
                    </select>
                    <input type="text" name="number" id="number" class="number-input">
                    <i class="fa-solid fa-trash-can" style="margin-left: 20px; margin-top: 7px;" onclick="removePhoneField(this)"></i>
                </div>
                
            </div>
        </div>
    </div>
    <div class="fax">
        <h3>Fax</h3><i class="fa-solid fa-circle-plus" onclick="addFax(this)"></i>
        <div class="fax-wrapper">

        </div>
    </div>
    <div class="email">
        <h3>Email</h3><i class="fa-solid fa-circle-plus" onclick="addEmail(this)"></i>
        <div class="email-input-wrapper" >
           
        </div>
    </div>
    <div class="website">
        <h3>Website</h3><i class="fa-solid fa-circle-plus" onclick="addWebsite(this)"></i>
        <div class="website-input-wrapper" >
           
        </div>
    </div>
</fieldset>
</div>`
//addition function
function addContactField (){

  document.getElementById("address-container").innerHTML += contactFormHTML;
}
//deletion function
function removeContactField(deleteButton){
  deleteButton.closest('.address1').remove();
}



//function for adding and deleting phone number in contact detail form

const phoneLabel = `<div class="phone-header-wrapper">
<div class="phone-header">
    <p class="type">Type</p>
    <p class="code">Code</p>
    <p class="number">Number</p>
</div>
<hr>
</div>`

const phoneInput = `<div class="phone-inputs-wrapper" id="phone-inputs-wrapper">
<div id="phone-inputs" class="phone-inputs"> 
    <select name="type" id="type" class="type-input">
        <option value="Cell">Cell</option>
        <option value="Landline">Landline</option>
    </select>
    <select name="code" id="code" class="code-input">
        <option value="+1">+1</option>
        <option value="+91">+91</option>
    </select>
    <input type="text" name="number" id="number" class="number-input">
    <i class="fa-solid fa-trash-can" style="margin-left: 20px; margin-top: 7px;" onclick="removePhoneField(this)"></i>
</div>

</div>`

function addPhone(button){

        if(button.closest('.phone').querySelector('.phone-wrapper').childElementCount == 0)
            {
                button.closest('.phone').querySelector('.phone-wrapper').innerHTML += phoneLabel;
            }
            
            button.closest('.phone').querySelector('.phone-wrapper').innerHTML += phoneInput;
    }
 
function removePhoneField(deleteButton){
        if(deleteButton.closest('.phone-wrapper').childElementCount == 2)
            {
                    deleteButton.closest('.phone').querySelector('.phone-header-wrapper').remove();
            }
        deleteButton.closest('.phone-inputs-wrapper').remove();
    
  }



  //function for adding and removing fax field

  const faxLabel =`<div class="fax-header-wrapper">
  <div class="fax-header">   
      <p class="code">Code</p>
      <p class="number">Number</p>
  </div>
  <hr>
</div>`

const faxInput=`<div class="fax-inputs-wrapper" id="fax-inputs-wrapper">
<div id="fax-inputs" class="fax-inputs"> 
    <select name="code" id="code" class="code-input">
        <option value="+1">+1</option>
        <option value="+91">+91</option>
    </select>
    <input type="text" name="number" id="number" class="number-input">
    <i class="fa-solid fa-trash-can" style="margin-left: 20px; margin-top: 7px;" onclick="removeFax(this)"></i>
</div>

</div>`

function addFax(button){
    if(button.closest('.fax').querySelector('.fax-wrapper').childElementCount == 0)
    {
        button.closest('.fax').querySelector('.fax-wrapper').innerHTML += faxLabel;
    }
    button.closest('.fax').querySelector('.fax-wrapper').innerHTML += faxInput;
}

function removeFax(deleteButton){
    if(deleteButton.closest('.fax').querySelector('.fax-wrapper').childElementCount == 2)
    {
        deleteButton.closest('.fax').querySelector('.fax-header-wrapper').remove();
    }
    deleteButton.closest('.fax').querySelector('.fax-inputs-wrapper').remove();
}


//function to add and remove email

const emailInput = `<div class="email-input">
<input type="text"> 
<i class="fa-solid fa-trash-can" style="margin-left: 20px; margin-top: 7px;" onclick="removeEmail(this)"></i>
</div>`

function addEmail(button){
    button.closest('.email').querySelector(".email-input-wrapper").innerHTML += emailInput;
}

function removeEmail(deleteButton){
    deleteButton.closest('.email-input').remove();
}


//function to add and delete website

websiteInput = `<div class="website-input">
<input type="text"> 
<i class="fa-solid fa-trash-can" style="margin-left: 20px; margin-top: 7px;" onclick="removeWebsite(this)"></i>
</div>`

function addWebsite(button)
{
    button.closest('.website').querySelector('.website-input-wrapper').innerHTML += websiteInput;

}

function removeWebsite(deleteButton)
{
    deleteButton.closest('.website-input').remove();
}

//function to add and remove address field

const addressField = `<div class="address-field-container">
<div class="address-street">
     <label for="street">Street</label>
     <input type="text" name="street" id="street">
</div>
<div class="address-rest">
     <div>
         <label for="zip">Zip</label>
         <input type="text" name="zip" id="zip">
     </div>
     <div>
         <label for="city">City</label>
         <input type="text" name="city" id="city">
     </div>
     <div id="state">
         <label for="state">State</label>
         <select name="state" id="state">
             <option value="Washington">Washington</option>
             <option value="Illoniss">Illoniss</option>
         </select>
     </div>
     <div >
         <label for="Country">Country</label>
         <select name="country" id="country">
             <option value="US">US</option>
             <option value="India">India</option>
         </select>
     </div>
     <div>
         <label for=""><i class="fa-solid fa-trash-can"></i></label>
     </div>
</div>`

function addAddressField(button)
{
    button.closest('.address-field').querySelector('.address-field-container').style.display = "block";
    button.closest('.address-field').querySelector('.fa-circle-plus').style.display = "none";

}

function removeAddressField(button)
{
    button.closest('.address-field').querySelector('.address-field-container').style.display = "none";
    button.closest('.address-field').querySelector('.fa-circle-plus').style.display = "inline-block";

}