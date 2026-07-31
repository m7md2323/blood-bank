SET search_path TO smart_blood_bank;

-- Views
CREATE VIEW vw_inventory_summary AS
SELECT
    COALESCE(bb.name, h.name) AS organization_name,
    CASE WHEN bu.current_blood_bank_id IS NOT NULL THEN 'blood_bank' ELSE 'hospital' END AS organization_type,
    bu.current_blood_bank_id,
    bu.current_hospital_id,
    bu.blood_type,
    bu.status,
    count(*) AS unit_count
FROM blood_units bu
LEFT JOIN blood_banks bb ON bb.blood_bank_id = bu.current_blood_bank_id
LEFT JOIN hospitals h ON h.hospital_id = bu.current_hospital_id
GROUP BY COALESCE(bb.name, h.name), organization_type, bu.current_blood_bank_id, bu.current_hospital_id, bu.blood_type, bu.status;
 
CREATE VIEW vw_open_blood_requests AS
SELECT
    br.blood_request_id,
    h.name AS hospital_name,
    br.blood_type,
    br.units_requested,
    count(a.allocation_id) AS units_allocated,
    br.units_requested - count(a.allocation_id) AS units_remaining,
    br.priority,
    br.status,
    br.needed_by,
    br.created_at
FROM blood_requests br
JOIN hospitals h ON h.hospital_id = br.hospital_id
LEFT JOIN blood_request_allocations a ON a.blood_request_id = br.blood_request_id
WHERE br.status IN ('submitted', 'searching_donors', 'partially_fulfilled')
GROUP BY br.blood_request_id, h.name;