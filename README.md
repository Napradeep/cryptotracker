# crypto_tracker
A real-time cryptocurrency price tracking app built with Flutter. The app fetches live price updates via Binance WebSocket and historical data using Binance's REST API.

🚀 Features
📊 Live Price Updates: Connects to Binance WebSocket for real-time prices.

📉 Historical Data: Fetches historical price data for different time intervals.

📆 Monthly Data Fetching: Retrieves price data for the selected month.

🎨 User-friendly UI: Clean and responsive Flutter UI.

🛠 Tech Stack
Flutter (Dart)

WebSockets for real-time updates

REST API for historical data

Provider for state management


clone the repository:


git clone https://github.com/your-username/crypto-price-tracker.git

Navigate to the project directory:

cd crypto-price-tracker

Install dependencies:
flutter pub get

Run the app:
flutter run

🔗 API Usage
The app uses Binance API to fetch live and historical crypto data.

📡 WebSocket Connection
Live price updates are retrieved from:


wss://stream.binance.com:9443/ws/{symbol}@trade
Example:
wss://stream.binance.com:9443/ws/btcusdt@trade
⏳ Fetching Historical Data
Endpoint:
https://api.binance.com/api/v3/klines
Example:
https://api.binance.com/api/v3/klines?symbol=BTCUSDT&interval=1d&limit=30

Time Intervals:
Interval	Description
1d	1 day
1M	1 month
6M	6 months
1y	1 year
Clone the repository:

git clone https://github.com/your-username/crypto-price-tracker.git
Navigate to the project directory:


cd crypto-price-tracker
Install dependencies:

flutter pub get
Run the app:


flutter run
🔗 API Usage
The app uses Binance API to fetch live and historical crypto data.

📡 WebSocket Connection
Live price updates are retrieved from:

wss://stream.binance.com:9443/ws/{symbol}@trade
Example:
wss://stream.binance.com:9443/ws/btcusdt@trade

⏳ Fetching Historical Data
Endpoint:
https://api.binance.com/api/v3/klines
Example:
https://api.binance.com/api/v3/klines?symbol=BTCUSDT&interval=1d&limit=30




