@echo off
setlocal
echo ===============================================================================
echo         CROWNE PLAZA HOTEL MANAGEMENT SYSTEM - LIVE DATABASE INSPECTION
echo ===============================================================================
echo Connecting to PostgreSQL database 'hotel_management'...
echo.

set PGPASSWORD=200728
set PSQL="C:\Program Files\PostgreSQL\18\bin\psql.exe"

echo -------------------------------------------------------------------------------
echo [1] ALL RESERVATIONS AND GUEST BOOKINGS (LIVE FROM POSTGRESQL)
echo -------------------------------------------------------------------------------
%PSQL% -U postgres -d hotel_management -c "SELECT res.reservation_id, c.name AS guest_name, c.email, r.room_number, r.room_type, res.check_in, res.check_out, (res.check_out - res.check_in) AS nights, res.status FROM reservations res JOIN customers c ON res.customer_id = c.customer_id JOIN rooms r ON res.room_id = r.room_id ORDER BY res.reservation_id DESC;"

echo.
echo -------------------------------------------------------------------------------
echo [2] ROOM INVENTORY AND REAL-TIME STATUSES
echo -------------------------------------------------------------------------------
%PSQL% -U postgres -d hotel_management -c "SELECT room_number, room_type, price_per_night, status FROM rooms ORDER BY room_number;"

echo.
echo -------------------------------------------------------------------------------
echo [3] ACTIVE STAY VIEW (POSTGRESQL VIEW: vw_active_reservations)
echo -------------------------------------------------------------------------------
%PSQL% -U postgres -d hotel_management -c "SELECT reservation_id, guest_name, room_number, room_type, check_in, check_out, total_nights, reservation_status FROM vw_active_reservations ORDER BY reservation_id DESC;"

echo.
echo ===============================================================================
echo Inspection complete.
echo ===============================================================================
pause
