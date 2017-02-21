class StatusTracker < ApplicationRecord
  belongs_to :compare
  
  def self.add(level,message)
      st=StatusTracker.new
      st.date =Time.now.to_formatted_s(:db)
#      st.compare=compare
      st.message=message
      st.level=level
      st.thread = Process.pid
      st.save
        return st
  end
end
