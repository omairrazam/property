class Transaction < ApplicationRecord
  mount_uploader :excel_file, ExcelImportUploader
  attr_accessor :is_new, :paid

  has_paper_trail
  before_save :look_for_piece_change
  before_save :figure_out_target_date
  before_save :divide_recieved_amount
  after_create :init
  #care of  and trader must not be same validation
  belongs_to :plot_file, optional: true
  belongs_to :care_of,  :class_name => 'Person', :foreign_key => 'care_of_id'
  belongs_to :trader, :class_name => 'Person', :foreign_key => 'trader_id'
  belongs_to :category
  belongs_to :region


  has_many :children, :class_name => 'Transaction', :foreign_key => 'father_id', dependent: :destroy

  enum nature: %i(buying selling)
  enum mode: %i(cash mp nmp tp wp thp fp bop sop pod)
  enum imported_from: %i(panel file)

  validates_presence_of :target_date_in_days, if: Proc.new { |c| %i(sop bop).include?(c.mode.try(:to_sym)) }
  #validates_presence_of :excel_file, if: Proc.new { |f| %i(file).include?(f.imported_from.try(:to_sym)) }
  validates_presence_of :total_amount, :recieved_amount,:nature,:category,:region, :duplicate_count, :transaction_date
  validates :total_amount, numericality: { greater_than: 0 }
  validates :duplicate_count, numericality: { greater_than: 0 }
  validates :recieved_amount, numericality: { greater_than_or_equal_to: 0 }
  validates :nature, inclusion: { in: Transaction.natures.keys }
  validates :mode, inclusion: { in: Transaction.modes.keys }

  before_validation :amount_calculation
  scope :by_category, ->(val,unit){where('category_id=?', Category.by_category(val,unit).last.id)}
  scope :daily_all, ->{where('DATE(transaction_date)=?',Time.zone.now.beginning_of_day)}
  scope :with_mode, ->(mode){where(mode: mode)}
  scope :with_nature, ->(nature){where(nature: nature)}
  scope :daily_sellings, ->{daily_all.with_nature(:selling).sum(&:total_amount)}
  scope :daily_buyings, ->{daily_all.with_nature(:buying).sum(&:total_amount)}
  scope :current_mp, ->{where('mode=? AND transaction_date BETWEEN ? AND ? ', Transaction.modes[:mp],Date.today.beginning_of_week, Date.today.next_week(:monday))}
  scope :current_nmp, ->{where('mode=? AND transaction_date BETWEEN ? AND ?', Transaction.modes[:nmp],Date.today.beginning_of_week, Date.today.next_week(:monday))}
  scope :only_parents, -> {where('father_id is NULL')}
  scope :in_range_alarm, -> (from,to){where('target_date BETWEEN ? AND ?',from, to)}
  scope :due, ->{where('total_amount!=recieved_amount')}

  def pending?
    (total_amount > recieved_amount)
  end

  def paid
    (total_amount == recieved_amount)
  end

  def remaining_amount
    dealer_total_amount - aggregate_recieved
  end
 def dealer_total_amount
    total_amount*duplicate_count
 end
  def self.create_in_bulk params
    ActiveRecord::Base.transaction do
      new_ones = []
      parent = Transaction.create!(params)
      new_ones << parent
      raise ArgumentError.new("Duplicate Count missing, cannot create child") if parent.duplicate_count.blank?
      (2..parent.duplicate_count).each do
        child = parent.create_child
        new_ones << child
      end
      new_ones
    end
  end

  def create_child
    child = self.dup
    child.father_id = self.id
    child.save!
    child
  end


  def self.report
     buyings  = all.with_nature('buying')
     sellings = all.with_nature('selling')
     buyings_total = buyings.inject(0){|tot,a| tot+a.total_amount}
     sellings_total = sellings.inject(0){|tot,a| tot+a.total_amount}
     {buyings: buyings_total,b_count:buyings.count,s_count:selling.count, sellings: sellings_total}
  end

  private
  def figure_out_target_date
  	self.target_date = case mode.try(:to_sym)
  	when :mp
      self.transaction_date.next_week(:monday)
  	when :nmp
      self.transaction_date.next_week(:monday).next_week(:monday)
    when :tp
      self.transaction_date.next_week(:tuesday)
    when :wp
      self.transaction_date.next_week(:wednesday)
    when :thp
      self.transaction_date.next_week(:thursday)
    when :fp
      self.transaction_date.next_week(:friday)
  	when :bop,:sop
      raise ArgumentError.new("mode is (sop,bop) but target_date_in_days is missing, can't calculate target_date of transaction") if target_date_in_days.blank?
      self.transaction_date+self.target_date_in_days.day
  	when :pod
      pod_days = category.pod_days
      raise ArgumentError.new("mode is pod but Category's pod amount is missing, can't calculate target_date of transaction") if pod_days.blank? || pod_days == 0
      self.transaction_date+pod_days.day
    when :custom
  	   #ignore for now.
  	else
      # :cash mode will also fall here
      # set target_date to nil, will be by default nil
  	end
  end

  def look_for_piece_change
    return if self.new_record?
    if duplicate_count_changed?
      diff = duplicate_count - duplicate_count_was
      if diff > 0
        diff.abs.times do
          self.create_child
        end

      elsif diff < 0
        diff.abs.times do
          self.children.last.destroy
        end
      end
    end
  end

  def divide_recieved_amount
    return if self.father_id.present?
    per_piece = self.aggregate_recieved/self.duplicate_count
    return if per_piece == recieved_amount
    self.recieved_amount = per_piece
    self.children.update(recieved_amount: per_piece)
  end

  def amount_calculation
    if total_amount.to_i * duplicate_count < recieved_amount.to_i
      errors.add(:base, "Recieved amount cannot be greater than agreed amount i.e pieces * per_piece_amount")
    end
  end

  def init
    self.is_new = true
  end
end
