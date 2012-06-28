$(function() {
  $("#pickUpDate1").datepicker();
  
  $('#addDate').click(function() {
      var num     = $('.clonedInput').length; // how many "duplicatable" input fields we currently have
      var newNum  = new Number(num + 1);      // the numeric ID of the new input field being added

      // business rule: you can only add 5 names
      if (newNum == 6) return false;
      
      // create the new element via clone(), and manipulate it's ID using newNum value
      var newElem = $('#dateElement' + num).clone().attr('id', 'dateElement' + newNum);
      
      // manipulate the name/id values of the input inside the new element
      newElem.children('input').attr('id', 'pickUpDate' + newNum).attr('name', 'post[Pick Up Date ' + newNum + ']').removeClass('hasDatepicker').val('');

      // insert the new element after the last "duplicatable" input field
      $('#dateElement' + num).after(newElem);
      $("#pickUpDate" + newNum).datepicker();
 
      return false;
  });

  $('#delDate').click(function() {
      var num = $('.clonedInput').length; // how many "duplicatable" input fields we currently have
      
      // if only one element remains, disable the "remove" button
      if (num-1 == 0) return false;
      
      $('#dateElement' + num).remove();     // remove the last element

      return false;
  });
  
  //form validation functions
  $("#CSA").validate({
      expression: "if(VAL != '') return true; else return false;",
      message: "Select your CSA/farm"
  });
  
  $("#FarmersMarket").validate({
      expression: "if(VAL != '') return true; else return false;",
      message: "Select your Farmer's Market"
  });
  
  $("#pickUpDate1").validate({
      expression: "if(VAL != '') return true; else return false;",
      message: "Enter at least one pick up date"
  });
  
  $("#Name").validate({
      expression: "if(VAL != '') return true; else return false;",
      message: "Enter your name"
  });
  
  $("#Email").validate({
      expression: "if (VAL.match(/^[^\\W][a-zA-Z0-9\\_\\-\\.]+([a-zA-Z0-9\\_\\-\\.]+)*\\@[a-zA-Z0-9_]+(\\.[a-zA-Z0-9_]+)*\\.[a-zA-Z]{2,4}$/)) return true; else return false;",
      message: "Enter a valid email"
  });
});