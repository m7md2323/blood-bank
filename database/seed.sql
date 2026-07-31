SET search_path TO smart_blood_bank;

-- Seed Data
INSERT INTO roles (role_code, role_name) VALUES
('central_admin', 'Central Administrator'),
('blood_bank_admin', 'Blood Bank Administrator'),
('hospital_admin', 'Hospital Administrator'),
('donor', 'Donor'),
('patient', 'Patient');
 
INSERT INTO blood_banks (name, phone_number, email, governorate, city, address_text, latitude, longitude)
VALUES ('Central Blood Bank for North Region', '+96227000000', 'north.bank@example.com', 'Irbid', 'Irbid', 'Irbid Health District', 32.555600, 35.850000);
 
INSERT INTO hospitals (name, phone_number, email, governorate, city, address_text, latitude, longitude)
VALUES ('King Abdullah University Hospital', '+96227200000', 'kauh@example.com', 'Irbid', 'Irbid', 'Ramtha Road', 32.496300, 35.991500),
       ('Prince Rashed Bin Al-Hasan Military Hospital', '+96227200001', 'prince.rashed@example.com', 'Irbid', 'Irbid', 'Irbid', 32.540000, 35.857000);
 
INSERT INTO users (
    national_number, email, phone_number, password_hash, first_name, last_name,
    gender, date_of_birth, blood_type, weight_kg, residence_governorate, residence_city,
    address_text, latitude, longitude, status
) VALUES
('2000123456', 'ahmad.donor@example.com', '+962790000001', 'hash_replace_in_app', 'Ahmad', 'Khalil',
 'male', '1998-04-12', 'O+', 78.50, 'Irbid', 'Irbid', 'University Street', 32.556800, 35.846900, 'active'),
('1999123456', 'sara.patient@example.com', '+962790000002', 'hash_replace_in_app', 'Sara', 'Mahmoud',
 'female', '1999-09-20', 'O+', 62.00, 'Amman', 'Amman', 'Tla Al Ali', 31.997600, 35.836600, 'active'),
('1988123456', 'bank.admin@example.com', '+962790000003', 'hash_replace_in_app', 'Mona', 'Haddad',
 'female', '1988-02-05', 'A+', 65.00, 'Irbid', 'Irbid', 'Central Blood Bank', 32.555600, 35.850000, 'active'),
('1980123456', 'hospital.admin@example.com', '+962790000004', 'hash_replace_in_app', 'Omar', 'Nasser',
 'male', '1980-11-15', 'B+', 82.00, 'Amman', 'Amman', 'Hospital Road', 31.953900, 35.910600, 'active');
 
UPDATE users SET managed_blood_bank_id = (SELECT blood_bank_id FROM blood_banks WHERE name = 'Central Blood Bank for North Region')
WHERE email = 'bank.admin@example.com';
 
UPDATE users SET managed_hospital_id = (SELECT hospital_id FROM hospitals WHERE name = 'King Abdullah University Hospital')
WHERE email = 'hospital.admin@example.com';
 
INSERT INTO user_roles (user_id, role_id)
SELECT u.user_id, r.role_id
FROM users u
JOIN roles r ON
    (u.email = 'ahmad.donor@example.com' AND r.role_code = 'donor')
    OR (u.email = 'sara.patient@example.com' AND r.role_code = 'patient')
    OR (u.email = 'bank.admin@example.com' AND r.role_code = 'blood_bank_admin')
    OR (u.email = 'hospital.admin@example.com' AND r.role_code = 'hospital_admin');
 
INSERT INTO donation_centers (name, blood_bank_id, phone_number, governorate, city, address_text, latitude, longitude, opening_hours)
SELECT 'North Region Donation Center', blood_bank_id, '+96227000002', 'Irbid', 'Irbid', 'Central Blood Bank Building', 32.555600, 35.850000, 'Sun-Thu 08:00-15:00'
FROM blood_banks
WHERE name = 'Central Blood Bank for North Region';
 
INSERT INTO donor_profiles (user_id, is_available)
SELECT user_id, true FROM users WHERE email IN ('ahmad.donor@example.com', 'sara.patient@example.com');
 
INSERT INTO patients (registered_by_hospital_id, linked_user_id, national_number, first_name, last_name, gender, date_of_birth, blood_type, phone_number, medical_record_reference)
SELECT h.hospital_id, u.user_id, u.national_number, u.first_name, u.last_name, u.gender, u.date_of_birth, u.blood_type, u.phone_number, 'HAKEEM-REF-1001'
FROM hospitals h CROSS JOIN users u
WHERE h.name = 'King Abdullah University Hospital' AND u.email = 'sara.patient@example.com';
 
INSERT INTO donations (donor_user_id, center_id, blood_type, units, scheduled_at, donated_at, status, test_status, tested_at)
SELECT u.user_id, c.center_id, 'O+', 1, now() - interval '1 hour', now(), 'accepted', 'passed', now()
FROM users u CROSS JOIN donation_centers c
WHERE u.email = 'ahmad.donor@example.com' AND c.name = 'North Region Donation Center';
 
UPDATE donor_profiles
SET credit_balance = credit_balance + d.units,
    last_donation_at = d.donated_at
FROM donations d
WHERE donor_profiles.user_id = d.donor_user_id AND d.status = 'accepted';

INSERT INTO blood_credit_transactions (transaction_type, donor_user_id, donation_id, units, notes)
SELECT 'earned', d.donor_user_id, d.donation_id, d.units, 'Credit earned from accepted donation'
FROM donations d
WHERE d.status = 'accepted';

INSERT INTO blood_units (unit_code, donation_id, blood_type, current_blood_bank_id, status, collected_at, expires_at, tested_at, test_status)
SELECT 'UNIT-IRB-000001', d.donation_id, d.blood_type, b.blood_bank_id, 'available', d.donated_at, d.donated_at + interval '42 days', d.tested_at, 'passed'
FROM donations d CROSS JOIN blood_banks b
WHERE b.name = 'Central Blood Bank for North Region';
 
INSERT INTO blood_requests (hospital_id, patient_id, requested_by_user_id, blood_type, units_requested, priority, needed_by, status, reason, broadcast_radius_km, broadcast_message, is_broadcast_active)
SELECT h.hospital_id, p.patient_id, u.user_id, 'O+', 2, 'emergency', now() + interval '6 hours', 'submitted', 'Emergency shortage for patient transfusion', 25, 'Urgent O+ blood units are needed near Irbid.', true
FROM hospitals h
JOIN patients p ON p.registered_by_hospital_id = h.hospital_id
CROSS JOIN users u
WHERE h.name = 'King Abdullah University Hospital' AND u.email = 'hospital.admin@example.com';
 
INSERT INTO notifications (user_id, blood_request_id, channel, title, body, status)
SELECT donor.user_id, br.blood_request_id, 'sms', 'Urgent Blood Donation Needed', br.broadcast_message, 'queued'
FROM blood_requests br CROSS JOIN users donor
WHERE donor.email = 'ahmad.donor@example.com';


