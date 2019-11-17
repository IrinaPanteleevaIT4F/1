ШАГ 1. Установка программного обеспечения 

Для работы с базами данных необходимо установить  Систему Управления Базами Данных (СУБД).

Одна из таких СУБД – PostgreSQL

Для начала необходимо скачать, перейдя по ссылке https://www.enterprisedb.com/downloads/postgres-postgresql-downloads; 

Выбираете последнюю версию СУБД, подходящую вашей операционной системе. 

При установке вводите и подтверждаете пароль для базы данных (необходимо запомнить пароль, поскольку его придется вводить каждый раз при запуске СУБД)

Остальные параметры при установке остаются по умолчанию, кроме предложения установить компоненты Stack Builder, это предложение отклоняется (необходимо снять галочку напротив компоненты Stack Builder)

Для запуска СУБД необходимо перейти к списку программ на вашем компьютере и запустить pgAdmin (синяя слоновая морда), в качестве графической среды используется установленный вами по умолчанию интернет-браузер. Также можно использовать командную строку SQL Shell (psql).

Результат шага 1: установлено программное обеспечение



ШАГ 2. Обработка данных 

Если данные получены в формате .xlsx необходимо проверить сами данные на их корректность представления

1. Открыть файл с данными 

2. Проверить формат данных в ячейках

Например, столбец “rat_id” включает в себя значения ячейк, которые относятся к формату «общий», поскольку этим данным изначально присвоен формат данных «общий», то нет необходимость что-то изменять 

Если формат данных соответствует значениям внутри ячейк, то переходим к следующему столбцу

Там образом, столбцы “grade”, “outlook”, “change”, “ent_name”, “agency_id”,  “rat_industry”,  “rat_type”, “horizon”, “scale_typer”, “currency”, “backed_flag” содержат текстовую информацию, соответственно им должен быть присвоен формат данных «общий»

Столбец “date” содержит информацию о дате, значит необходимо присвоить формат данных «дата»

Столбцы “okpo”, “ogrn”,  “inn”,  “finst” содержат числовую информацию, соответственно, формат данных – числовой 

3. Необходимо убедиться, что исходный файл содержит только один лист с данными, при обнаружении других листов необходимо переместить все остальные листы в другой документ. 

Таким образом, лист “fields” перемещается в новый документы

3. После того, как данные обработаны, необходимо сохранить этот файл в формате csv. 
Файл-сохранить как-формат файла-csv

Шаг 2 необходимо повторить столько раз, сколько документов будет внесено в СУБД.

Результат шага 2: данные отформатированы соответствующим образом для дальнейшей работы с ними в СУБД




ШАГ 3. Создание таблицы в Postgresql

1.Открываем Postgresql, вводим пароль(который был введен при установке СУБД)

2.Нажимаем на иконку “Servers”,которая расположена в верхней левой части экрана далее кликаем на иконку слона, кликаем на “databases”. 

3.В верхней левой части экрана кликаем на иконку молнии, открывается окно, где вводятся запросы 

4.Создание таблицы с помощью скрипта

Пояснение процесса создание таблицы 

Наименование столбцов задается в двойных кавычках заглавными буквами, тип данных выбирается исходя из данных в документе. 

Так, для столбцов  “grade”, “outlook”, “change”, “ent_name”, “agency_id”,  “rat_industry”,  “rat_type”, “horizon”, “scale_typer”, “currency”, “backed_flag” подходящий тип данных – text; для столбца “date” – date; для столбцов “okpo”- integer, “ogrn”- bigint,  “inn” - bigint,  “finst” – integer.

Аналогично создаются таблицы credit_events1 и scale_EXP_task1

Результат шага 3: созданы три таблицы (rating_task1, credit_events1, scale_EXP_task1)


СКРИПТЫ для ШАГА 3.

CREATE TABLE public.rating_task1

