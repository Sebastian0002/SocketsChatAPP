class GeneralValidators{

   static validateEmail(String email){
      String error = "";
      String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$'; 
      RegExp regExp = RegExp(pattern);
      
      if(!regExp.hasMatch(email) && email.isNotEmpty)return error = "Is not valid Email";
      return error;
  }
}