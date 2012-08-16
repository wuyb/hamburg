module TransactionsHelper

  def transactions_json_flot_data(transactions, days)
    start_date = Time.now
    if days == 0
      if transactions.length > 0
        transactions.each do |t|
          start_date = t.created_at if t.created_at < start_date
        end
        days = (Time.now - start_date).to_f / (60 * 60 * 24)
      else
        days = 7
      end
    end

    transactions_by_day = {:income=>{}, :expense=>{}}

    (0..days).each do |i|
      transactions_by_day[:income][Time.now.ago(3600 * 24 * (days - i)).to_date.to_time(:utc).to_f * 1000] = {:count=>0, :total=>0}
      transactions_by_day[:expense][Time.now.ago(3600 * 24 * (days - i)).to_date.to_time(:utc).to_f * 1000] = {:count=>0, :total=>0}
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
