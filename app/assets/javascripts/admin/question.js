$(document).ready(function () {
  $(document).on('click', '.btn-add-answer', function (e) {
    var question_id = $(this).data('question-id');
    $.ajax({
      method: 'get',
      url: '/admin/answers/new',
      data: { question_id: question_id },
    });
  });
  $(document).on('click', '.btn-edit-answer', function (e) {
    var answer_id = $(this).data('answer-id');
    $.ajax({
      method: 'get',
      url: '/admin/answers/' + answer_id + '/edit',
      data: { id: answer_id },
    });
  });
  $(document).on('click', '.btn-edit-question', function (e) {
    var question_id = $(this).data('question-id');
    $.ajax({
      method: 'get',
      url: '/admin/questions/' + question_id + '/edit',
      data: { id: question_id },
    });
  });
});
