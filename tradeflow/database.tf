resource "aws_instance" "tradeflow_database_instance" {

    ami                    = var.ami_id
    instance_type          = var.instance_type
    subnet_id              = aws_subnet.database_subnet_a.id
    vpc_security_group_ids = [aws_security_group.database_sg.id]
    key_name               = var.key_name

    depends_on = [
        aws_nat_gateway.tradeflow_nat_gateway
    ]

    user_data = <<-EOF
                #!/bin/bash

                apt update -y

                apt install -y docker.io

                systemctl start docker
                systemctl enable docker

                docker run -d \
                    --name mongodb \
                    --restart unless-stopped \
                    -p 27017:27017 \
                    mongo

                sleep 20

                docker exec -i mongodb mongosh <<MONGOEOF

                use tradeflow

                db.stocks.insertMany([
                {
                    symbol: "AAPL",
                    name: "Apple Inc.",
                    price: 192.45,
                    marketCap: 2950000000000,
                    sector: "Technology",
                    updatedAt: new Date()
                },
                {
                    symbol: "MSFT",
                    name: "Microsoft Corporation",
                    price: 428.12,
                    marketCap: 3200000000000,
                    sector: "Technology",
                    updatedAt: new Date()
                },
                {
                    symbol: "GOOGL",
                    name: "Alphabet Inc.",
                    price: 175.66,
                    marketCap: 2200000000000,
                    sector: "Technology",
                    updatedAt: new Date()
                },
                {
                    symbol: "AMZN",
                    name: "Amazon.com Inc.",
                    price: 183.91,
                    marketCap: 1950000000000,
                    sector: "E-Commerce",
                    updatedAt: new Date()
                },
                {
                    symbol: "TSLA",
                    name: "Tesla Inc.",
                    price: 248.73,
                    marketCap: 820000000000,
                    sector: "Automotive",
                    updatedAt: new Date()
                },
                {
                    symbol: "NVDA",
                    name: "NVIDIA Corporation",
                    price: 1062.11,
                    marketCap: 2600000000000,
                    sector: "Semiconductors",
                    updatedAt: new Date()
                },
                {
                    symbol: "META",
                    name: "Meta Platforms Inc.",
                    price: 512.88,
                    marketCap: 1300000000000,
                    sector: "Social Media",
                    updatedAt: new Date()
                },
                {
                    symbol: "NFLX",
                    name: "Netflix Inc.",
                    price: 642.35,
                    marketCap: 280000000000,
                    sector: "Entertainment",
                    updatedAt: new Date()
                },
                {
                    symbol: "JPM",
                    name: "JPMorgan Chase & Co.",
                    price: 214.67,
                    marketCap: 620000000000,
                    sector: "Banking",
                    updatedAt: new Date()
                },
                {
                    symbol: "WMT",
                    name: "Walmart Inc.",
                    price: 72.41,
                    marketCap: 580000000000,
                    sector: "Retail",
                    updatedAt: new Date()
                },
                {
                    symbol: "DIS",
                    name: "The Walt Disney Company",
                    price: 118.92,
                    marketCap: 215000000000,
                    sector: "Entertainment",
                    updatedAt: new Date()
                },
                {
                    symbol: "AMD",
                    name: "Advanced Micro Devices Inc.",
                    price: 172.55,
                    marketCap: 285000000000,
                    sector: "Semiconductors",
                    updatedAt: new Date()
                }
                ])

                const stocks = {
                AAPL: db.stocks.findOne({ symbol: "AAPL" }),
                MSFT: db.stocks.findOne({ symbol: "MSFT" }),
                GOOGL: db.stocks.findOne({ symbol: "GOOGL" }),
                AMZN: db.stocks.findOne({ symbol: "AMZN" }),
                TSLA: db.stocks.findOne({ symbol: "TSLA" }),
                NVDA: db.stocks.findOne({ symbol: "NVDA" }),
                META: db.stocks.findOne({ symbol: "META" }),
                NFLX: db.stocks.findOne({ symbol: "NFLX" }),
                JPM: db.stocks.findOne({ symbol: "JPM" }),
                WMT: db.stocks.findOne({ symbol: "WMT" }),
                DIS: db.stocks.findOne({ symbol: "DIS" }),
                AMD: db.stocks.findOne({ symbol: "AMD" })
                };

                db.pricehistories.insertMany([

                // AAPL
                { stockId: stocks.AAPL._id, price: 180.12, timestamp: new Date("2026-05-15T10:00:00Z") },
                { stockId: stocks.AAPL._id, price: 181.45, timestamp: new Date("2026-05-16T10:00:00Z") },
                { stockId: stocks.AAPL._id, price: 182.77, timestamp: new Date("2026-05-17T10:00:00Z") },
                { stockId: stocks.AAPL._id, price: 184.21, timestamp: new Date("2026-05-18T10:00:00Z") },
                { stockId: stocks.AAPL._id, price: 185.98, timestamp: new Date("2026-05-19T10:00:00Z") },
                { stockId: stocks.AAPL._id, price: 187.10, timestamp: new Date("2026-05-20T10:00:00Z") },
                { stockId: stocks.AAPL._id, price: 188.43, timestamp: new Date("2026-05-21T10:00:00Z") },
                { stockId: stocks.AAPL._id, price: 189.85, timestamp: new Date("2026-05-22T10:00:00Z") },
                { stockId: stocks.AAPL._id, price: 190.91, timestamp: new Date("2026-05-23T10:00:00Z") },
                { stockId: stocks.AAPL._id, price: 192.45, timestamp: new Date("2026-05-24T10:00:00Z") },

                // MSFT
                { stockId: stocks.MSFT._id, price: 410.11, timestamp: new Date("2026-05-15T10:00:00Z") },
                { stockId: stocks.MSFT._id, price: 412.54, timestamp: new Date("2026-05-16T10:00:00Z") },
                { stockId: stocks.MSFT._id, price: 415.02, timestamp: new Date("2026-05-17T10:00:00Z") },
                { stockId: stocks.MSFT._id, price: 417.33, timestamp: new Date("2026-05-18T10:00:00Z") },
                { stockId: stocks.MSFT._id, price: 419.10, timestamp: new Date("2026-05-19T10:00:00Z") },
                { stockId: stocks.MSFT._id, price: 421.76, timestamp: new Date("2026-05-20T10:00:00Z") },
                { stockId: stocks.MSFT._id, price: 423.89, timestamp: new Date("2026-05-21T10:00:00Z") },
                { stockId: stocks.MSFT._id, price: 425.41, timestamp: new Date("2026-05-22T10:00:00Z") },
                { stockId: stocks.MSFT._id, price: 426.92, timestamp: new Date("2026-05-23T10:00:00Z") },
                { stockId: stocks.MSFT._id, price: 428.12, timestamp: new Date("2026-05-24T10:00:00Z") },

                // GOOGL
                { stockId: stocks.GOOGL._id, price: 160.42, timestamp: new Date("2026-05-15T10:00:00Z") },
                { stockId: stocks.GOOGL._id, price: 162.15, timestamp: new Date("2026-05-16T10:00:00Z") },
                { stockId: stocks.GOOGL._id, price: 164.88, timestamp: new Date("2026-05-17T10:00:00Z") },
                { stockId: stocks.GOOGL._id, price: 166.32, timestamp: new Date("2026-05-18T10:00:00Z") },
                { stockId: stocks.GOOGL._id, price: 167.77, timestamp: new Date("2026-05-19T10:00:00Z") },
                { stockId: stocks.GOOGL._id, price: 169.44, timestamp: new Date("2026-05-20T10:00:00Z") },
                { stockId: stocks.GOOGL._id, price: 170.88, timestamp: new Date("2026-05-21T10:00:00Z") },
                { stockId: stocks.GOOGL._id, price: 172.10, timestamp: new Date("2026-05-22T10:00:00Z") },
                { stockId: stocks.GOOGL._id, price: 173.91, timestamp: new Date("2026-05-23T10:00:00Z") },
                { stockId: stocks.GOOGL._id, price: 175.66, timestamp: new Date("2026-05-24T10:00:00Z") },

                // AMZN
                { stockId: stocks.AMZN._id, price: 170.11, timestamp: new Date("2026-05-15T10:00:00Z") },
                { stockId: stocks.AMZN._id, price: 171.90, timestamp: new Date("2026-05-16T10:00:00Z") },
                { stockId: stocks.AMZN._id, price: 173.52, timestamp: new Date("2026-05-17T10:00:00Z") },
                { stockId: stocks.AMZN._id, price: 175.21, timestamp: new Date("2026-05-18T10:00:00Z") },
                { stockId: stocks.AMZN._id, price: 176.87, timestamp: new Date("2026-05-19T10:00:00Z") },
                { stockId: stocks.AMZN._id, price: 178.54, timestamp: new Date("2026-05-20T10:00:00Z") },
                { stockId: stocks.AMZN._id, price: 179.91, timestamp: new Date("2026-05-21T10:00:00Z") },
                { stockId: stocks.AMZN._id, price: 181.44, timestamp: new Date("2026-05-22T10:00:00Z") },
                { stockId: stocks.AMZN._id, price: 182.88, timestamp: new Date("2026-05-23T10:00:00Z") },
                { stockId: stocks.AMZN._id, price: 183.91, timestamp: new Date("2026-05-24T10:00:00Z") },

                // TSLA
                { stockId: stocks.TSLA._id, price: 220.15, timestamp: new Date("2026-05-15T10:00:00Z") },
                { stockId: stocks.TSLA._id, price: 223.44, timestamp: new Date("2026-05-16T10:00:00Z") },
                { stockId: stocks.TSLA._id, price: 226.10, timestamp: new Date("2026-05-17T10:00:00Z") },
                { stockId: stocks.TSLA._id, price: 229.98, timestamp: new Date("2026-05-18T10:00:00Z") },
                { stockId: stocks.TSLA._id, price: 232.54, timestamp: new Date("2026-05-19T10:00:00Z") },
                { stockId: stocks.TSLA._id, price: 235.91, timestamp: new Date("2026-05-20T10:00:00Z") },
                { stockId: stocks.TSLA._id, price: 238.74, timestamp: new Date("2026-05-21T10:00:00Z") },
                { stockId: stocks.TSLA._id, price: 241.28, timestamp: new Date("2026-05-22T10:00:00Z") },
                { stockId: stocks.TSLA._id, price: 245.16, timestamp: new Date("2026-05-23T10:00:00Z") },
                { stockId: stocks.TSLA._id, price: 248.73, timestamp: new Date("2026-05-24T10:00:00Z") },

                // NVDA
                { stockId: stocks.NVDA._id, price: 980.22, timestamp: new Date("2026-05-15T10:00:00Z") },
                { stockId: stocks.NVDA._id, price: 992.45, timestamp: new Date("2026-05-16T10:00:00Z") },
                { stockId: stocks.NVDA._id, price: 1004.77, timestamp: new Date("2026-05-17T10:00:00Z") },
                { stockId: stocks.NVDA._id, price: 1018.22, timestamp: new Date("2026-05-18T10:00:00Z") },
                { stockId: stocks.NVDA._id, price: 1029.91, timestamp: new Date("2026-05-19T10:00:00Z") },
                { stockId: stocks.NVDA._id, price: 1038.55, timestamp: new Date("2026-05-20T10:00:00Z") },
                { stockId: stocks.NVDA._id, price: 1044.82, timestamp: new Date("2026-05-21T10:00:00Z") },
                { stockId: stocks.NVDA._id, price: 1050.11, timestamp: new Date("2026-05-22T10:00:00Z") },
                { stockId: stocks.NVDA._id, price: 1056.77, timestamp: new Date("2026-05-23T10:00:00Z") },
                { stockId: stocks.NVDA._id, price: 1062.11, timestamp: new Date("2026-05-24T10:00:00Z") },

                // META
                { stockId: stocks.META._id, price: 470.10, timestamp: new Date("2026-05-15T10:00:00Z") },
                { stockId: stocks.META._id, price: 474.88, timestamp: new Date("2026-05-16T10:00:00Z") },
                { stockId: stocks.META._id, price: 480.15, timestamp: new Date("2026-05-17T10:00:00Z") },
                { stockId: stocks.META._id, price: 485.22, timestamp: new Date("2026-05-18T10:00:00Z") },
                { stockId: stocks.META._id, price: 489.66, timestamp: new Date("2026-05-19T10:00:00Z") },
                { stockId: stocks.META._id, price: 494.91, timestamp: new Date("2026-05-20T10:00:00Z") },
                { stockId: stocks.META._id, price: 499.77, timestamp: new Date("2026-05-21T10:00:00Z") },
                { stockId: stocks.META._id, price: 504.11, timestamp: new Date("2026-05-22T10:00:00Z") },
                { stockId: stocks.META._id, price: 508.93, timestamp: new Date("2026-05-23T10:00:00Z") },
                { stockId: stocks.META._id, price: 512.88, timestamp: new Date("2026-05-24T10:00:00Z") },

                // NFLX
                { stockId: stocks.NFLX._id, price: 590.12, timestamp: new Date("2026-05-15T10:00:00Z") },
                { stockId: stocks.NFLX._id, price: 598.33, timestamp: new Date("2026-05-16T10:00:00Z") },
                { stockId: stocks.NFLX._id, price: 605.91, timestamp: new Date("2026-05-17T10:00:00Z") },
                { stockId: stocks.NFLX._id, price: 612.55, timestamp: new Date("2026-05-18T10:00:00Z") },
                { stockId: stocks.NFLX._id, price: 618.42, timestamp: new Date("2026-05-19T10:00:00Z") },
                { stockId: stocks.NFLX._id, price: 623.17, timestamp: new Date("2026-05-20T10:00:00Z") },
                { stockId: stocks.NFLX._id, price: 628.44, timestamp: new Date("2026-05-21T10:00:00Z") },
                { stockId: stocks.NFLX._id, price: 633.71, timestamp: new Date("2026-05-22T10:00:00Z") },
                { stockId: stocks.NFLX._id, price: 638.25, timestamp: new Date("2026-05-23T10:00:00Z") },
                { stockId: stocks.NFLX._id, price: 642.35, timestamp: new Date("2026-05-24T10:00:00Z") },

                // JPM
                { stockId: stocks.JPM._id, price: 198.15, timestamp: new Date("2026-05-15T10:00:00Z") },
                { stockId: stocks.JPM._id, price: 200.22, timestamp: new Date("2026-05-16T10:00:00Z") },
                { stockId: stocks.JPM._id, price: 202.77, timestamp: new Date("2026-05-17T10:00:00Z") },
                { stockId: stocks.JPM._id, price: 204.11, timestamp: new Date("2026-05-18T10:00:00Z") },
                { stockId: stocks.JPM._id, price: 206.44, timestamp: new Date("2026-05-19T10:00:00Z") },
                { stockId: stocks.JPM._id, price: 208.92, timestamp: new Date("2026-05-20T10:00:00Z") },
                { stockId: stocks.JPM._id, price: 210.10, timestamp: new Date("2026-05-21T10:00:00Z") },
                { stockId: stocks.JPM._id, price: 211.74, timestamp: new Date("2026-05-22T10:00:00Z") },
                { stockId: stocks.JPM._id, price: 213.12, timestamp: new Date("2026-05-23T10:00:00Z") },
                { stockId: stocks.JPM._id, price: 214.67, timestamp: new Date("2026-05-24T10:00:00Z") },

                // WMT
                { stockId: stocks.WMT._id, price: 65.12, timestamp: new Date("2026-05-15T10:00:00Z") },
                { stockId: stocks.WMT._id, price: 66.01, timestamp: new Date("2026-05-16T10:00:00Z") },
                { stockId: stocks.WMT._id, price: 66.88, timestamp: new Date("2026-05-17T10:00:00Z") },
                { stockId: stocks.WMT._id, price: 67.55, timestamp: new Date("2026-05-18T10:00:00Z") },
                { stockId: stocks.WMT._id, price: 68.20, timestamp: new Date("2026-05-19T10:00:00Z") },
                { stockId: stocks.WMT._id, price: 69.10, timestamp: new Date("2026-05-20T10:00:00Z") },
                { stockId: stocks.WMT._id, price: 69.88, timestamp: new Date("2026-05-21T10:00:00Z") },
                { stockId: stocks.WMT._id, price: 70.54, timestamp: new Date("2026-05-22T10:00:00Z") },
                { stockId: stocks.WMT._id, price: 71.44, timestamp: new Date("2026-05-23T10:00:00Z") },
                { stockId: stocks.WMT._id, price: 72.41, timestamp: new Date("2026-05-24T10:00:00Z") },

                // DIS
                { stockId: stocks.DIS._id, price: 102.15, timestamp: new Date("2026-05-15T10:00:00Z") },
                { stockId: stocks.DIS._id, price: 104.21, timestamp: new Date("2026-05-16T10:00:00Z") },
                { stockId: stocks.DIS._id, price: 106.55, timestamp: new Date("2026-05-17T10:00:00Z") },
                { stockId: stocks.DIS._id, price: 108.88, timestamp: new Date("2026-05-18T10:00:00Z") },
                { stockId: stocks.DIS._id, price: 110.32, timestamp: new Date("2026-05-19T10:00:00Z") },
                { stockId: stocks.DIS._id, price: 112.01, timestamp: new Date("2026-05-20T10:00:00Z") },
                { stockId: stocks.DIS._id, price: 113.77, timestamp: new Date("2026-05-21T10:00:00Z") },
                { stockId: stocks.DIS._id, price: 115.10, timestamp: new Date("2026-05-22T10:00:00Z") },
                { stockId: stocks.DIS._id, price: 117.55, timestamp: new Date("2026-05-23T10:00:00Z") },
                { stockId: stocks.DIS._id, price: 118.92, timestamp: new Date("2026-05-24T10:00:00Z") },

                // AMD
                { stockId: stocks.AMD._id, price: 150.22, timestamp: new Date("2026-05-15T10:00:00Z") },
                { stockId: stocks.AMD._id, price: 152.55, timestamp: new Date("2026-05-16T10:00:00Z") },
                { stockId: stocks.AMD._id, price: 155.11, timestamp: new Date("2026-05-17T10:00:00Z") },
                { stockId: stocks.AMD._id, price: 157.74, timestamp: new Date("2026-05-18T10:00:00Z") },
                { stockId: stocks.AMD._id, price: 160.18, timestamp: new Date("2026-05-19T10:00:00Z") },
                { stockId: stocks.AMD._id, price: 162.44, timestamp: new Date("2026-05-20T10:00:00Z") },
                { stockId: stocks.AMD._id, price: 164.77, timestamp: new Date("2026-05-21T10:00:00Z") },
                { stockId: stocks.AMD._id, price: 167.10, timestamp: new Date("2026-05-22T10:00:00Z") },
                { stockId: stocks.AMD._id, price: 169.88, timestamp: new Date("2026-05-23T10:00:00Z") },
                { stockId: stocks.AMD._id, price: 172.55, timestamp: new Date("2026-05-24T10:00:00Z") }

                ]);

                MONGOEOF
                EOF

    tags = {
        Name = "${var.project_name}-Database-Instance"
    }
}