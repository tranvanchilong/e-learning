module UserWordHelper
  def check_user_word(word)
    'active-done' if current_user.user_words.find_by(word_id: word.id)
  end

  def check_done_word(word)
    return if current_user.user_words.find_by(word_id: word.id)

    button_tag 'Done', class: 'btn btn-success btn-done',
                       data: { word_id: word.id, user_id: current_user.id }
  end
end
