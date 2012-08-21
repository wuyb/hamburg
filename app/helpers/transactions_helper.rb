# encoding: utf-8
module TransactionsHelper

  def flot_transactions_by_date_title(start_date, end_date, by=nil)
    (start_date > Time.at(0) ? (l start_date) : "人类纪元开始") + "—" + (l end_date)
  end

  def transactions_json_flot_data(transactions, start_date, end_date)
    start_date = Time.now if start_date == Time.at(0)
    transactions.each do |t|
      start_date = t.created_at if t.created_at < start_date
    end

    days = (end_date - start_date) / (60 * 60 * 24)

    transactions_by_day = {:income=>{}, :expense=>{}}

    (0..days).each do |i|
      transactions_by_day[:income][end_date.ago(3600 * 24 * (days - i)).to_date.to_time(:utc).to_f * 1000] = {:count=>0, :total=>0}
      transactions_by_day[:expense][end_date.ago(3600 * 24 * (days - i)).to_date.to_time(:utc).to_f * 1000] = {:count=>0, :total=>0}
    end


    transactions.each do |t|
      time = t.created_at.to_date.to_time(:utc).to_f * 1000
      if t.transaction_type == 1
        day = transactions_by_day[:income][time].nil? ?  {count:0, total:0} : transactions_by_day[:income][time]
      elsif t.transaction_type == -1
        day = transactions_by_day[:expense][time].nil? ?  {count:0, total:0} : transactions_by_day[:expense][time]
      else
        next
      end
      day[:count] = day[:count] + 1
      day[:total] = day[:total] + t.amount

      if t.transaction_type == 1
        transactions_by_day[:income][time] = day
      elsif t.transaction_type == -1
        transactions_by_day[:expense][time] = day
      end

    end

    transactions_by_day
  end

end
