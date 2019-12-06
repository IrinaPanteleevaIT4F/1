-- Комментарии: нет объяснения, какой софт установить

-- Все нижеуказанные запросы можно запускать при помощи pgAdmin 4.
-- Мы просмотрели все приложенные к заданию таблицы, ознакомились со столбцами и тем, в каких столбцах не допускаются
-- нулевые значения. Мы увидели, что в файлах в столбцах с датами стоят числовые форматы ячеек, поэтому мы изменили формат
-- на формат дат, чтобы данные при импорте отражались корректно. Кроме того, чтобы в принципе импортировать данные, мы
-- поменяли расширение двух из трех файлов с .xlsx на .csv.

-- Создадим таблицу public.ratings с заданными столбцами, предварительно удалив уже существующую версию:
DROP TABLE IF EXISTS public.ratings;

CREATE TABLE public.ratings
(
	"rat_id" integer NOT NULL,
	"grade" text NOT NULL,
	"outlook" text,
	"change" text NOT NULL,
	"date" date NOT NULL,
	"ent_name" text NOT NULL,
	"okpo" bigint NOT NULL,
	"ogrn" bigint,
	"inn" bigint,
	"finst" bigint,
	"agency_id" text NOT NULL,
	"rat_industry" text,
	"rat_type" text NOT NULL,
	"horizon" text,
	"scale_typer" text,
	"currency" text,
	"backed_flag" text
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.ratings
    OWNER to postgres;
    
-- В результате получаем таблицу с нужными нам столбцами, но не заполненную данными.
-- Импортируем в таблицу данные из задания (на MacOS файл предварительно был отправлен в папку /tmp/ во избежании проблем с
-- правами доступа.
    
COPY public.ratings FROM '/tmp/ДЗ 1/ratings_task.csv' DELIMITER ';' CSV HEADER;
	
----
-- Создадим таблицу public.credit_events с заданными столбцами, предварительно удалив уже существующую версию:
DROP TABLE IF EXISTS public.credit_events;

CREATE TABLE public.credit_events
(
	"inn" bigint NOT NULL,
	"date" date NOT NULL,
	"event" text NOT NULL
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.credit_events
    OWNER to postgres;

-- В результате получаем таблицу с нужными нам столбцами, но не заполненную данными.
-- Импортируем в таблицу данные из задания (на MacOS файл предварительно был отправлен в папку /tmp/ во избежании проблем с
-- правами доступа.
    
COPY public.credit_events FROM '/tmp/ДЗ 1/credit_events_task.csv' DELIMITER ';' CSV HEADER;

----
-- Создадим таблицу public.scale_exp с заданными столбцами, предварительно удалив уже существующую версию:
DROP TABLE IF EXISTS public.scale_exp;

CREATE TABLE public.scale_exp
(
	"grade" text NOT NULL,
	"grade_id" integer NOT NULL
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.scale_exp
    OWNER to postgres;
    
-- В результате получаем таблицу с нужными нам столбцами, но не заполненную данными.
-- Импортируем в таблицу данные из задания (на MacOS файл предварительно был отправлен в папку /tmp/ во избежании проблем с
-- правами доступа. Пожалуйста, обратите внимание, что здесь уже нужно задать ENCONDING 'WIN 1251',
-- потому что присутствуют кириллические символы:
    
COPY public.scale_exp FROM '/tmp/ДЗ 1/scale_exp_task.csv' DELIMITER ';' CSV HEADER ENCODING 'WIN 1251';

-- В результате всех запросов мы перенесли полностью данные из файлов с заданиями в библиотеку.

-- Создадим таблицу для выноса информации о РЕЙТИНГЕ:
DROP TABLE IF EXISTS public.ratings_info;

CREATE TABLE public.ratings_info
(
   "rate_num" smallint NOT NULL,
   "rat_id" smallint NOT NULL,
   "agency_id" text NOT NULL,
   "rat_industry" text,
   "rat_type" text,
   "horizon" text,
   "scale_typer" text,
   "currency" text,
   "backed_flag" text,
    CONSTRAINT rate_key PRIMARY KEY ("rate_num")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.ratings_info
    OWNER to postgres;

-- Из таблицы public.ratings (в задании, начиная с пункта 2, она именуется ACTIONS) вынесем необходимую информацию.
-- Кроме того, заметим, что в номинально выносимых из таблицы ratings данных нет первичного ключа (данные в любом столбце
-- повторяются в тех или иных строках), поэтому мы дополнительно создали столбец "rate_num":
INSERT INTO ratings_info SELECT COUNT(*) OVER (ORDER BY "rat_id", "agency_id", "rat_industry", "rat_type", "horizon", 
"scale_typer", "currency", "backed_flag") as rate_num,
"rat_id", "agency_id", "rat_industry", "rat_type", "horizon", "scale_typer", "currency", "backed_flag"
FROM (SELECT DISTINCT "rat_id", "agency_id", "rat_industry", "rat_type", "horizon", "scale_typer", "currency", "backed_flag"
FROM ratings)
AS my_ratings_help;

-- Создадим таблицу для выноса информации о РЕЙТИНГУЕМОМ ЛИЦЕ:
DROP TABLE IF EXISTS public.entity_info;

CREATE TABLE public.entity_info
(
   "ent_num" smallint NOT NULL,
   "ent_name" text,
   "okpo" bigint,
   "ogrn" bigint,
   "inn" bigint,
   "finst" bigint,
    CONSTRAINT entity_key PRIMARY KEY ("ent_num")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.entity_info
    OWNER to postgres;

-- Из таблицы public.ratings (в задании, начиная с пункта 2, она именуется ACTIONS) вынесем необходимую информацию.
-- Кроме того, заметим, что в номинально выносимых из таблицы ratings уже есть первичный ключ "ent_name". Однако "ent_name",
-- как и, например, "inn", является ненадежным первичным ключом, поскольку могут изменяться с течением времени. Поэтому мы
-- создадим новый первичный ключ "ent_num":
INSERT INTO entity_info SELECT COUNT(*) OVER (ORDER BY "ent_name", "okpo", "ogrn", "inn", "finst") AS "ent_num",
"ent_name", "okpo", "ogrn", "inn", "finst"
FROM (SELECT DISTINCT "ent_name", "okpo", "ogrn", "inn", "finst" FROM ratings)
AS my_entity_help;

-- Начнем с таблицы entity_info. Там мы создали новый столбец, который cделали первичным ключом, поскольку столбцы, которые
-- потенциально могли быть первичными ключами ("ent_name", "inn"), оказались ненадежны ввиду возможности их смены. 
-- Таким образом, нужно добавить новый столбец "ent_num" в исходную таблицу ratings (ACTIONS - ее название в задании). 
-- Сделаем данный столбец внешним ключом. Сначала создадим новый столбец в исходной таблице:
ALTER TABLE ratings add column "rate_num" smallint;

-- Далее заполним данный столбец присвоенными значениями из вспомогательной таблицы, созданной в Task 2:
UPDATE ratings
SET "ent_num"=entity_info."ent_num"
FROM entity_info
WHERE ratings."ent_name"=entity_info."ent_name"
  AND ratings."okpo"=entity_info."okpo"
  AND ratings."ogrn"=entity_info."ogrn"
  AND ratings."inn"=entity_info."inn"
  AND ratings."finst"=entity_info."finst";


-- Теперь присвоим полю в исходящей таблице ограничение внешнего ключа:
ALTER TABLE ratings
ADD CONSTRAINT fr_entity_key FOREIGN KEY ("ent_num") REFERENCES entity_info ("ent_num");

-- Убедимся, что полю было присвоено ограничение. Для этого попытаемся добавить в таблицу ratings новую строку с новым
-- ent_num без предварительного обновления таблицы entity_info.
INSERT INTO ratings VALUES (666999, 'yes', 'new', 'surprise', '2066-12-31', 'sunday', 666999, 666999, 666999, 666999, 'coding',
'is', 'really', 'fun', 'no', 'doubts', 'cheers', 666);

-- Получаем ошибку: ERROR:  insert or update on table "ratings" violates foreign key constraint "fr_entity_key".
-- Таким образом, ограничение присвоено корректно.



-- В таблице ratings_info мы создали новый столбец "rate_num", который сделали первичным ключом. Нужно добавить новый столбец
-- в исходную таблицу ratings и сделать его внешним ключом. Аналогично предыдущему действию:
ALTER TABLE ratings add column "rate_num" smallint;

UPDATE ratings
SET "rate_num"=ratings_info."rate_num"
FROM ratings_info
WHERE ratings."rat_id"=ratings_info."rat_id"
  AND ratings."agency_id"=ratings_info."agency_id"
  AND (ratings."rat_industry"=ratings_info."rat_industry"
    OR (ratings."rat_industry" IS NULL AND ratings_info."rat_industry" IS NULL))					
  AND (ratings."rat_type"=ratings_info."rat_type"
    OR (ratings."rat_type" IS NULL AND ratings_info."rat_type" IS NULL))
  AND (ratings."horizon"=ratings_info."horizon"
    OR (ratings."horizon" IS NULL AND ratings_info."horizon" IS NULL))
  AND (ratings."scale_typer"=ratings_info."scale_typer" 
    OR (ratings."scale_typer" IS NULL AND ratings_info."scale_typer" IS NULL))
  AND (ratings."currency"=ratings_info."currency"	 
    OR (ratings."currency" IS NULL AND ratings_info."currency" IS NULL))
  AND (ratings."backed_flag"=ratings_info."backed_flag"
    OR (ratings."backed_flag" IS NULL AND ratings_info."backed_flag" IS NULL));

-- Пожалуйста, обратите внимание, что многие из указанных полей могут быть нулевыми и различаться по данным полям, поэтому
-- мы также указываем, что значение "rate_num" должно учитывать в том числе нулевые значения в полях. Зададим ограничение
-- внешнего ключа:
ALTER TABLE ratings 
ADD CONSTRAINT fr_ratings_key FOREIGN KEY ("rate_num") REFERENCES ratings_info ("rate_num");

-- Убедимся, что полю было присвоено ограничение. Для этого попытаемся добавить в таблицу ratings новую строку с новым
-- ent_num без предварительного обновления таблицы ratings_info.
INSERT INTO ratings VALUES (666999, 'yes', 'new', 'surprise', '2066-12-31', 'sunday', 666999, 666999, 666999, 666999, 'coding',
'is', 'really', 'fun', 'no', 'doubts', 'cheers', 1, 666);

-- Получаем ошибку: ERROR:  insert or update on table "ratings" violates foreign key constraint "fr_ratings_key".
-- Таким образом, ограничение присвоено корректно.

-- Для выполнения задания нужно запросить и объединить две таблицы. Первая таблица должна выводить поля "ent_name",
-- "date" и "grade" из таблицы ratings, исключая те строки, где было снятие или приостановка рейтинга. В подзапросе же мы
-- запросили таблицу, которая содержит "ent_name" и максимальную дату для данного рейтингуемого лица. Когда мы используем
-- комманду INNER JOIN, в результате мы получаем те строки, значения в полях "ent_name" и "date" которых совпадают. Если же 
-- до даты исследования последнее действие было "Снят" или "Приостановлен", запрос проигнорирует и не выдаст следующий
-- результат по данному лицу, поскольку в подзапросе (условно "вторая таблица") фигурирует только максимальная дата, а в
-- "первой таблице" ее не будет вообще, поскольку там было ограничение на "Снят" или "Приостановлен".

SELECT "ent_name", "date" as "assign_date", "grade"
FROM ratings
INNER JOIN (SELECT "ent_name" as "NAME", max("date") as "ASSIGN_DATE"
            FROM ratings
            WHERE "rat_id"=24 AND "date"<='2011-12-31'
            GROUP BY "ent_name"
            ORDER BY "ent_name") AS supp_tab
ON "ent_name"=supp_tab."NAME"
  AND "date"=supp_tab."ASSIGN_DATE"
WHERE "grade"!='Снят' AND "grade"!='Приостановлен'
ORDER BY "ent_name";

-- Менять виды рейтинга и дату исследования можно, задавая различные "rat_id" (вид рейтинга) и "date" (дату исследования) 
-- вместо значений "24" и "2011-12-31" в строке 13 соответственно.


-- Комментарии: а)полнота: по всем пунктам было выполнено задание
-- б) понятность: инструкция написана достаточно подробно, исходя из инструкции очевидно, какой результат выдаст код 
-- в) содержание: все задания выполнены согласно требованиям, однако, в 3 задании не все таблицы связаны между собой
-- г) корректность: форматы полей заданы корректно, но для экономии места в базе данных лучше использовать тип данных наименьшего размера, например, для rat_id достаточно smallint, т.к. там содержатся максимум трехзначные числа; код для создания таблиц выдает ошибку, как только добавляешь ENCONDING, то все работает; смысловых ошибок в коде не обнаружено