class UserSerializer

  include JSONAPI::Serializer

  set_id :id
  attributes :id,
    :name,
    :username,
    :email

  attribute :created_at do |object|
    object.created_at.strftime('%Y/%m/%d').to_s
  end

  attribute :updated_at do |object|
    object.created_at.strftime('%Y/%m/%d').to_s
  end

end
