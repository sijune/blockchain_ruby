require 'sinatra'
require './block'

chain = Blockchain.new
get '/' do
    message=""
    chain.all_block.each do |b|
        message << Digest::SHA256.hexdigest(b.to_s) + "<br>"
        message << b.to_s + "<hr>"
    end
    
end

get '/mining' do
    chain.mining.to_s
end

get '/make_wallet' do
    chain.make_wallet.to_s
end

get '/tx' do
    chain.tx(params[:from], params[:to], params[:amount]).to_s
end