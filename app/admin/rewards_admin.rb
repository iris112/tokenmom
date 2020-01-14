Trestle.resource(:rewards, model: RewardManager ) do
  collection do
    # Set the default order when manual sorting is not applied
    RewardManager.order(created_at: :desc)
  end

  menu do
    item :rewards, icon: "fa fa-star"
  end

  # Customize the table columns shown on the index view.
  table do
    column :wallet_address, link: true do |reward|
      link_to reward.wallet_address, 'https://etherscan.io/address/' + reward.wallet_address, :target => 'blank'
    end
    column :txHash, link: true do |reward|
      if reward.txHash
        link_to reward.txHash, 'https://etherscan.io/tx/' + reward.txHash, :target => 'blank'
      else
        '_'
      end
    end
    column :amount
    column :approved, -> (reward) {!reward.status ? '' : reward.approved ? 'Approved' : 'Denied' }
    column :created_at, sort: { default: true, default_order: :desc }
    actions do |toolbar|
      if !toolbar.instance.status
        toolbar.link 'Approve', admin.path(:approve_user, id: toolbar.instance.id), method: :post, class: 'btn btn-success'
        toolbar.link 'Deny', admin.path(:deny_user, id: toolbar.instance.id), method: :post, class: 'btn btn-danger'
      end
    end
  end

  # Customize the form fields shown on the new/edit views.
  #
  form do |reward|
  end

  # By default, all parameters passed to the update and create actions will be
  # permitted. If you do not have full trust in your users, you should explicitly
  # define the list of permitted parameters.
  #
  # For further information, see the Rails documentation on Strong Parameters:
  #   http://guides.rubyonrails.org/action_controller_overview.html#strong-parametersntroller_overview.html#strong-parameters
  #
  # params do |params|
  #   params.require(:reward).permit(:name, ...)
  # end

  controller do
    def approve_user
      self.instance = admin.find_instance(params)

      require 'net/http'
      require 'json'
      begin
          uri = URI('http://localhost:3001/order/allow_reward')
          http = Net::HTTP.new(uri.host, uri.port)
          req = Net::HTTP::Post.new(uri.path, {'Content-Type' =>'application/json'})
          req.body = self.instance.to_json
          res = http.request(req)
          result = JSON.parse res.body

          if result['state'] == 'ok'
            flash[:message] = "Referal TM Request has completed"
            self.instance.update_attribute(:approved, true)
            self.instance.update_attribute(:status, 1)
            self.instance.update_attribute(:txHash, result['tx'])
          else
            flash[:message] = "Referal TM Request has failed"
          end

      rescue => e
          flash[:message] = "Referal TM Request has failed"
          puts "failed #{e}"
      end
      redirect_to admin.path(:index)
    end

    def deny_user
      self.instance = admin.find_instance(params)
      self.instance.update_attribute(:approved, false)
      self.instance.update_attribute(:status, 1)
      redirect_to admin.path(:index)
    end

    def show
      redirect_to admin.path(:index)
    end

    def new
      redirect_to admin.path(:index)
    end
  end

  routes do
    # Routes are declared as if they are within the resources routing block
    post :approve_user, on: :member
    post :deny_user, on: :member
  end
end
