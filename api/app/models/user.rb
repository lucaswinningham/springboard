class User < ApplicationRecord
  include UserConcerns::UserIdentifiable
  include UserConcerns::UserConfirmable
  include UserConcerns::UserActivatable
  include UserConcerns::UserAuth
  include UserConcerns::UserPassword
end
