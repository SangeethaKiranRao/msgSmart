// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function get_doctors(){
	
}


function check_speciality(){
	var s = $('speciality_name').value;
	if (s == "")
	{
		alert("Speciality Name should not be blank!");
		return false;
	}
}

function check_hospital(){
	
	var h = $('hospital_name').value;
	if (h == "Hospital Name, Area, City")
	{
		alert("Hospital Name should not be blank!");
		return false;
	}
}

function check_medical(){
	var a = $('medical_group_name').value;
	if (a == "")
	{
		alert("Medical Group Name should not be blank!");
		return false;
	}
}


function display_profile(id){
	
	if(id == "personal_prof")
	{
	  $('personal_prof').style.display = "block";
	  $('clas_personal_profile').className = "doc_pro1_blkboldtext";
	  $('professional_prof').style.display = "none";
	  $('clas_professional_profile').className = "doc_pro1_redboldtext";	
	}
   if( id == "professional_prof")
   {
   	 $('professional_prof').style.display = "block";
	 $('clas_professional_profile').className = "doc_pro1_blkboldtext";
	 $('personal_prof').style.display = "none";
	 $('clas_personal_profile').className = "doc_pro1_redboldtext";
   }	
	
}

function msg_details(id)
{
	if ( $(id).style.display == "none")
	{
		$(id).style.display = 'block';
	}
	else
	{
		$(id).style.display = 'none';
	}
}

function clearText(field){
    if (field.defaultValue == field.value) field.value = '';
    else if (field.value == '') field.value = field.defaultValue;
}

function check_basic_profile()
{
	if(document.getElementById('doctor_name').value=="")
    {
     alert("Name should not be blank")
     return false;
    }
	if(document.getElementById('doctor_email').value=="")
    {
      alert("Email should not be blank")
      return false;
    }
  
  if(document.getElementById('doctor_email').value!="")
    {
         var reg=/^[a-z|A-Z|0-9|\_|.]+\@[a-z|A-Z|0-9]+\.[a-z|\.|\a-z]+$/;
         var re1=document.getElementById('doctor_email').value
         if(!(reg.test(re1)))
           {
             alert("Email is not valid")
             return false;
           }
    }
}

function check_professional_profile()
{
	if(document.getElementById('doctor_professional_profile_first_name').value=="")
    {
     alert("First Name should not be blank")
     return false;
    }
	
	
	
	if(document.getElementById('doctor_professional_profile_last_name').value=="")
    {
     alert("Last Name should not be blank")
     return false;
    }
	
	if(document.getElementById('doctor_professional_profile_office_address').value=="")
    {
     alert("Office Address should not be blank")
     return false;
    }
	
//    if(document.getElementById('doctor_professional_profile_assistant_name').value=="")
//    {
//     alert("Assistant Name should not be blank")
//     return false;
//    }
	
	if(document.getElementById('doctor_professional_profile_state').value=="")
    {
     alert("State should not be blank")
     return false;
    }
	
	if(document.getElementById('doctor_professional_profile_degree').value=="")
    {
     alert("Please select Degree")
     return false;
    }
}


function check_mail()
{
	if(document.getElementById('mail_subject').value=="")
    {
     alert("Subject should not be blank")
     return false;
    }
	
	if(document.getElementById('mail_body').value=="")
    {
     alert("Body should not be blank")
     return false;
    }
	
}

function check_msg()
{
  if (document.getElementById('message_class_1').checked != true && document.getElementById('message_class_2').checked != true && document.getElementById('message_class_3').checked != true && document.getElementById('message_class_4').checked != true)
  {
  	alert('Please select Message to delete');
	return false;
  }
}

function sent_msg()
{
  if (document.getElementById('sent_class_1').checked != true && document.getElementById('sent_class_2').checked != true && document.getElementById('sent_class_3').checked != true && document.getElementById('sent_class_4').checked != true)
  {
  	alert('Please select Message to delete');
	return false;
  }
}

function TabChange(id)
{
	if(id == "prof")
	{
		document.getElementById("prof").className="tabberactive";
		document.getElementById("cont").className="";
		document.getElementById("insur").className="";
		document.getElementById("perso").className="";
	}
	else if(id == "cont")
	{
		document.getElementById("prof").className="";
		document.getElementById("cont").className="tabberactive";
		document.getElementById("insur").className="";
		document.getElementById("perso").className="";
	}
	else if(id == "insur")
	{
	   document.getElementById("prof").className="";
		document.getElementById("cont").className="";
		document.getElementById("insur").className="tabberactive";
		document.getElementById("perso").className="";	
	}
	else if(id == "perso")
	{
		document.getElementById("prof").className="";
		document.getElementById("cont").className="";
		document.getElementById("insur").className="";
		document.getElementById("perso").className="tabberactive";	
		
	}
}
