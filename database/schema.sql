CREATE SCHEMA IF NOT EXISTS smart_blood_bank;
SET search_path TO smart_blood_bank;
 
-- Enums
CREATE TYPE blood_group AS ENUM ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-');
CREATE TYPE gender_type AS ENUM ('male', 'female');
CREATE TYPE user_status AS ENUM ('pending_verification', 'active', 'suspended', 'deactivated');
CREATE TYPE organization_status AS ENUM ('active', 'inactive');
 
CREATE TYPE donation_status AS ENUM ('scheduled', 'confirmed', 'no_show', 'pending_test', 'accepted', 'rejected', 'cancelled');
 
CREATE TYPE test_result AS ENUM ('pending', 'passed', 'failed');
CREATE TYPE blood_unit_status AS ENUM ('available', 'reserved', 'issued', 'transfused', 'expired', 'discarded');
CREATE TYPE request_status AS ENUM ('submitted', 'searching_donors', 'partially_fulfilled', 'fulfilled', 'cancelled', 'rejected');
CREATE TYPE request_priority AS ENUM ('normal', 'urgent', 'emergency');
CREATE TYPE notification_channel AS ENUM ('sms', 'email', 'push', 'in_app');
CREATE TYPE notification_status AS ENUM ('queued', 'sent', 'delivered', 'failed', 'read');
CREATE TYPE credit_transaction_type AS ENUM ('earned', 'transferred', 'redeemed');
CREATE TYPE transfer_status AS ENUM ('planned', 'in_transit', 'completed', 'cancelled');
 
-- Roles
CREATE TABLE roles (
    role_id smallint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    role_code varchar(40) NOT NULL UNIQUE,
    role_name varchar(80) NOT NULL UNIQUE
);
 
-- Organizations
CREATE TABLE blood_banks (
    blood_bank_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name varchar(160) NOT NULL UNIQUE,
    phone_number varchar(30),
    email varchar(255),
    governorate varchar(80) NOT NULL,
    city varchar(80) NOT NULL,
    address_text text NOT NULL,
    latitude numeric(9,6),
    longitude numeric(9,6),
    status organization_status NOT NULL DEFAULT 'active',
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT chk_blood_banks_latitude CHECK (latitude IS NULL OR latitude BETWEEN -90 AND 90),
    CONSTRAINT chk_blood_banks_longitude CHECK (longitude IS NULL OR longitude BETWEEN -180 AND 180)
);
 
CREATE TABLE hospitals (
    hospital_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name varchar(160) NOT NULL UNIQUE,
    phone_number varchar(30),
    email varchar(255),
    governorate varchar(80) NOT NULL,
    city varchar(80) NOT NULL,
    address_text text NOT NULL,
    latitude numeric(9,6),
    longitude numeric(9,6),
    status organization_status NOT NULL DEFAULT 'active',
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT chk_hospitals_latitude CHECK (latitude IS NULL OR latitude BETWEEN -90 AND 90),
    CONSTRAINT chk_hospitals_longitude CHECK (longitude IS NULL OR longitude BETWEEN -180 AND 180)
);
 
-- Users
CREATE TABLE users (
    user_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    national_number varchar(30) NOT NULL UNIQUE,
    email varchar(255) NOT NULL UNIQUE,
    phone_number varchar(30) NOT NULL UNIQUE,
    password_hash text NOT NULL,
    first_name varchar(80) NOT NULL,
    last_name varchar(80) NOT NULL,
    gender gender_type NOT NULL,
    date_of_birth date NOT NULL,
    blood_type blood_group,
    weight_kg numeric(5,2),
    residence_governorate varchar(80),
    residence_city varchar(80),
    address_text text,
    latitude numeric(9,6),
    longitude numeric(9,6),
    profile_photo_url text,
    status user_status NOT NULL DEFAULT 'pending_verification',
    managed_blood_bank_id bigint REFERENCES blood_banks(blood_bank_id) ON DELETE SET NULL ON UPDATE CASCADE,
    managed_hospital_id bigint REFERENCES hospitals(hospital_id) ON DELETE SET NULL ON UPDATE CASCADE,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT chk_users_weight CHECK (weight_kg IS NULL OR weight_kg >= 0),
    CONSTRAINT chk_users_latitude CHECK (latitude IS NULL OR latitude BETWEEN -90 AND 90),
    CONSTRAINT chk_users_longitude CHECK (longitude IS NULL OR longitude BETWEEN -180 AND 180),
    CONSTRAINT chk_users_birth_date_not_future CHECK (date_of_birth <= CURRENT_DATE),
    CONSTRAINT chk_users_single_managed_org CHECK (managed_blood_bank_id IS NULL OR managed_hospital_id IS NULL)
);
 
