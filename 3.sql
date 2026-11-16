SELECT 
    type_name, 
    COUNT(DISTINCT packaging) AS packaging_count
FROM new_correspondence_report
WHERE type_name IN ('Конверт', 'Бандероль', 'Посылка')
GROUP BY type_name;