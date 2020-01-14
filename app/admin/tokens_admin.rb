Trestle.resource(:tokens, model: Token) do
  search do |query|
    if query
      Token.where("contract_address LIKE ?", "%#{query}%")
    else
      Token.all
    end
  end
  menu do
    item :tokens, icon: "fa fa-money"
  end

  # Customize the table columns shown on the index view.
  #
  table do
    column :name
    column :symbol, ->(token) { token.symbol }
    column :decimal, ->(token) { token.token_decimals }
    column :contract_address, ->(token) { token.contract_address }
    column :on_hold
    column :tm_field
    column :usdc_field
    column :wbtc_field
    column :weth_token
    column :last_price, ->(token) { token.last_price }
    column :updated_at, header: "Last Updated", align: :center
    actions
  end

  # Customize the form fields shown on the new/edit views.
  #
  form do |token|
    text_field :name
    text_field :symbol
    text_field :token_decimals
    text_field :contract_address
    text_field :tm_field
    text_field :usdc_field
    text_field :wbtc_field
    text_field :weth_token

    unless token.id.nil?
      toolbar(:secondary) do
        link_to token.on_hold ? "Release Token" : "Hold Token", admin.path(:hold_token, id: token.id), method: :post, class: token.on_hold ? "btn btn-success" :"btn btn-danger"
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
  #   params.require(:article).permit(:name, ...)
  # end

  controller do
    def hold_token
      self.instance = admin.find_instance(params)

      if self.instance.on_hold
        self.instance.update_attribute(:on_hold, false)
      else
        self.instance.update_attribute(:on_hold, true)
      end

      flash[:message] = "Token successfully #{self.instance.on_hold ? "hold" : "released"}."
      redirect_to admin.path(:show, id: instance)
    end
  end

  routes do
    # Routes are declared as if they are within the resources routing block
    post :hold_token, on: :member
  end
end
