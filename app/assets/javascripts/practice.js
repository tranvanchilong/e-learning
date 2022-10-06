$(document).ready(function () {
  $(document).on('submit', '#form_practice', function (e) {
    e.preventDefault();
    $('.btn-submit').attr('disabled', true);
    const answers = $(this)
      .serializeArray()
      .map((answer) => {
        return {
          question: parseInt(answer.name),
          answer: parseInt(answer.value),
        };
      });
    const lesson_id = $('#form_practice').data('lesson');

    $.ajax({
      type: 'GET',
      url: '/get-correct-answer',
      dataType: 'json',
      data: { lesson_id: lesson_id },
      success: function (result) {
        let score = checkCorrectAnswer(answers, result);
        postPractice(score, lesson_id);
      },
    });
  });
});

function checkCorrectAnswer(answers, correct) {
  let score = 0;
  correct.forEach((c) => {
    answers.forEach((u) => {
      if (c.question === u.question) {
        let userCheck = $(`input#answer-${u.answer}`);
        if (c.correct_answer === u.answer) {
          userCheck.addClass('is-correct');
          score++;
        } else {
          let correctCheck = $(`input#answer-${c.correct_answer}`);
          userCheck.addClass('is-uncorrect');
          correctCheck.addClass('is-correct');
        }
      }
    });
  });
  return score;
}

function postPractice(score, lesson_id) {
  $.ajax({
    type: 'POST',
    url: '/practice',
    data: { score: score, lesson_id: lesson_id },
  });
  $('#form_practice').before(`<div class='alert alert-success'>
    <h4 class="alert-heading">Well done!</h4>
    <p>Your score is ${score * 10}</p>
    <div class="d-flex">
      <a class="btn btn-primary" href="/learning?lesson_id=${
        lesson_id + 1
      }">Next lesson</a>
    </div>
  </div>`);
}
