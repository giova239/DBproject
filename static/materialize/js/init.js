(function($){
  $(function(){
    $(document).ready(function(){
        $('.sidenav').sidenav();
        $('input#input_text, textarea#textarea2').characterCounter();
        $( ".datepicker" ).datepicker({
            format: 'yyyy-mm-dd',
            yearRange: [1900,2050],
            changeMonth: true,
            changeYear: true,
        });
        $('.timepicker').timepicker();
        $('select').formSelect();
    });
  }); // end of document ready
})(jQuery); // end of jQuery name space
