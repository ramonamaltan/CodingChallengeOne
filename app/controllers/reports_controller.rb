require 'csv'
class ReportsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_server
  def handle
    # we need to process the CSV file
    report = params[:report].open

    csv_options = { col_sep: ',', headers: :first_row }

    CSV.parse(report, csv_options) do |timestamp, lock_id, kind, status|
      timestamp = timestamp[1]
      lock_id = lock_id[1]
      kind = kind[1]
      status_change = status[1]
      lock = Lock.find_by_id(lock_id)
      if lock
        lock.status = status_change
        lock.save
      else
        Lock.create(id: lock_id, status: status_change, kind: kind)
      end

      Entry.create(timestamp: timestamp, status_change: status_change, lock_id: lock)
    end
    render json: { message: "Congrats your report has been processed. Now you have #{Lock.count} locks and #{Entry.count} entries" }
  end

  def authenticate_server
    # we need to find the server instance with the given code name
    code_name = request.headers["X-Server-CodeName"]
    access_token = request.headers["X-Server-Token"]
    server = Server.find_by(code_name: code_name)
    unless server && server.access_token == access_token
      render json: { message: "Wrong credentials" }
    end
  end
end