CREATE TABLE user_roles (
    user_id bigint NOT NULL REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    role_id smallint NOT NULL REFERENCES roles(role_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    assigned_at timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (user_id, role_id)
);
 
-- Authentication
CREATE TABLE user_mfa_methods (
    mfa_method_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id bigint NOT NULL REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    channel notification_channel NOT NULL,
    destination varchar(255) NOT NULL,
    is_verified boolean NOT NULL DEFAULT false,
    created_at timestamptz NOT NULL DEFAULT now(),
    UNIQUE (user_id, channel, destination)
);
 
CREATE TABLE otp_challenges (
    otp_challenge_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id bigint NOT NULL REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    channel notification_channel NOT NULL,
    destination varchar(255) NOT NULL,
    otp_hash text NOT NULL,
    expires_at timestamptz NOT NULL,
    consumed_at timestamptz,
    created_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT chk_otp_expiry CHECK (expires_at > created_at)
);
 
CREATE TABLE password_reset_tokens (
    reset_token_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id bigint NOT NULL REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    token_hash text NOT NULL UNIQUE,
    expires_at timestamptz NOT NULL,
    used_at timestamptz,
    created_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT chk_password_reset_expiry CHECK (expires_at > created_at)
);
 
-- Centers
CREATE TABLE donation_centers (
    center_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name varchar(160) NOT NULL UNIQUE,
    blood_bank_id bigint REFERENCES blood_banks(blood_bank_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    hospital_id bigint REFERENCES hospitals(hospital_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    phone_number varchar(30),
    governorate varchar(80) NOT NULL,
    city varchar(80) NOT NULL,
    address_text text NOT NULL,
    latitude numeric(9,6) NOT NULL,
    longitude numeric(9,6) NOT NULL,
    opening_hours text,
    status organization_status NOT NULL DEFAULT 'active',
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT chk_centers_owner CHECK ((blood_bank_id IS NOT NULL) <> (hospital_id IS NOT NULL)),
    CONSTRAINT chk_centers_latitude CHECK (latitude BETWEEN -90 AND 90),
    CONSTRAINT chk_centers_longitude CHECK (longitude BETWEEN -180 AND 180)
);
 
-- Donors
CREATE TABLE donor_profiles (
    user_id bigint PRIMARY KEY REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    is_available boolean NOT NULL DEFAULT true,
    last_donation_at timestamptz,
    eligible_after date,
    credit_balance integer NOT NULL DEFAULT 0,
    notes text,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT chk_donor_credit_balance_nonnegative CHECK (credit_balance >= 0)
);
 
-- Patients
CREATE TABLE patients (
    patient_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    registered_by_hospital_id bigint NOT NULL REFERENCES hospitals(hospital_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    linked_user_id bigint UNIQUE REFERENCES users(user_id) ON DELETE SET NULL ON UPDATE CASCADE,
    national_number varchar(30),
    first_name varchar(80) NOT NULL,
    last_name varchar(80) NOT NULL,
    gender gender_type,
    date_of_birth date,
    blood_type blood_group,
    phone_number varchar(30),
    medical_record_reference varchar(120),
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    UNIQUE (registered_by_hospital_id, national_number),
    CONSTRAINT chk_patients_birth_date CHECK (date_of_birth IS NULL OR date_of_birth <= CURRENT_DATE)
);
 
-- Donations
CREATE TABLE donations (
    donation_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    donor_user_id bigint NOT NULL REFERENCES donor_profiles(user_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    center_id bigint NOT NULL REFERENCES donation_centers(center_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    blood_type blood_group NOT NULL,
    units integer NOT NULL DEFAULT 1,
    scheduled_at timestamptz,
    donated_at timestamptz,
    status donation_status NOT NULL DEFAULT 'scheduled',
    test_status test_result NOT NULL DEFAULT 'pending',
    tested_by_user_id bigint REFERENCES users(user_id) ON DELETE SET NULL ON UPDATE CASCADE,
    tested_at timestamptz,
    rejection_reason text,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT chk_donations_units CHECK (units > 0),
    UNIQUE (donor_user_id, scheduled_at)
);
 
-- Inventory
CREATE TABLE blood_units (
    blood_unit_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    unit_code varchar(60) NOT NULL UNIQUE,
    volume_ml integer NOT NULL DEFAULT 450 CHECK (volume_ml > 0 AND volume_ml <= 750),
    donation_id bigint REFERENCES donations(donation_id) ON DELETE SET NULL ON UPDATE CASCADE,
    blood_type blood_group NOT NULL,
    current_blood_bank_id bigint REFERENCES blood_banks(blood_bank_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    current_hospital_id bigint REFERENCES hospitals(hospital_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    status blood_unit_status NOT NULL DEFAULT 'available',
    collected_at timestamptz NOT NULL,
    expires_at timestamptz NOT NULL,
    tested_at timestamptz,
    test_status test_result NOT NULL DEFAULT 'pending',
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT chk_blood_unit_location CHECK (
        (current_blood_bank_id IS NOT NULL AND current_hospital_id IS NULL)
        OR (current_blood_bank_id IS NULL AND current_hospital_id IS NOT NULL)
    ),
    CONSTRAINT chk_blood_unit_expiry CHECK (expires_at > collected_at)
);
 
-- Requests
CREATE TABLE blood_requests (
    blood_request_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    hospital_id bigint NOT NULL REFERENCES hospitals(hospital_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    patient_id bigint REFERENCES patients(patient_id) ON DELETE SET NULL ON UPDATE CASCADE,
    requested_by_user_id bigint REFERENCES users(user_id) ON DELETE SET NULL ON UPDATE CASCADE,
    blood_type blood_group NOT NULL,
    units_requested integer NOT NULL,
    priority request_priority NOT NULL DEFAULT 'normal',
    needed_by timestamptz,
    status request_status NOT NULL DEFAULT 'submitted',
    reason text,
    broadcast_radius_km numeric(7,2),
    broadcast_message text,
    is_broadcast_active boolean NOT NULL DEFAULT false,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT chk_blood_requests_units CHECK (units_requested > 0),
    CONSTRAINT chk_blood_requests_broadcast_radius CHECK (broadcast_radius_km IS NULL OR broadcast_radius_km > 0)
);
 
CREATE TABLE blood_request_allocations (
    allocation_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    blood_request_id bigint NOT NULL REFERENCES blood_requests(blood_request_id) ON DELETE CASCADE ON UPDATE CASCADE,
    blood_unit_id bigint NOT NULL UNIQUE REFERENCES blood_units(blood_unit_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    allocated_by_user_id bigint REFERENCES users(user_id) ON DELETE SET NULL ON UPDATE CASCADE,
    allocated_at timestamptz NOT NULL DEFAULT now()
);

-- Credits
CREATE TABLE blood_credit_transactions (
    credit_transaction_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    transaction_type credit_transaction_type NOT NULL,
    donor_user_id bigint NOT NULL REFERENCES donor_profiles(user_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    recipient_donor_user_id bigint REFERENCES donor_profiles(user_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    recipient_patient_id bigint REFERENCES patients(patient_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    donation_id bigint UNIQUE REFERENCES donations(donation_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    blood_request_id bigint REFERENCES blood_requests(blood_request_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    units integer NOT NULL,
    notes text,
    created_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT chk_credit_transaction_units CHECK (units > 0),
    CONSTRAINT chk_credit_transaction_recipient CHECK (
        recipient_donor_user_id IS NULL OR recipient_donor_user_id <> donor_user_id
    ),
    CONSTRAINT chk_credit_transaction_shape CHECK (
        (transaction_type = 'earned'
            AND donation_id IS NOT NULL
            AND recipient_donor_user_id IS NULL
            AND recipient_patient_id IS NULL
            AND blood_request_id IS NULL)
        OR (transaction_type = 'transferred'
            AND donation_id IS NULL
            AND ((recipient_donor_user_id IS NOT NULL) <> (recipient_patient_id IS NOT NULL))
            AND blood_request_id IS NULL)
        OR (transaction_type = 'redeemed'
            AND donation_id IS NULL
            AND recipient_donor_user_id IS NULL
            AND (recipient_patient_id IS NOT NULL OR blood_request_id IS NOT NULL))
    )
);

-- Transport
CREATE TABLE blood_transport_vehicles (
    vehicle_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    vehicle_code varchar(60) NOT NULL UNIQUE,
    blood_bank_id bigint REFERENCES blood_banks(blood_bank_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    hospital_id bigint REFERENCES hospitals(hospital_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    is_available boolean NOT NULL DEFAULT true,
    created_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT chk_vehicle_owner CHECK ((blood_bank_id IS NOT NULL) <> (hospital_id IS NOT NULL))
);

CREATE TABLE blood_unit_transfers (
    transfer_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    origin_blood_bank_id bigint REFERENCES blood_banks(blood_bank_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    origin_hospital_id bigint REFERENCES hospitals(hospital_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    destination_blood_bank_id bigint REFERENCES blood_banks(blood_bank_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    destination_hospital_id bigint REFERENCES hospitals(hospital_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    vehicle_id bigint REFERENCES blood_transport_vehicles(vehicle_id) ON DELETE SET NULL ON UPDATE CASCADE,
    created_by_user_id bigint REFERENCES users(user_id) ON DELETE SET NULL ON UPDATE CASCADE,
    status transfer_status NOT NULL DEFAULT 'planned',
    departed_at timestamptz,
    arrived_at timestamptz,
    notes text,
    created_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT chk_transfer_origin CHECK ((origin_blood_bank_id IS NOT NULL) <> (origin_hospital_id IS NOT NULL)),
    CONSTRAINT chk_transfer_destination CHECK ((destination_blood_bank_id IS NOT NULL) <> (destination_hospital_id IS NOT NULL)),
    CONSTRAINT chk_transfer_distinct_locations CHECK (
        (origin_blood_bank_id IS NULL OR destination_blood_bank_id IS NULL OR origin_blood_bank_id <> destination_blood_bank_id)
        AND (origin_hospital_id IS NULL OR destination_hospital_id IS NULL OR origin_hospital_id <> destination_hospital_id)
    ),
    CONSTRAINT chk_transfer_dates CHECK (arrived_at IS NULL OR (departed_at IS NOT NULL AND arrived_at >= departed_at))
);

CREATE TABLE blood_unit_transfer_items (
    transfer_id bigint NOT NULL REFERENCES blood_unit_transfers(transfer_id) ON DELETE CASCADE ON UPDATE CASCADE,
    blood_unit_id bigint NOT NULL REFERENCES blood_units(blood_unit_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    PRIMARY KEY (transfer_id, blood_unit_id)
);

-- Messages
CREATE TABLE messages (
    message_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    sender_user_id bigint NOT NULL REFERENCES users(user_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    recipient_user_id bigint NOT NULL REFERENCES users(user_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    blood_request_id bigint REFERENCES blood_requests(blood_request_id) ON DELETE SET NULL ON UPDATE CASCADE,
    subject varchar(160),
    body text NOT NULL,
    sent_at timestamptz NOT NULL DEFAULT now(),
    read_at timestamptz,
    CONSTRAINT chk_messages_distinct_users CHECK (sender_user_id <> recipient_user_id)
);

-- Notifications
CREATE TABLE notifications (
    notification_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id bigint NOT NULL REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    blood_request_id bigint REFERENCES blood_requests(blood_request_id) ON DELETE SET NULL ON UPDATE CASCADE,
    channel notification_channel NOT NULL,
    title varchar(160) NOT NULL,
    body text NOT NULL,
    status notification_status NOT NULL DEFAULT 'queued',
    queued_at timestamptz NOT NULL DEFAULT now(),
    sent_at timestamptz,
    read_at timestamptz
);
 
-- Indexes
CREATE INDEX idx_users_name ON users (last_name, first_name);
CREATE INDEX idx_users_blood_type ON users (blood_type);
CREATE INDEX idx_users_residence ON users (residence_governorate, residence_city);
CREATE INDEX idx_users_location ON users (latitude, longitude);
CREATE INDEX idx_users_managed_bank ON users (managed_blood_bank_id);
CREATE INDEX idx_users_managed_hospital ON users (managed_hospital_id);
CREATE INDEX idx_centers_blood_bank ON donation_centers (blood_bank_id);
CREATE INDEX idx_centers_hospital ON donation_centers (hospital_id);
CREATE INDEX idx_centers_location ON donation_centers (governorate, city, latitude, longitude);
CREATE INDEX idx_patients_registered_hospital ON patients (registered_by_hospital_id);
CREATE INDEX idx_donations_donor_date ON donations (donor_user_id, donated_at DESC);
CREATE INDEX idx_donations_center ON donations (center_id);
CREATE INDEX idx_donations_tested_by_user ON donations (tested_by_user_id);
CREATE INDEX idx_donations_status ON donations (status, test_status);
CREATE INDEX idx_blood_units_donation ON blood_units (donation_id);
CREATE INDEX idx_blood_units_current_blood_bank ON blood_units (current_blood_bank_id);
CREATE INDEX idx_blood_units_current_hospital ON blood_units (current_hospital_id);
CREATE INDEX idx_blood_units_inventory ON blood_units (blood_type, status, current_blood_bank_id, current_hospital_id);
CREATE INDEX idx_blood_units_expiry ON blood_units (expires_at);
CREATE INDEX idx_blood_requests_hospital_status ON blood_requests (hospital_id, status, created_at DESC);
CREATE INDEX idx_blood_requests_type_status ON blood_requests (blood_type, status, priority);
CREATE INDEX idx_blood_requests_broadcast ON blood_requests (is_broadcast_active, blood_type);
CREATE INDEX idx_allocations_blood_request ON blood_request_allocations (blood_request_id);
CREATE INDEX idx_credit_transactions_donor ON blood_credit_transactions (donor_user_id, created_at DESC);
CREATE INDEX idx_credit_transactions_recipient_donor ON blood_credit_transactions (recipient_donor_user_id, created_at DESC) WHERE recipient_donor_user_id IS NOT NULL;
CREATE INDEX idx_credit_transactions_recipient_patient ON blood_credit_transactions (recipient_patient_id, created_at DESC) WHERE recipient_patient_id IS NOT NULL;
CREATE INDEX idx_credit_transactions_request ON blood_credit_transactions (blood_request_id) WHERE blood_request_id IS NOT NULL;
CREATE INDEX idx_vehicles_blood_bank ON blood_transport_vehicles (blood_bank_id);
CREATE INDEX idx_vehicles_hospital ON blood_transport_vehicles (hospital_id);
CREATE INDEX idx_transfers_origin_bank_status ON blood_unit_transfers (origin_blood_bank_id, status);
CREATE INDEX idx_transfers_origin_hospital_status ON blood_unit_transfers (origin_hospital_id, status);
CREATE INDEX idx_transfers_destination_bank_status ON blood_unit_transfers (destination_blood_bank_id, status);
CREATE INDEX idx_transfers_destination_hospital_status ON blood_unit_transfers (destination_hospital_id, status);
CREATE INDEX idx_transfer_items_blood_unit ON blood_unit_transfer_items (blood_unit_id);
CREATE INDEX idx_messages_recipient_sent ON messages (recipient_user_id, sent_at DESC);
CREATE INDEX idx_messages_request ON messages (blood_request_id) WHERE blood_request_id IS NOT NULL;
CREATE INDEX idx_notifications_user_status ON notifications (user_id, status, queued_at DESC);

 