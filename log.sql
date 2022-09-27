-- A Briefcase storing the codes to the last rocket form earth has been stolen! The town of Sumnerforth has called upon you to solve the mystery of the codes. 
-- Authorities believe that the thief stole the briefcase and then, shortly afterwards, took a flight out of town with the help of an accomplice. 
--Your goal is to identify:
--Who the thief is,
--What city the thief escaped to, and
--Who the thief’s accomplice is who helped them escape
--All you know is that the theft took place on June 12, 2022 and that it took place on Regenald Road.


-- Log of any SQL queries you execute as you solve the mystery.

-- To find crimes commited on Regenald Road on 12, JUl 2022
SELECT *
FROM crime_scene_reports
WHERE  street = "Regenald Road"
AND year = 2022
AND month = 6
AND day = 12;
-- there were 2 crimes on that day with the crime id 295 being the crime in question


-- to find the incident intervies of the crime
SELECT transcript, name
FROM interviews
WHERE year = 2022
AND month = 6
AND day = 12;
-- there are three people that reference the thief directly, Christian Ruby and Immanuel


-- to find the earliest flight out of Sumnerforth on 29, JUL 2022 per Christian
SELECT *
FROM airports
WHERE city = "Sumnerforth";
-- airport name is Sumnerforth Regional Airport - CSF - id 8

-- to get the fights out of CSF
SELECT *
FROM airports
JOIN flights ON airports.id = flights.destination_airport_id
WHERE flights.origin_airport_id = (
    SELECT id
    FROM airports
    WHERE city = 'Sumnerforth'
)
AND flights.year = 2022
AND flights.month = 6
AND flights.day = 29
ORDER BY flights.hour, flights.minute;
-- flight leaving at 8:20am to LGA New York City is the earliest flight

-- to check for passengers of that flight and order them by passport number
SELECT *
  FROM people
  JOIN passengers
    ON people.passport_number = passengers.passport_number
  JOIN flights
    ON passengers.flight_id = flights.id
 WHERE flights.year = 2022
   AND flights.month = 6
   AND flights.day = 29
   AND flights.hour = 8
 ORDER BY passengers.passport_number;
-- there were 8 passangers


-- to check bakery parking lot per Ruby and reference those on the flight
SELECT name, bakery_security_logs.hour, bakery_security_logs.minute
FROM people
JOIN bakery_security_logs
ON people.license_plate = bakery_security_logs.license_plate
WHERE bakery_security_logs.year = 2022
AND bakery_security_logs.month = 6
AND bakery_security_logs.day = 12
AND bakery_security_logs.activity = 'exit'
AND bakery_security_logs.hour = 10
AND bakery_security_logs.minute >= 15
AND bakery_security_logs.minute <= 25
ORDER BY bakery_security_logs.minute;
-- Nicholas, Luca, Sophia and Kelsey are commonalities


-- to check the ATM widthdrawls per Immanuel and reference to those from the bakery parking lot and the flight
SELECT name, atm_transactions.amount
FROM people
JOIN bank_accounts
ON people.id = bank_accounts.person_id
JOIN atm_transactions
ON bank_accounts.account_number = atm_transactions.account_number
WHERE atm_transactions.year = 2022
AND atm_transactions.month = 6
AND atm_transactions.day = 12
AND atm_transactions.atm_location = "Leggett Street"
AND atm_transactions.transaction_type = "withdraw";
-- narrows down suspects to Nicholas and Luca


-- to check phone logs per Raymond
SELECT name, phone_calls.duration
FROM people
JOIN phone_calls
ON people.phone_number = phone_calls.caller
WHERE phone_calls.year = 2022
AND phone_calls.month = 6
AND phone_calls.day = 12
AND phone_calls.duration <= 60
ORDER BY phone_calls.duration;
-- NICHOLAS is the THIEF

--to check who Nicholas was talking too
SELECT name, phone_calls.duration
FROM people
JOIN phone_calls
ON people.phone_number = phone_calls.receiver
WHERE phone_calls.year = 2022
AND phone_calls.month = 6
AND phone_calls.day = 12
AND phone_calls.duration = 45;
-- Emily has to be Nicholas's accomplice