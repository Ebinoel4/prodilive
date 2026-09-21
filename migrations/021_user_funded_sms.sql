-- v5.41: user-funded SMS alerts
INSERT INTO settings(key,value) VALUES('smsUserPriceNgn','10') ON CONFLICT(key) DO NOTHING;
