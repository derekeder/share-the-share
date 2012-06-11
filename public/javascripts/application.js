$(function() {
  $("#pickUpDates").datepicker();
  
  $('#addDate').click(function() {
      var num     = $('.clonedInput').length; // how many "duplicatable" input fields we currently have
      var newNum  = new Number(num + 1);      // the numeric ID of the new input field being added

      // business rule: you can only add 5 names
      if (newNum == 6) return false;
      
      // create the new element via clone(), and manipulate it's ID using newNum value
      var newElem = $('#dateElement' + num).clone().attr('id', 'dateElement' + newNum);

      // manipulate the name/id values of the input inside the new element
      //newElem.children(':first').attr('id', 'pickUpDate' + newNum).attr('pickUpDate', 'pickUpDate' + newNum);

      // insert the new element after the last "duplicatable" input field
      $('#dateElement' + num).after(newElem);
 
      return false;
  });

  $('#delDate').click(function() {
      var num = $('.clonedInput').length; // how many "duplicatable" input fields we currently have
      
      // if only one element remains, disable the "remove" button
      if (num-1 == 0) return false;
      
      $('#dateElement' + num).remove();     // remove the last element

      return false;
  });
});