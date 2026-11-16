DELETE FROM new_correspondence_report
WHERE tracking_number ~ '^\s{2,}' OR tracking_number ~ '\s{2,}$';