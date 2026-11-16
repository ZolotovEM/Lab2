UPDATE new_correspondence_report
SET 
    length = length + 1,
    width = width + 1,
    height = height + 1
WHERE 
    packaging = 'Конверт' 
    AND MOD(weight, 1) != 0;