class Transaction < ApplicationRecord
  before_create :figure_out_target_date
  after_create :create_child_transactions
  #seller and buyer must not be same validation
  belongs_to :plot_file, optional: true
  belongs_to :buyer,  :class_name => 'User', :foreign_key => 'buyer_id'
  belongs_to :seller, :class_name => 'User', :foreign_key => 'seller_id'
  belongs_to :category
  belongs_to :region

  has_many :children, :class_name => 'Transaction', :foreign_key => 'father_id'

  enum nature: %i(buying selling)
  enum mode: %i(cash monday_payment next_monday_payment bop sop pod custom)

  validates_presence_of :target_date_in_days, if: Proc.new { |c| %i(sop bop).include?(c.mode.try(:to_sym)) }
  validates_presence_of :total_amount, :recieved_amount,:nature,:category,:region, :duplicate_count
  validates :total_amount, numericality: { greater_than: 0 }
  validates :duplicate_count, numericality: { greater_than: 0 } 
  validates :recieved_amount, numericality: { greater_than_or_equal_to: 0 }
  validates :nature, inclusion: { in: Transaction.natures.keys }
  validates :mode, inclusion: { in: Transaction.modes.keys }

  before_validation :amount_calculation

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

  def remaining_amount
    total_amount - recieved_amount 
  end

  def self.create_in_bulk params
    ActiveRecord::Base.transaction do
      new_ones = []
      parent = Transaction.create!(params)
      new_ones << parent
      raise ArgumentError.new("Duplicate Count missing, cannot create child") if parent.duplicate_count.blank?
      (2..parent.duplicate_count).each do 
        child = parent.dup
        child.father_id = parent.id
        child.save!
        new_ones << child
      end
      new_ones
    end
  end

  private
  def figure_out_target_date
  	self.target_date = case mode.try(:to_sym)
  	when :monday_payment
      Date.today.next_week(:monday)
  	when :next_monday_payment
      Date.today.next_week(:monday).next_week(:monday)
  	when :bop,:sop
      raise ArgumentError.new("mode is (sop,bop) but target_date_in_days is missing, can't calculate target_date of transaction") if target_date_in_days.blank?
      target_date_in_days.days.from_now
  	when :pod
      pod_days = category.pod_days
      raise ArgumentError.new("mode is pod but Category's pod amount is missing, can't calculate target_date of transaction") if pod_days.blank? || pod_days == 0
      pod_days.days.from_now
    when :custom
  	   #ignore for now.
  	else
      # :cash mode will also fall here
      # set target_date to nil, will be by default nil
  	end
  end

  def amount_calculation
    if total_amount.to_i < recieved_amount.to_i 
      errors.add(:base, "Total should be greater than recieved amount")
    end
  end

  def create_child_transactions
    return if father_id.present?
    (1..self.duplicate_count).each
  end
end