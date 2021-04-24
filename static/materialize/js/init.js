(function($){
  $(function(){
    $(document).ready(function(){
        $('.sidenav').sidenav();
        $('input#input_text, textarea#textarea2').characterCounter();
        $( '.datepicker' ).datepicker({
            format: 'yyyy-mm-dd',
            yearRange: [1900,2050],
            changeMonth: true,
            changeYear: true,
        });
        $('.timepicker').timepicker();
        $('select').formSelect();
        var i = 2;
        $('#addQuestion').click (function(){
            var qForm = $('#questionForm1').clone();
            qForm.attr('id','questionForm'+i);
            qForm.find('h6.questionTitle').html('Question #'+i);
            qForm.find('a.questionCloseButton').attr('id','questionCloseButton'+i);
            qForm.find('a.questionCloseButton').on('click', function(){qForm.remove();});
            qForm.find('input.questionText').attr('name', 'question_text_'+i);
            qForm.find('input.questionText').attr('id', 'icon_question_text_'+i);
            qForm.find('label.questionTextLabel').attr('for', 'icon_question_text_'+i);
            $.get("static/html/select.html").success(function(data) {
                qForm.find('div.questionTypeSelectWrapper').html(data)
            });
            qForm.find('select.questionType').attr('id','question_type_'+i);
            $('#addHere').append(qForm);
            i++;
            setTimeout(function(){qForm.find('select.questionType').formSelect();},10);
        });
    });
  }); // end of document ready
})(jQuery); // end of jQuery name space
