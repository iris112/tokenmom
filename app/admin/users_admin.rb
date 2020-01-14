Trestle.resource(:users, model: User) do
  search do |query|
    if query
      User.where("wallet_address LIKE ?", "%#{query}%")
    else
      User.all
    end
  end

  menu do
    item :users, icon: "fa fa-users"
  end

  # Customize the table columns shown on the index view.
  #
  # table do
  #   column :name
  #   column :created_at, align: :center
  #   actions
  # end

  # Customize the form fields shown on the new/edit views.
  #
  form do |user|
    text_field :nick_name

    row do
      col(xs: 6) { datetime_field :updated_at }
      col(xs: 6) { datetime_field :created_at }
      col(xs: 6) { text_field :referral_id }
      col(xs: 6) { text_field :recommended_id }
    end

    unless user.id.nil?
      toolbar(:secondary) do
        link_to user.banned ? "Release User" : "Ban User", admin.path(:ban_user, id: user.id), method: :post, class: user.banned ? "btn btn-success" :"btn btn-danger"
      end
    end
  end

  # By default, all parameters passed to the update and create actions will be
  # permitted. If you do not have full trust in your users, you should explicitly
  # define the list of permitted parameters.
  #
  # For further information, see the Rails documentation on Strong Parameters:
  #   http://guides.rubyonrails.org/action_controller_overview.html#strong-parameters
  #
  # params do |params|
  #   params.require(:user).permit(:name, ...)
  # end

  controller do
    def ban_user
      self.instance = admin.find_instance(params)

      if self.instance.banned
        self.instance.update_attribute(:banned, false)
      else
        self.instance.update_attribute(:banned, true)
      end

      flash[:message] = "User successfully #{self.instance.banned ? "banned" : "released"}."
      redirect_to admin.path(:show, id: instance)
    end
  end

  routes do
    # Routes are declared as if they are within the resources routing block
    post :ban_user, on: :member
  end
end
