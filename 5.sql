INSERT INTO new_correspondence_report (
    tracking_number, weight, length, width, height, 
    type_code, type_name, packaging, min_weight, max_weight, 
    min_length, min_width, min_height, max_length, max_width, max_height
)
SELECT 
    c.tracking_number, c.weight, c.length, c.width, c.height,
    ct.type_code, ct.type_name, ct.packaging, ct.min_weight, ct.max_weight,
    ct.min_length, ct.min_width, ct.min_height, ct.max_length, ct.max_width, ct.max_height
FROM correspondence c
JOIN correspondence_types ct ON c.type_code = ct.type_code
WHERE ct.type_name = 'Посылка' 
  AND (
      c.length > ct.max_length OR c.length < ct.min_length OR
      c.width > ct.max_width OR c.width < ct.min_width OR
      c.height > ct.max_height OR c.height < ct.min_height
  )
  AND NOT EXISTS (
      SELECT 1 FROM new_correspondence_report n 
      WHERE n.tracking_number = c.tracking_number
  );