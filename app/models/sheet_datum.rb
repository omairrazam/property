class SheetDatum < ApplicationRecord
  validates :sheet_name, uniqueness: true
end
