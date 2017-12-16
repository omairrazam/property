class Transaction < ApplicationRecord
  before_create :figure_out_target_date
  #seller and buyer must not be same validation
  belongs_to :plot_file
  belongs_to :buyer, :class_name => 'User', :foreign_key => 'buyer_id'
  belongs_to :seller, :class_name => 'User', :foreign_key => 'seller_id'

  enum nature: %i(buying selling)
  enum mode: %i(cash monday_payment next_monday_payment bop sop pod custom)

  validates_presence_of :target_date_in_days, if: Proc.new { |c| %i(sop bop).include?(c.mode.to_sym) }
  validates_presence_of :total_amount, :recieved_amount, :nature
  validates :total_amount, numericality: { greater_than: 0 } 
  validates :recieved_amount, numericality: { greater_than_or_equal_to: 0 }
  validates :nature, inclusion: { in: Transaction.natures }

  before_validation :amount_calculation

  delegate :category, :to => :plot_file, :prefix => true

  scope :daily_all, ->{where('DATE(created_at)=?',Time.zone.now.beginning_of_day)}
  scope :with_mode, ->(mode){where(mode: mode)}
  scope :with_nature, ->(nature){where(nature: nature)}
  scope :daily_sellings, ->{daily_all.with_nature(:selling).sum(&:total_amount)}
  scope :daily_buyings, ->{daily_all.with_nature(:buying).sum(&:total_amount)}

  def pending?
    (total_amount > recieved_amount)
  end

  def paid?
    (total_amount == recieved_amount)
  end

  private
  def figure_out_target_date
  	self.target_date = case mode.to_sym
  	when :monday_payment
      Date.today.next_week(:monday)
  	when :next_monday_payment
      Date.today.next_week(:monday).next_week(:monday)
  	when :bop,:sop
      raise ArgumentError.new("mode is (sop,bop) but target_date_in_days is missing, can't calculate target_date of transaction") if target_date_in_days.blank?
      target_date_in_days.days.from_now
  	when :pod
      raise ArgumentError.new("mode is pod but Category's pod amount is missing, can't calculate target_date of transaction") unless pod_days = plot_file_category.pod_days
      pod_days.days.from_now
    when :custom
  	   #ignore for now.
  	else
      # :cash mode will also fall here
      # set target_date to nil, will be by default nil
  	end
  end
  
  def remaining_amount
    total_amount - recieved_amount 
  end

  def amount_calculation
    if total_amount < recieved_amount 
      errors.add(:base, "Total should be greater than recieved amount")
    end
  end
end