(
    "RAT_ID" smallint NOT NULL,

    "GRADE" text COLLATE pg_catalog."default",

    "OUTLOOK" text COLLATE pg_catalog."default",

    "CHANGE" text COLLATE pg_catalog."default",

    "DATE" date,

    "ENT_NAME" text COLLATE pg_catalog."default",

    "OKPO" integer,

    "OGRN" bigint,

    "INN" bigint,

    "FINST" integer,

    "AGENCY_ID" text COLLATE pg_catalog."default",

    "RAT_INDUSTRY" text COLLATE pg_catalog."default",

    "RAT_TYPE" text COLLATE pg_catalog."default",

    "HORIZON" text COLLATE pg_catalog."default",

    "SCALE_TYPER" text COLLATE pg_catalog."default",
	
    "CURRENCY" text COLLATE pg_catalog."default",

    "BACKED_FLAG" text COLLATE pg_catalog."default",

)

WITH (

    OIDS = FALSE

)

TABLESPACE pg_default;

ALTER TABLE public.rating_task1

    OWNER to postgres;




CREATE TABLE public.credit_events1

(

    "INN" bigint,

    "DATE" date,

    "EVENT" text COLLATE pg_catalog."default"

)

WITH (

    OIDS = FALSE

)

TABLESPACE pg_default;


ALTER TABLE public.credit_events1

    OWNER to postgres;




CREATE TABLE public."scale_EXP_task1"

(

    "GRADE" text COLLATE pg_catalog."default",

    "GRADE_ID" text COLLATE pg_catalog."default"

)

WITH (

    OIDS = FALSE

)

TABLESPACE pg_default;


ALTER TABLE public."scale_EXP_task1"

    OWNER to postgres;

 



Шаг 4. Импортирование данных из csv файла в созданную таблицу 

1.Кликаем правой кнопкой мыши по таблице, куда необходимо импортировать данные 
Кликаем по строчке IMPORT/EXPORT 

2.Открывается окно 

Для импортирования необходимо сдвинуть ползунок, теперь отображается IMPORT

Далее выбираем файл, переходя в папку, где находится документ в формате csv, который необходимо импортировать  

ФОРМАТ уже автоматически установлен csv

ENCONDING выбираем WIN1251 

HEADER сдвигаем ползунок на YES

DELIMITER выбираем исходя из того, как сохраняется информация в csv файл на компьютере (чаще всего, сохраняется с делимитром ; )

Соответственно, DELIMITER ; 

Нажимаем ОК 

3.Если все подгрузилось, то СУБД напишет, что все успешно загружено в правом нижнем всплывающем окне 

Если появляется ошибка, то надо читать какого рода ошибка и исправлять данные/таблицу

4.Если все успешно, то кликаем правой кнопкой мыши по названию таблицы, которое отображается слева в списке 

Нажимаем на строчку REFRESH 

Кликаем еще раз по таблице 

Кликаем по строчке VIEW/EDIT DATA… .All rows

5.В итоге СУБД отображает таблицу с импортированными данными 


Шаг 4 необходимо повторить для всех таблиц, созданных на шаге 3.

Результат шага 4: загружены все данные в соответствующие таблицы, СУБД отображает данные в соответствующих столбцах



ШАГ 5. Создание отдельной таблицы для информации о рейтингах (rating_info) и создание отдельной таблицы для информации о рейтингуемом лице(company_info)

Для выполнения этого шага необходимо повторить аналогичные действия, как в шаге 3.

Результат шага 5: созданы таблицы с информацией о рейтингах и рейтингуемых компаниях


СКРИПТЫ для ШАГА 5.

CREATE TABLE public.rating_info

(

    "AGENCY_ID" text COLLATE pg_catalog."default",

    "RAT_INDUSTRY" text COLLATE pg_catalog."default",

    "RAT_TYPE" text COLLATE pg_catalog."default",

    "HORIZON" text COLLATE pg_catalog."default",

    "SCALE_TYPER" text COLLATE pg_catalog."default",

    "CURRENCY" text COLLATE pg_catalog."default",

    "BACKED_FLAG" text COLLATE pg_catalog."default"

)

WITH (

    OIDS = FALSE

)

TABLESPACE pg_default;


ALTER TABLE public.rating_info

    OWNER to postgres;



CREATE TABLE public.company_info

(

    "COMPANY_ID" bigint NOT NULL,

    "ENT_NAME" text COLLATE pg_catalog."default",

    "OKPO" integer,

    "OGRN" bigint,

    "INN" bigint,

    "FINST" integer,

    CONSTRAINT company_info_pkey PRIMARY KEY ("COMPANY_ID")

)

