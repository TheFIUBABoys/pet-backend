json.array!(@pet_questions) do |pet_question|
  json.id pet_question.id
  json.body pet_question.body
  json.created_at pet_question.created_at
  json.user   { json.extract! current_user, :id, :full_name }
  json.answer { json.extract! pet_question.answer, :id, :body, :created_at } if pet_question.answer.present?
end
