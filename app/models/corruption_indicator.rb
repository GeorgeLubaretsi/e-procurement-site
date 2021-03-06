class CorruptionIndicator < ActiveRecord::Base
  has_many :tender_corruption_flags, :dependent => :destroy
 
  attr_accessible :id,
      :weight,
      :description,
      :name
end
