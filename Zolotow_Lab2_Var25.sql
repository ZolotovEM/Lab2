Задание 1. Вывести трек-номера для всей корреспонденции, отправленной в конвертах.
SELECT c.tracking_number 
FROM correspondence c
JOIN correspondence_types ct ON c.type_code = ct.type_code
WHERE ct.packaging = 'Конверт';

Задание 2. Вывести виды корреспонденции, для которых средние значения длины, ширины и высоты являются пропорциональными.
SELECT type_code, type_name
FROM correspondence_types
WHERE 
    ((min_length + max_length) / 2.0) = ((min_width + max_width) / 2.0)
    AND 
    ((min_width + max_width) / 2.0) = ((min_height + max_height) / 2.0);

Задание 3. Создать таблицу, содержащую данные 1 запроса с указанием веса, длины, ширины и высоты, а также всей информации о видах корреспонденции.
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

Задание 4. Добавить в созданную таблицу трек-номера посылок, длина, ширина или высота которых выходит за рамки обусловленного диапазона.
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

Задание 5. В созданной таблице для всех посылок, упакованных в конверты и имеющих дробный вес, увеличить все размеры на 1 см.
UPDATE new_correspondence_report
SET 
    length = length + 1,
    width = width + 1,
    height = height + 1
WHERE 
    packaging = 'Конверт' 
    AND MOD(weight, 1) != 0;

Задание 6. Удалить все посылки, трек-номера которых содержат более одного пробела в начале или конце номера.
DELETE FROM new_correspondence_report
WHERE tracking_number ~ '^\s{2,}' OR tracking_number ~ '\s{2,}$';

Задание 7. Посчитать сколько различных видов упаковки использовалось для конвертов, бандеролей и посылок.
SELECT 
    type_name, 
    COUNT(DISTINCT packaging) AS packaging_count
FROM new_correspondence_report
WHERE type_name IN ('Конверт', 'Бандероль', 'Посылка')
GROUP BY type_name;
