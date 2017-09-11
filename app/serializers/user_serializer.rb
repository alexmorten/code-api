class UserSerializer < ActiveModel::Serializer
  attributes :id, :firstname, :lastname, :fullname, :status

  def fullname
    object.firstname+" "+object.lastname
  end

end
