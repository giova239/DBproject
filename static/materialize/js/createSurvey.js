$(document).ready(function(){
    //ADDING QUESTIONS
    addSelectChangeListener(1);
    $('#addQuestion').click (function(){
    var i = 2 +$('#addQuestionHere').children().length;
        var n = parseInt($('input#questions_number').val());
        $('input#questions_number').val(n+1);
        var qForm = $('div#questionForm1').clone();
        qForm.find('input').val('');
        qForm.attr('id','questionForm'+i);
        qForm.find('h5.questionTitle').html('Question #'+i);
        qForm.find('a.questionCloseButton').attr('id','questionCloseButton'+i);
        qForm.find('a.questionCloseButton').on('click', function(){qForm.remove();var n = parseInt($('input#questions_number').val());$('input#questions_number').val(n-1);});
        qForm.find('input.questionText').attr('name', 'question_text_'+i);
        qForm.find('input.questionText').attr('id', 'icon_question_text_'+i);
        qForm.find('label.questionTextLabel').attr('for', 'icon_question_text_'+i);
        qForm.find('div.questionOptions').html("");
        qForm.find('div.questionOptions').attr('id','putOptions'+i+'Here');
        $.get("static/html/select.html").success(function(data) {
            data = data.replaceAll('question_type_2','question_type_'+i);
            qForm.find('div.questionTypeSelectWrapper').html(data);
        });
        $('#addQuestionHere').append(qForm);
        setTimeout(function(){qForm.find('select.questionType').formSelect();addSelectChangeListener(i);},350);
    });
});
//QUESTION TYPE CHANGER
function addSelectChangeListener(qNumber){
    $('select#question_type_'+qNumber).change(function(){
        var optNumber = 2;
        var qType = $(this).children("option:selected").val();
        var optDiv = $('div#putOptions'+qNumber+'Here');
        if( qType == 1 || qType == 2){
            //SETTING HTML
            $.get("static/html/options.html").success(function(data) {
                data = data.replace('addOptionHereForQuestion1','addOptionHereForQuestion'+qNumber);
                data = data.replace('addOptionToQuestion1','addOptionToQuestion'+qNumber);
                data = data.replace('removeOptionToQuestion1','removeOptionToQuestion'+qNumber);
                data = data.replaceAll('option_1_q1', 'option_1_q'+qNumber)
                data = data.replaceAll('options_number_q1', 'options_number_q'+qNumber)
                optDiv.html(data);
            });
            setTimeout(function(){
            //ADD OPTION BUTTON LISTENER
            optDiv.find('a#addOptionToQuestion'+qNumber).click (function(){
            var n = parseInt($('input#options_number_q'+qNumber).val());
            $('input#options_number_q'+qNumber).val(n+1);
            var optForm = $('div#option_1_q'+qNumber).clone();
            optForm.find('input').val('');
            optForm.attr('id', 'option_'+optNumber+'_q'+qNumber);
            optForm.find('input').attr('id', 'icon_option_'+optNumber+'_q'+qNumber);
            optForm.find('input').attr('name', 'option_'+optNumber+'_q'+qNumber);
            optForm.find('label').attr('for', 'icon_option_'+optNumber+'_q'+qNumber);
            optForm.find('label').html('Option '+optNumber);
            $('#addOptionHereForQuestion'+qNumber).append(optForm);
            $('input#input_text, textarea#textarea2').characterCounter();
            optNumber++;
            });
            //REMOVE OPTION BUTTON LISTENER
            optDiv.find('a#removeOptionToQuestion'+qNumber).click (function(){
                var n = parseInt($('input#options_number_q'+qNumber).val());
                $('input#options_number_q'+qNumber).val(n-1);
                if(optNumber>2){
                    $('div#option_'+(optNumber-1)+'_q'+qNumber).remove();
                    optNumber--;
                }
            });
            },350);
        }else if (qType == 6){
            $.get("static/html/liking.html").success(function(data) {
                data = data.replaceAll('_q1', '_q'+qNumber)
                optDiv.html(data);
            });
        }else{
            optDiv.html("");
        }
        $('input#input_text, textarea#textarea2').characterCounter();
    });
}