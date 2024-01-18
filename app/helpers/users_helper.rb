module UsersHelper
  def custom_error_message(error)
    case error.attribute.to_sym
    when :password
      'O campo de senha não pode ser vazio'
    else
      error.full_message
    end
  end
end
