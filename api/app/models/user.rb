class User < ApplicationRecord
  include UserConcerns::UserValidations
  include UserConcerns::UserActivatable
  include UserConcerns::UserAuth
end
