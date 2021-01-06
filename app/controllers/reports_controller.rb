require 'csv'
class ReportsController < ApplicationController
  # we need to prevent the default behavior because we do the authentication ourselves
  skip_before_action :verify_authenticity_token

  # call the method from below to authenticate the server
  before_action :authenticate_server

  def handle
    # we need to process the CSV file
    # the report is stored in the body of the request and we can access it by params[:report]
    report = params[:report].open

    # headers are first row
    csv_options = { col_sep: ',', headers: :first_row }
    # parse the report with the csv options defined above and instead of row pass down the columns of each row
    CSV.parse(report, csv_options) do |timestamp, lock_id, kind, status|
      # if we print timestamp -> ["timestamp", "2017-05-13..."] we get this format --> access value with [1]
      timestamp = timestamp[1]
      lock_id = lock_id[1]
      kind = kind[1]
      status_change = status[1]
      # look if lock already exists - if it does change it's status if not create a new lock
      lock = Lock.find_by_id(lock_id)
      if lock
        lock.status = status_change
        lock.save
      else
        Lock.create(id: lock_id, status: status_change, kind: kind)
      end
      # create all entries
      Entry.create(timestamp: timestamp, status_change: status_change, lock: lock)
    end
    # show message in postman but rest happens on server - se creation of all entries
    render json: { message: "Congrats your report has been processed. Now you have #{Lock.count} locks and #{Entry.count} entries" }
  end

  def authenticate_server
    # find the server name and access token in the headers of the request
    code_name = request.headers["X-Server-CodeName"]
    access_token = request.headers["X-Server-Token"]
    # find the server with the codename that we got from the header
    server = Server.find_by(code_name: code_name)
    # need to check for both - do we find the server with this codename and is the access token right for found server
    unless server && server.access_token == access_token
      render json: { message: "Wrong credentials" }
    end
  end
end
