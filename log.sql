-- Keep a log of any SQL queries you execute as you solve the myst

-- See description of all crime took place on Chamberlin Street on July 28, 2020
SELECT description FROM crime_scene_reports 
WHERE day = 28 AND month = 7 AND year = 2020 AND UPPER(street) = "CHAMBERLIN STREET"
-- Found: the crime took place at 10:15am and three witnesses interviewed mentioned couthouse

-- Find interview's transcript and the names of three witnesses on the crime_scene interview on the same day
SELECT name, transcript FROM interviews 
WHERE day = 28 AND month = 7 AND year = 2020 AND transcript like "%courthouse%"
-- Ruth: The theft left on a car parked in the courthouse parking lot
-- Eugene: The theft was withdrawing money at the ATM on Fifer Street earlier that morning
-- Raymond: They called someone for less than a minute to book tomorrow's earliest flight from fiftyville. The person on the phone booked the ticket.

-- Use information on ATM usage's time and location to find the account_number
SELECT account_number FROM atm_transactions 
WHERE day = 28 AND month = 7 AND year = 2020 
AND UPPER(atm_location) = "FIFER STREET"
AND UPPER(transaction_type) = "WITHDRAW"
-- There is a way to acct number to the owner of the acct thorugh person_id

-- Use information from Ruth about the theft's escape to get license plate of cars leaving the courthouse parking lot between 10:15 - 10:20 on the day
SELECT license_plate, activity FROM courthouse_security_logs
WHERE day = 28 AND month = 7 AND year = 2020
AND hour = 10 AND minute >= 15 AND minute <= 20
-- There were 5 cars exited the parling lot between 10:15 - 10:20 on the day

-- Cross check to find the person who withdraw money from the atm and own one of the cars and the person phone number
SELECT people.name, people.phone_number FROM people JOIN bank_accounts ON people.id = bank_accounts.person_id 
JOIN atm_transactions ON atm_transactions.account_number = bank_accounts.account_number 
WHERE day = 28 AND month = 7 AND year = 2020 
AND UPPER(atm_location) = "FIFER STREET"
AND UPPER(transaction_type) = "WITHDRAW"
AND people.name IN (
SELECT people.name FROM people JOIN courthouse_security_logs ON people.license_plate = courthouse_security_logs.license_plate
WHERE courthouse_security_logs.day = 28 AND courthouse_security_logs.month = 7 AND courthouse_security_logs.year = 2020
AND courthouse_security_logs.hour = 10 AND courthouse_security_logs.minute >= 15 AND courthouse_security_logs.minute <= 19
AND UPPER(courthouse_security_logs.activity) = "EXIT");
-- Theft suspects are Ernest (367) 555-5533 and Danielle (389) 555-5198

-- Identify the destination of the earliest flight from fiftyville afther 10:15am on the day
SELECT airports.full_name, airports.city, flights.hour, flights.minute FROM airports JOIN flights ON airports.id = flights.destination_airport_id
WHERE day = 29 AND month = 7 AND year = 2020
AND airports.full_name IN (
SELECT airports.full_name FROM airports JOIN flights ON airports.id = flights.destination_airport_id
WHERE flights.origin_airport_id IN (
SELECT flights.origin_airport_id FROM airports JOIN flights ON airports.id = flights.origin_airport_id 
WHERE UPPER(airports.city) = "FIFTYVILLE")) ORDER BY hour ASC, minute ASC
-- The earliest flight from Fiftyville on July, 29 was to London  at 08:20

-- Use information about the call to find out if Ernest and Danielle made any call that was less than 1 min
SELECT people.name FROM people JOIN phone_calls ON people.phone_number = phone_calls.caller
WHERE day = 28 AND month = 7 AND year = 2020
AND duration <= 60
-- Ernest made the call, so our theft was Ernest

-- Find his accomplice
SELECT people.name FROM people JOIN phone_calls ON people.phone_number = phone_calls.receiver
WHERE day = 28 AND month = 7 AND year = 2020
AND duration <= 60
AND phone_calls.caller IN (
SELECT phone_calls.caller FROM phone_calls JOIN people ON phone_calls.caller = people.phone_number
WHERE people.name ="Ernest")
-- his accomplice was Berthold