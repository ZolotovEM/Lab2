DROP TABLE IF EXISTS new_correspondence_report;

SELECT 
    c.tracking_number,
    c.weight,
    c.length,
    c.width,
    c.height,
    ct.type_code,
    ct.type_name,
    ct.packaging,
    ct.min_weight,
    ct.max_weight,
    ct.min_length,
    ct.max_length,
    ct.min_width,
    ct.max_width,
    ct.min_height,
    ct.max_height
INTO new_correspondence_report
FROM correspondence c
JOIN correspondence_types ct ON c.type_code = ct.type_code
WHERE ct.packaging = 'Конверт';