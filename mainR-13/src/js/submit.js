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

function openSidebar() {
    document.querySelector(".sidebar").style.width = "10%";
    document.querySelector(".detailpart").style.width = "90%";
    document.querySelector(".detailpart").style.marginLeft = "12%";
    document.getElementById("closeSidebar").style.display = "";
    document.getElementById("openSidebar").style.display = "none";
}

function closeSidebar() {
    document.querySelector(".sidebar").style.width = "0.7%";
    document.querySelector(".detailpart").style.marginLeft = "2%";
    document.querySelector(".detailpart").style.width = "100%";
    document.getElementById("closeSidebar").style.display = "none";
    document.getElementById("openSidebar").style.display = "";
}

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

const form = document.getElementById("detailsForm");
const dob = form.elements['dob']
const age = form.elements['age']
const details_div = document.querySelector('.details')
const innernav = document.querySelector('.innernav')

details_div.addEventListener("scroll", (event) => {
    let scroll = details_div.scrollTop;
    if (scroll == 0) {
        innernav.style.boxShadow = "none";
    } else {
        innernav.style.boxShadow = "0px 4px 5px rgb(162 165 169 / 25%)";
    }
});

function isValidUrl(url) {
    const pattern = new RegExp(
        '^([a-zA-Z]+:\\/\\/)?' + // protocol
        '((([a-z\\d]([a-z\\d-]*[a-z\\d])*)\\.)+[a-z]{2,}|' + // domain name
        '((\\d{1,3}\\.){3}\\d{1,3}))' + // OR IP (v4) address
        '(\\:\\d+)?(\\/[-a-z\\d%_.~+]*)*' + // port and path
        '(\\?[;&a-z\\d%_.~+=-]*)?' + // query string
        '(\\#[-a-z\\d_]*)?$', // fragment locator
        'i'
    );
    if(pattern.test(url)){
        window.open(url, '_blank');
    }
}

dob.addEventListener('change', (e) => {
    function getAge(date) {
        const dob = new Date(date);
        now = new Date();
        cYear = now.getFullYear();
        // cMonth = now.getMonth();
        // cDay = now.getDate();
        bYear = dob.getFullYear();
        // bMonth = dob.getMonth();
        // bDay = dob.getDate();
        dYear = cYear - bYear;
        // dMonth = cMonth - bMonth;
        // dDay = cDay - bDay;
        // return { dYear, dMonth, dDay };
        return { dYear };
    }
    _age = getAge(dob.value);
    age.value = _age.dYear + " Y";
})

form.addEventListener('submit', (event) => {
    event.preventDefault()

    const phoneNumber = form.elements['phoneNumber']
    const sex = form.elements['sex']
    const requiredFields = document.getElementsByClassName('required-field');

    flag = true;

    for (i = 0; i < requiredFields.length; i++) {
        // console.log(requiredFields.item(i).value);
        if (requiredFields.item(i).value == "") {
            flag = false;
            requiredFields.item(i).nextElementSibling.style.display = "block";
        } else {
            requiredFields.item(i).nextElementSibling.style.display = "none";
        }
    }

    if (flag) {
        if (_age.dYear < 18 && phoneNumber.value == "") {
            if (sex.value == "Male") {
                ageWiseText = "he"
            } else if (sex.value == "Female") {
                ageWiseText = "she"
            } else {
                ageWiseText = "he/she"
            }
            alert("Please add a contact for the patient as " + ageWiseText + " is minor")
        } else {
            const formData = new FormData(form);
            cbs = document.querySelectorAll('input[type=checkbox]')
            cbs.forEach(cb => {
                formData.append(cb.name, cb.checked);
            });
            const entries = formData.entries();
            const details = Object.fromEntries(entries);

            console.log(details);
        }
    }
})