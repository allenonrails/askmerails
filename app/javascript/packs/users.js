// open form question on click btn

function toggleFormQuestion(){
  document.querySelector('.btn-question').addEventListener('click', () => {
    document.querySelector('.question-form').classList.toggle('question-form-show')
  })
}

toggleFormQuestion()