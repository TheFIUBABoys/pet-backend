json.id @pet_question.id
json.body @pet_question.body
json.created_at @pet_question.created_at
json.user do
  json.extract! current_user, :id, :full_name
end
json.answer do
  json.extract! @pet_question.answer, :id, :body, :created_at
end