WITH (

    OIDS = FALSE

)

TABLESPACE pg_default;


ALTER TABLE public.company_info

    OWNER to postgres;




ШАГ 6. Перенесение данных из таблицы rating_task1 в rating_info

Результат шага 6: в таблицу rating_info перенесены данные в соответствующие столбцы

СКРИПТ для  ШАГА 6.

INSERT INTO rating_info ("AGENCY_ID", "RAT_INDUSTRY", "RAT_TYPE", "HORIZON", "SCALE_TYPER", "CURRENCY", "BACKED_FLAG")

SELECT "AGENCY_ID", "RAT_INDUSTRY", "RAT_TYPE", "HORIZON", "SCALE_TYPER", "CURRENCY", "BACKED_FLAG"

FROM rating_task1




ШАГ 7. Перенесение данных из таблицы rating_task1 в company_info

Пояснение к скрипту

Поскольку, одна и та же компания имеет различные рейтинги в таблице rating_task1, то при переносе данных из этой таблицы в таблицу company_info, произойдет дублирование информации о компании. 

Для того, чтобы этого не случилось необходимо применить OVER. 

OVER - нумерует уникальные группы значений, находит группы одинаковых строк, в выводе запроса одинаковые строки объединяет

Использование SELECT DISTINCT обусловлено тем, что необходимо сгруппировать данные по уникальному значению в одной строке. 

Результат шага 7: сгруппированы и пронумерованы рейтингуемые компании, информация о них перенесена в соответствующие столбцы

СКРИПТ для ШАГА 7.

INSERT INTO company_info 

SELECT COUNT(*) OVER (ORDER BY "ENT_NAME", "OKPO", "OGRN", "INN", "FINST") as COMPANY_ID, "ENT_NAME", "OKPO", "OGRN", "INN", "FINST"

FROM (SELECT DISTINCT "ENT_NAME", "OKPO", "OGRN", "INN", "FINST"

FROM rating_task1)

AS my_select;




ШАГ 8. Связывание таблиц в базе данных через внешние ключи

Пояснение к скрипту 

Добавляется в исходную таблицу поля с кодами-ссылками на новую таблицу

Затем заполняется поле с кодами-ссылками на новую таблицуи после присваивается полю ограничение внешнего ключа

Результат шага 8: связаны базы данных через внешний ключ 


СКРИПТ для ШАГА 8.

ALTER TABLE rating_task1 ADD COLUMN "COMPANY_ID" bigint;




UPDATE rating_task1

SET "COMPANY_ID"=company_info."COMPANY_ID"

FROM company_info

WHERE rating_task1."ENT_NAME"=company_info."ENT_NAME";




ALTER TABLE public.rating_task1

ADD CONSTRAINT fr_key_1 FOREIGN KEY ("COMPANY_ID") 

REFERENCES public.company_info ("COMPANY_ID");


ШАГ 9. Создание запроса, который выводит для выбранных вида рейтинга и даты все актуальные рейтинги.

Пояснение к скрипту 

Необходимо объединить несколько запросов с помощью INNER JOIN 

SELECT rating_task1."ENT_NAME", rating_task1."GRADE", rating_task1."DATE"

FROM rating_task1

INNER JOIN (SELECT "ENT_NAME", "GRADE", MAX("DATE") AS "ASSIGN_DATE"

		   FROM rating_task1

		   GROUP BY "ENT_NAME", "GRADE")

p ON rating_task1."ENT_NAME" = p."ENT_NAME" 

AND rating_task1."GRADE" = P."GRADE"

AND rating_task1."DATE"=p."ASSIGN_DATE"

WHERE ("CHANGE" != 'снят' AND "CHANGE" != 'приостановлен') AND "RAT_ID" = 27


Если необходимо выбрать другой тип рейтинга, то значение 27 в строчке "RAT_ID" заменяется на необходимое.


Результат шага 9: данный запрос покажет список компаний с рейтингом на последнюю дату, предшествующую текущей дате при условии, что рейтинг не был "снят" или "приостановлен".




