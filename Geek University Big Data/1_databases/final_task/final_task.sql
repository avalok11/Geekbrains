/*
Требования к курсовому проекту

1. общее текстовое описание БД и решаемых ею задач
2. минимальное количество таблиц - 10
3. скрипты создания структуры БД (с первичными ключами, индексами, внешними ключами)
4. скрипты наполнения БД данными
5. скрипты характерных выборок (включающие группировки, JOIN'ы, вложенные таблицы)
6. представления (минимум 2)
7. хранимые процедуры / триггеры
8. ...
Примеры: описать модель хранения данных популярного веб-сайта: кинопоиск, booking.com, wikipedia, интернет-магазин, geekbrains, госуслуги...
Думайте об этом задании, как о том, чем Вы похвастаетесь на своем следующем собеседовании.
*/

/* 1. ОПИСАНИЕ БД */
/*
Приложение – кассовая система. 
Задачи выполняемые приожение - поддержка операционной деятельности ресторана.
Функции -
Ограничения расчет с гостями, ведение справочников товаров.
*/

/*
2. Таблицы БД
*/
-- таблица справочник валют (Руб, Евро, Доллар..)
-- таблица справочник номера столов
-- таблица справочник Day Part
-- таблица справочник тип оплаты (наличный, банковская карты, безналичный расчет)
-- таблица справочник канал продаж (здесь, с собой, авто окно, экспресс окно, доставка..)
-- таблица справочник канал заказов (кассир, киоск, веб сайт, мобильное приложение, агрегатор, чат бот..)
-- таблица справочник категорий продуктов (Еда, напитки, алкоголь)
-- таблица справочник групп продуктов (завтра, обед, ужин, специальное меню1…)
-- таблица справочник продукты
-- таблица справочник скидки (скидка постоянным покупателям, скидка свои…)
-- таблица справочник вид операций (продажа, отмена, скидка, удаление, добавление, оплата)
-- таблица справочник Ресторан
-- таблица справочник группы пользователей/сотрудник (админ, директор, менеджер смены, кассир)
-- таблица справочник пользователи/сотрудники
-- таблица заказов/операций (каждое действие с заказом)
-- таблица расчетов (оплата по товарам)
-- таблица логирование опасных операций

/*
3. Создание БД.
4. скрипты наполнения БД данными
*/

drop database if exists superpos;
create database if not exists superpos character set utf8 collate utf8_general_ci;
use superpos;

-- таблица справочник валют (Руб, Евро, Доллар..)
drop table if exists currency;
create table currency(
	id serial primary key,
	`name` varchar(5) comment 'name of currency'
) comment 'currency dictioanry учавствует в оплате';
-- наполнение
insert into currency values
	(NULL, 'RUB'),
    (NULL,'USD');
    
-- таблица справочник номера столов
drop table if exists `table`;
create table `table`(
	id serial primary key,
	`number` int unique comment 'table number',
	capacity int comment 'max guests numbers',
    description nvarchar(50) comment 'table information'
) comment 'table dictioanry учавствует в заказе';
-- наполнение
insert into `table` values
	(NULL, 1, 4, 'family table'),
    (NULL, 2, 8, 'big company'),
    (NULL, 3, 2, 'city view');

-- таблица справочник Day Part
drop table if exists daypart;
create table daypart(
	id serial primary key,
	`name` varchar(25) comment 'day part name',
    priority int comment 'set priority to automotise discount functionality',
	time_from time comment 'start time period',
	time_to time comment 'end time period'
) comment 'day part dictionary проверка на добавления блюда в заказ';
-- наполнение
insert into daypart values
	(NULL, 'breakfast', 1, '07:00', '11:59'),
    (NULL, 'lunch', 2, '12:00', '17:59'),
    (NULL, 'dinner', 3, '18:00', '23:59');

-- таблица справочник тип оплаты (наличный, банковская карты, безналичный расчет)
drop table if exists paytype;
create table paytype(
	id serial primary key,
	`name` varchar(25) comment 'payment type name',
	description nvarchar(100) comment 'addditional information of payments'
) comment 'payment types dictionary расчет оплаты';
-- наполнение
insert into paytype values
	(NULL, 'cash', ''),
    (NULL, 'bank card', '');
    
-- таблица справочник канал продаж (здесь, с собой, авто окно, экспресс окно, доставка..)
drop table if exists saleschannel;
create table saleschannel(
	id serial primary key,
	`name` varchar(25) comment 'sales channel name',
	description nvarchar(100) comment 'sales channel description'
) comment 'sales channel dictionary пометка при оплате';
-- наполнение
insert into saleschannel values
	(null, 'take away', ''),
    (null, 'dinein', ''),
    (null, 'express window', ''),
    (null, 'delivery', '');
    
-- таблица справочник канал заказов (кассир, киоск, веб сайт, мобильное приложение, агрегатор, чат бот..)
drop table if exists orderchannel;
create table orderchannel(
	id serial primary key,
	`name` varchar(25) comment 'order channel name',
	description nvarchar(100) comment 'order channel description'
) comment 'order channel dictionary отметка в заказе';
-- наполнение
insert into orderchannel values
	(null, 'cashier', ''),
    (null, 'mobile application', ''),
    (null, 'self order kiosk', ''),
    (null, 'agregator', '');
    
