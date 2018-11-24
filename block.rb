class Blockchain
    def initialize
        @chain=[]
        @wallet={}
        @tx=[]
    end
    
    def mining
        begin
            nonce = rand(10000000)
            hashed=Digest::SHA256.hexdigest(nonce.to_s)
        end while hashed[0..3] !="0000"
        
        normal_txs = []
        @tx.each do |t|
            from = t["sender"]
            to=t["recv"]
            amount=t["total_amount"]
            if @wallet[from].to_i>=amount.to_i
                @wallet[from] = @wallet[from].to_i - amount.to_i
                @wallet[to] = @wallet[to].to_i + amount.to_i
                normal_txs << t
            end
        end
        
        last_block=@chain[-1]
        block={
            "index"=>@chain.size+1,
            "nonce"=>nonce,
            "time"=>Time.now.to_s,
            "previous_block"=>Digest::SHA256.hexdigest(last_block.to_s),
            "tx" =>normal_txs
        }
        @chain << block #chain연결
        @tx =[] #다시 초기화
        @chain
    end
    
    def make_wallet
        @wallet[SecureRandom.uuid.gusb("-","")]=1000 #아이디값은 고유해야함 
        @wallet
    end
    
    def all_block
        @chain
    end
    
    def tx(from, to, amount)
        if @wallet[from].nil?
            "보내는 사람이 존재하지 않습니다."
        elsif @wallet[to].nil?      
            "받는 사람이 존재하지 않습니다."
        elsif @wallet[from].to_i < amount.to_i
            "금액이 부족합니다."
        else
            tx={"sender"=>from, "recv"=>to, "total_amount"=>amount}
            @tx << tx
        end
    end
end