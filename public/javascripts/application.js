$(function() {
  $("#pickUpDate").datepicker();
  
  $('#addDate').click(function() {
      var num     = $('.clonedInput').length; // how many "duplicatable" input fields we currently have
      var newNum  = new Number(num + 1);      // the numeric ID of the new input field being added

      // create the new element via clone(), and manipulate it's ID using newNum value
      var newElem = $('#pickUpDate' + num).clone().attr('id', 'pickUpDate' + newNum);

      // manipulate the name/id values of the input inside the new element
      newElem.children(':first').attr('id', 'pickUpDate' + newNum).attr('pickUpDate', 'pickUpDate' + newNum);

      // insert the new element after the last "duplicatable" input field
      $('#pickUpDate' + num).after(newElem);

      // enable the "remove" button
      $('#delDate').attr('disabled','');

      // business rule: you can only add 5 names
      if (newNum == 5)
          $('#addDate').attr('disabled','disabled');
          
      return false;
  });

  $('#delDate').click(function() {
      var num = $('.clonedInput').length; // how many "duplicatable" input fields we currently have
      $('#pickUpDate' + num).remove();     // remove the last element

      // enable the "add" button
      $('#addDate').attr('disabled','');

      // if only one element remains, disable the "remove" button
      if (num-1 == 1)
          $('#delDate').attr('disabled','disabled');
          
      return false;
  });

  $('#delDate').attr('disabled','disabled');
});