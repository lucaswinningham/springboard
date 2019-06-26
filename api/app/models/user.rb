class User < ApplicationRecord
  include UserConcerns::UserValidations
  include UserConcerns::UserCallbacks
  include UserConcerns::UserActivatable
end
