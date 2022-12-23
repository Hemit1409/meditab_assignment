
function submit(){
    e.preventDefault();
    const myFormData = new FormData(e.target);
    const formDataObj = Object.fromEntries(myFormData.entries());
    console.log(formDataObj);
};




function reset(){
    document.getElementById("myForm1").reset();
    document.getElementById("myForm2").reset();
    document.getElementById("myForm3").reset();
    document.getElementById("myForm4").reset();
    document.getElementById("myForm5").reset();
}

function submit(){
    const form = document.getElementById('myForm1');
    const formData = new FormData(form);
    for (const [key, value] of formData) {
        console.log (`${key}: ${value}`);
      }
}

function fnCalculateAge(){
    var userDateinput = document.getElementById("dob").value;  
    var birthDate = new Date(userDateinput);
    var difference= Date.now() - birthDate.getTime(); 
    var  ageDate = new Date(difference); 
    var calculatedAge=   Math.abs(ageDate.getUTCFullYear() - 1970);
    if(calculatedAge<18){
        alert("Please add a contact for the Patient as he / she (depending on the gender), is a minor");
    }
}



const sidebar = document.querySelector('.sidebar');
const mainContent = document.querySelector('.container');
document.getElementById("sidebar-collapse").onclick = function () {
  sidebar.classList.toggle('sidebar_small');
  mainContent.classList.toggle('container_large')
}


