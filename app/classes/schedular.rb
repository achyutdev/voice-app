require 'rufus-scheduler'
require 'thread'

class Schedular
  attr_accessor :id, :time
  
  def initialize(id,time)
    @id     = id
    @time   = time
    change_into_valid_time_format
  end

  def start_it!
    threads=[]
    threads<<Thread.new{
      scheduler = Rufus::Scheduler.new
      scheduler.at @time do
        q=QueueHandler.new(@id)
        q.make_queue
        q.make_call
      end
    }
    threads.each { |thr| thr.join }
  end

  private
  def change_into_valid_time_format
    @time =@time.gsub('-','/')
  end
end