-- таблица справочник категорий продуктов (Еда, напитки, алкоголь)
drop table if exists category;
create table category(
	id serial primary key,
	`name` varchar(25) comment 'category name',
	description nvarchar(100) comment 'category description'
) comment 'cattegory dictionary относится к продукту';
-- наполнение
insert into category values
	(null, 'food', ''),
    (null, 'beverage', ''),
    (null, 'juce', ''),
    (null, 'desserts', '');

-- таблица справочник групп продуктов (завтра, обед, ужин, специальное меню1…)
drop table if exists `group`;
create table `group`(
	id serial primary key,
	`name` varchar(25) comment 'group name',
    daypart_id bigint unsigned comment 'group of products must be related to day part',
	description nvarchar(100) comment 'group description',
    constraint fk_daypart_id foreign key (daypart_id) references daypart (id) on delete set null on update cascade
) comment 'product group dictionary относится к продукту и учитывается при заказе';


-- таблица справочник продукты
drop table if exists product;
create table product(
	id serial primary key,
	`name` varchar(25) comment 'product name',
    group_id bigint unsigned,
    category_id bigint unsigned,
    price decimal(11,2) comment 'price of product',
	description nvarchar(100) comment 'category description',
    constraint fk_group_id foreign key (group_id) references `group` (id) on delete set null on update cascade,
    constraint fk_category_id foreign key (category_id) references `category` (id) on delete set null on update cascade
) comment 'sales cheannel dictionary учавствует в заказе';
-- таблица справочник скидки (скидка постоянным покупателям, скидка свои…)
drop table if exists discount;
create table discount(
	id serial primary key,
	`name` varchar(25) comment 'discount name',
	description nvarchar(100) comment 'discount description'
) comment 'discount dictionary учавствует в оплате';
-- таблица справочник вид операций (продажа, отмена, скидка, удаление, добавление, оплата, стол)
drop table if exists transactiontype;
create table transactiontype(
	id serial primary key,
	`name` varchar(25) comment 'transaction name',
	description nvarchar(100) comment 'transaction description'
) comment 'transaction types dictionary учавствует в заказе';
-- таблица справочник пользователи/сотрудники
drop table if exists useroles;
create table userroles(
	id serial primary key,
	`name` varchar(150) comment 'group/role name',
	description nvarchar(254) comment 'group description'
) comment 'group dictionary учавствует и в заказе и в оплате';
-- таблица справочник группы пользователей/сотрудник (админ, директор, менеджер смены, кассир)
drop table if exists users;
create table users(
	id serial primary key,
	`fname` nvarchar(150) comment 'first name',
    `lname` nvarchar(150) comment 'last name',
    `sname` nvarchar(150) comment 'second name',
    userroles_id bigint unsigned,
    identificationid nvarchar(50)  comment 'account number',
    usrpwd varchar(40),
	description nvarchar(254) comment 'users description',
    constraint fk_userroles_id foreign key (userroles_id) references userroles (id) on delete set null on update cascade
) comment 'user dictionary и в заказе и в оплате';
-- таблица заказов/операций (каждое действие с заказом)
create table `order`(
	id serial primary key,
    orderid int not null comment 'order number',
    datetime_at datetime, 
    product_id bigint unsigned,
    transactiontype_id bigint unsigned,
    users_id bigint unsigned,
    constraint fk_product_id foreign key (product_id) references product (id) on delete no action on update no action,
    constraint fk_transactiontype_id foreign key (transactiontype_id) references transactiontype (id) on delete no action on update no action,
    constraint fk_users_id foreign key (users_id) references `users` (id) on delete no action on update no action
) comment 'order operation';
-- таблица расчетов (оплата по товарам)
create table payments(
	id serial primary key,
    paymentid int not null comment 'payment number',
    datetime_at datetime, 
    amount decimal(11,2),
    order_id bigint unsigned,
    saleschannel_id bigint unsigned,
    orderchannel_id bigint unsigned,
    constraint fk_order_id foreign key (order_id) references `order` (id) on delete no action on update no action,
    constraint fk_saleschannel_id foreign key (saleschannel_id) references saleschannel (id) on delete no action on update no action,
    constraint fk_orderchannel_id foreign key (orderchannel_id) references orderchannel (id) on delete no action on update no action
) comment 'payment operation';
-- таблица логирование опасных операций
create table operation(
	id serial primary key,
    datetime_at datetime,
    users_id bigint unsigned,
    order_id bigint unsigned,
    transactiontype_id bigint unsigned,
    constraint fk_users_operation_id foreign key (users_id) references `users` (id) on delete no action on update no action,
    constraint fk_order_operation_id foreign key (order_id) references `order` (id) on delete no action on update no action,
    constraint fk_transactiontype_operation_id foreign key (transactiontype_id) references transactiontype (id) on delete no action on update no action
)

/*
4. скрипты наполнения БД данными
*/

