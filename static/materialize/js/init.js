(function($){
  $(function(){
    $(document).ready(function(){
        //INIZIATIZATION
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
        addSelectChangeListener();
        //ADDING QUESTIONS
        $('#addQuestion').click (function(){
        var i = 2 +$('#addHere').children().length;
            var n = parseInt($('input#questions_number').val());
            $('input#questions_number').val(n+1);
            var qForm = $('div#questionForm1').clone();
            qForm.find('input').val('');
            qForm.attr('id','questionForm'+i);
            qForm.find('h6.questionTitle').html('Question #'+i);
            qForm.find('a.questionCloseButton').attr('id','questionCloseButton'+i);
            qForm.find('a.questionCloseButton').on('click', function(){qForm.remove();var n = parseInt($('input#questions_number').val());$('input#questions_number').val(n-1);});
            qForm.find('input.questionText').attr('name', 'question_text_'+i);
            qForm.find('input.questionText').attr('id', 'icon_question_text_'+i);
            qForm.find('label.questionTextLabel').attr('for', 'icon_question_text_'+i);
            $.get("static/html/select.html").success(function(data) {
                data = data.replace('question_type_2','question_type_'+i);
                qForm.find('div.questionTypeSelectWrapper').html(data);
            });
            $('#addHere').append(qForm);
            setTimeout(function(){qForm.find('select.questionType').formSelect();addSelectChangeListener();},350);
        });
    });
    //QUESTION TYPE CHANGER
    function addSelectChangeListener(){
        $("select.questionType").change(function(){
            var qType = $(this).children("option:selected").val();
            if( qType == 1 || qType == 2){
                alert("multipla");
            }else if (qType == 6){
                alert("gradimento");
            }
        });
    }
  }); // end of document ready
})(jQuery); // end of jQuery name space