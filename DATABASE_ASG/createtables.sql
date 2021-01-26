-- Create fresh database
USE master

IF EXISTS(SELECT * FROM sys.databases WHERE name='MokeFoodDelivery')
DROP DATABASE MokeFoodDelivery
GO

CREATE DATABASE MokeFoodDelivery
GO

USE MokeFoodDelivery
GO


-- Create tables
CREATE TABLE Business  
(  
bizID     char(5)		 NOT NULL,  
bizName   varchar(256)   NOT NULL,  

CONSTRAINT PK_Business PRIMARY KEY (bizID)  
)  

CREATE TABLE Zone  
(  
zoneID     char(5)       NOT NULL,  
zoneName   varchar(32)   NOT NULL,  

CONSTRAINT PK_Zone PRIMARY KEY (zoneID)  
)  
 
CREATE TABLE Outlet  
(  
outletID           char(5)       NOT NULL,  
outletName         varchar(256)  NOT NULL,  
address            varchar(256)  NULL,  
openTime           time          NULL,  
closeTime          time          NULL,  
startDeliveryTime  time          NULL,  
endDeliveryTime    time          NULL,  
bizID              char(5)       NOT NULL,  
zoneID             char(5)       NOT NULL,  

CONSTRAINT PK_Outlet PRIMARY KEY (outletID),  
CONSTRAINT FK_Business_bizID FOREIGN KEY (bizID) REFERENCES Business(bizID),  
CONSTRAINT FK_Zone_zoneID FOREIGN KEY (zoneID) REFERENCES Zone(zoneID),  
)  
 
CREATE TABLE OutletContact  
(  
outletID     char(5)     NOT NULL,  
contactNo    char(8)     NOT NULL,  

CONSTRAINT PK_OutletContact PRIMARY KEY (outletID, contactNo),  
CONSTRAINT FK_OutletContact_outletID FOREIGN KEY (outletID) REFERENCES Outlet(outletID)  
)  
 
CREATE TABLE Cuisine  
(  
cuisineID     char(5)        NOT NULL,  
cuisineName   varchar(128)   NOT NULL,  

CONSTRAINT PK_Cuisine PRIMARY KEY (cuisineID)  
)  
 
CREATE TABLE OutletCuisines   
(  
outletID     char(5)     NOT NULL,  
cuisineID    char(5)     NOT NULL,  

CONSTRAINT PK_OutletCuisines PRIMARY KEY (outletID, cuisineID),  
CONSTRAINT FK_Outlet_outletID FOREIGN KEY (outletID) REFERENCES Outlet(outletID),  
CONSTRAINT FK_Cuisine_cuisineID FOREIGN KEY (cuisineID) REFERENCES Cuisine(cuisineID)  
)
 
CREATE TABLE Promotion  
(  
promoID char(5)         NOT NULL,  
promoName varchar(100)  NOT NULL,  
promoDesc varchar(200)  NULL,  
isFreeDelivery char(1)  NULL,  
percentDiscount float NULL,  

CONSTRAINT PK_Promotion PRIMARY KEY (promoID),
CONSTRAINT CHK_isFreeDelivery CHECK (isFreeDelivery IN ('Y','N'))
)  
 
CREATE TABLE OutletPromotions   
(  
outletID char(5) NOT NULL,  
promoID char(5) NOT NULL,   
maxCount int NULL,   

CONSTRAINT PK_OutletPromotions PRIMARY KEY NONCLUSTERED (outletID, promoID),  
CONSTRAINT FK_OutletPromotions_outletID FOREIGN KEY (outletID) REFERENCES Outlet(outletID),  
CONSTRAINT FK_OutletPromotions_promoID FOREIGN KEY (promoID) REFERENCES Promotion(promoID)  
)  

CREATE TABLE Menu
(  
outletID   char(5)       NOT NULL,  
menuNo     int NOT       NULL,  
menuName   varchar(50)   NOT NULL,

CONSTRAINT PK_Menu PRIMARY KEY NONCLUSTERED (outletID, menuNo),  
CONSTRAINT FK_Menu_outletID FOREIGN KEY (outletID) REFERENCES Outlet(outletID)  
)  
 
CREATE TABLE Item   
(  
itemID     char(5)        NOT NULL,  
itemName   varchar(100)   NOT NULL,  
itemDesc   varchar(200)   NULL,  
itemPrice  float          NULL, 

CONSTRAINT PK_Item PRIMARY KEY (itemID)  
)  

CREATE TABLE MenuItem   
(  
outletID   char(5)  NOT NULL,  
menuNo     int      NOT NULL,  
itemID     char(5)  NOT NULL, 

CONSTRAINT PK_MenuItem PRIMARY KEY NONCLUSTERED (outletID, menuNo, itemID),
CONSTRAINT FK_MenuItem_outletID_menuNo FOREIGN KEY (outletID, menuNo) REFERENCES Menu(outletID, menuNo),  
CONSTRAINT FK_MenuItem_itemID FOREIGN KEY (itemID) REFERENCES Item(itemID)  
)  

CREATE TABLE Award  
(  
awardID     char(5)       NOT NULL,  
awardName   varchar(200)  NULL,  
awardType   varchar(100)  NULL,

CONSTRAINT PK_Award PRIMARY KEY (awardID)
)  

CREATE TABLE AwardsWon
(  
awardID   char(5)   NOT NULL,  
riderID   char(5)   NOT NULL,  
winDate   datetime  NOT NULL, 

CONSTRAINT PK_AwardsWon PRIMARY KEY NONCLUSTERED (winDate, awardID, riderID),  
CONSTRAINT FK_AwardsWon_awardID FOREIGN KEY (awardID) REFERENCES Award(awardID)
)  
 
Create TABLE Team  
(  
teamID     char(5)       NOT NULL,  
teamName   varchar(200)  NULL,  
awardID    char(5)       NULL,  
leaderID   char(5)       NULL,

CONSTRAINT PK_Team PRIMARY KEY (teamID),  
CONSTRAINT FK_Team_awardID FOREIGN KEY (awardID) REFERENCES Award(awardID)
)  
 
CREATE TABLE Rider   
(  
riderID        char(5)         NOT NULL,  
riderNRIC      char(9)         NOT NULL,  
riderName      varchar(100)    NOT NULL,  
riderContact   char(8)         NULL,  
riderAddress   varchar(200)    NULL,  
riderDOB       datetime        NULL,  
deliveryMode   varchar(50)     NULL,  
teamID         char(5)         NOT NULL,  

CONSTRAINT PK_Rider PRIMARY KEY (riderID) 
)    


CREATE TABLE Equipment
(  
equipID       char(5)        NOT NULL,  
equipName     varchar(200)   NULL,  
equipPrice    float          NULL,  
setID         char(5)        NULL,

CONSTRAINT PK_Equipment PRIMARY KEY (equipID),  
CONSTRAINT FK_Equipment_setID FOREIGN KEY (setID) REFERENCES Equipment(equipID),  
)
 

CREATE TABLE EquipmentPurchase  
(  
riderID            char(5)    NOT NULL,  
equipID            char(5)    NOT NULL,  
purchaseDateTime   datetime   NOT NULL,  
purchaseQty        int        NULL,  

CONSTRAINT PK_EquipmentPurchase PRIMARY KEY NONCLUSTERED (purchaseDateTime, riderID, equipID),  
CONSTRAINT FK_EquipmentPurchase_riderID FOREIGN KEY (riderID) REFERENCES Rider(riderID),  
CONSTRAINT FK_EquipmentPurchase_equipID FOREIGN KEY (equipID) REFERENCES Equipment(equipID)  
)  


CREATE TABLE Customer
(   
CustID        char(5)        NOT NULL,  
custName      varchar(100)   NOT NULL,  
custAddress   varchar (200)  NULL,  
custContact   char(8)        NULL,  
custEmail     varchar(100)   NULL,  

CONSTRAINT PK_Customer PRIMARY KEY (custID)  
) 
 

CREATE TABLE Voucher
(  
voucherID            char(5)       NOT NULL,  
voucherStatus        char(1)       NULL,
voucherDescription   varchar(200)  NOT NULL,  
startDate            dateTime      NOT NULL,  
expiryDate           dateTime      NOT NULL,  
minOrder             float         NULL,  
dollarValue          float         NOT NULL,  
custID               char(5)       NOT NULL,

CONSTRAINT PK_Voucher PRIMARY KEY (voucherID),  
CONSTRAINT FK_Voucher_custID FOREIGN KEY (custID) REFERENCES Customer(custID),  
CONSTRAINT CHK_expiryDate CHECK (expiryDate > startDate),
CONSTRAINT CHK_voucherStatus CHECK (voucherStatus IN ('R','N'))
) 


CREATE TABLE CustOrder
(  
orderID        char(5)     NOT NULL,  
orderStatus    char(1)     NULL,  
custID         char(5)     NOT NULL,  
voucherID      char(5)     NOT NULL,  
outletID       char(5)     NOT NULL,  

CONSTRAINT PK_CustOrder PRIMARY KEY (OrderID),  
CONSTRAINT FK_CustOrder_custID FOREIGN KEY (custID) REFERENCES Customer(custID),  
CONSTRAINT FK_CustOrder_voucherID FOREIGN KEY (voucherID) REFERENCES Voucher(voucherID),  
CONSTRAINT FK_CustOrder_outletID FOREIGN KEY (outletID) REFERENCES Outlet(outletID),
CONSTRAINT CHK_orderStatus CHECK (orderStatus IN ('D','N'))  
)
 

CREATE TABLE Payment
(  
pmtID      char(5)        NOT NULL,  
pmtMode    varchar(100)   NOT NULL,  
pmtType    varchar(100)   NOT NULL,  
pmtAmt     float          NOT NULL,  
orderID    char(5)        NOT NULL,  
PRIMARY KEY (pmtID),  
CONSTRAINT FK_Payment_orderID FOREIGN KEY (orderID) REFERENCES CustOrder(orderID),  
) 
 

CREATE TABLE OrderItem
(  
orderID      char(5)  NOT NULL,  
itemID       char(5)  NOT NULL,  
orderQty     int      NOT NULL,  
unitPrice    float    NOT NULL,  
CONSTRAINT PK_OrderItem PRIMARY KEY (orderID, itemID),  
CONSTRAINT FK_OrderItem_orderID FOREIGN KEY (orderID) REFERENCES CustOrder(orderID),  
CONSTRAINT FK_OrderItem_itemID FOREIGN KEY (itemID) REFERENCES Item(itemID) 
)
 

CREATE TABLE OrderPromotions  
(  
orderID   Char(5)  NOT NULL,  
promoID   Char(5)  NOT NULL,  
CONSTRAINT PK_OrderPromotions PRIMARY KEY NONCLUSTERED (orderID, promoID),  
CONSTRAINT FK_OrderPromotions_orderID FOREIGN KEY (orderID) REFERENCES CustOrder(orderID),  
CONSTRAINT FK_OrderPromotions_promoID FOREIGN KEY (promoID) REFERENCES Promotion(promoID)  
)  
 

CREATE TABLE Pickup  
(  
orderID           char(5)       NOT NULL,  
pickupRefNo      varchar(50)   NOT NULL,  
pickupDateTime   dateTime      NULL,  

CONSTRAINT PK_Pickup PRIMARY KEY (orderID),  
CONSTRAINT FK_Pickup_orderID FOREIGN KEY (orderID) REFERENCES CustOrder (orderID)  
)  

 
CREATE TABLE Delivery  
(  
orderID           char(5)        NOT NULL,  
deliveryDateTime  dateTime       NULL,  
deliveryAddress   varchar(256)   NOT NULL,  
riderID           char(5)        NOT NULL,  
CONSTRAINT PK_Delivery PRIMARY KEY (orderID),  
CONSTRAINT FK_Delivery_orderID  
FOREIGN KEY (orderID) REFERENCES CustOrder (orderID),  
CONSTRAINT FK_Delivery_riderID  
FOREIGN KEY (riderID) REFERENCES Rider (riderID)  
)


CREATE TABLE DeliveryAssignment  
(  
orderID   Char(5)       NOT NULL,  
riderID   Char(5)       NOT NULL,  
Status    varchar(50)   NULL,  
CONSTRAINT PK_DeliveryAssignment PRIMARY KEY  
NONCLUSTERED (orderID, riderID),  
CONSTRAINT FK_DeliveryAssignment_orderID  
FOREIGN KEY (orderID) REFERENCES CustOrder(orderID),  
CONSTRAINT FK_DeliveryAssignment_riderID  
FOREIGN KEY (riderID) REFERENCES Rider (riderID)  
)	


ALTER TABLE Team
ADD CONSTRAINT FK_Team_leaderID FOREIGN KEY (leaderId) REFERENCES Rider(riderID)
ALTER TABLE Rider 
ADD CONSTRAINT FK_Rider_TeamID FOREIGN KEY (teamID) REFERENCES Team(teamID) 

-- Business
INSERT INTO Business VALUES ('B001', 'OogaBooga Cooperation')
INSERT INTO Business VALUES ('B002', 'OnlyAirConditioner PTE LTD') 
INSERT INTO Business VALUES ('B003', 'Mofo Cooperation') 
INSERT INTO Business VALUES ('B004', 'Mutsibushu Pte Ltd') 
INSERT INTO Business VALUES ('B005', 'Tender Chicken Corporation') 
INSERT INTO Business VALUES ('B006', 'Nontendo Pte Ltd')
INSERT INTO Business VALUES ('B007', 'ThiccPatties Pte Ltd') 
INSERT INTO Business VALUES ('B008', 'Asumi Cooperation')  
INSERT INTO Business VALUES ('B009', 'Jacob Black Pte Ltd') 
INSERT INTO Business VALUES ('B010', 'NeinNeinNein Pte Ltd')


-- Zone
INSERT INTO Zone VALUES ('Z001', 'North') 
INSERT INTO Zone VALUES ('Z002', 'South') 
INSERT INTO Zone VALUES ('Z003', 'East') 
INSERT INTO Zone VALUES ('Z004', 'West')


-- Outlet NOT DONE


-- OutletContact NOT DONE


-- Cuisine
INSERT INTO Cuisine VALUES ('CS001', 'Chinese') 
INSERT INTO Cuisine VALUES ('CS002', 'Thai') 
INSERT INTO Cuisine VALUES ('CS003', 'Malay') 
INSERT INTO Cuisine VALUES ('CS004', 'Western') 
INSERT INTO Cuisine VALUES ('CS005', 'Korean') 
INSERT INTO Cuisine VALUES ('CS006', 'Japanese') 
INSERT INTO Cuisine VALUES ('CS007', 'Mexican') 
INSERT INTO Cuisine VALUES ('CS08', 'Vietnamese') 
INSERT INTO Cuisine VALUES ('CS09', 'Singaporean') 
INSERT INTO Cuisine VALUES ('CS10', 'Indian')


-- OutletCuisines NOT DONE


-- Promotion
INSERT INTO Promotion VALUES ('P001', 'New Year Promotion', 'New Year, New Discounts! Available for first purchase of the year', 'N', 20.21)
INSERT INTO Promotion VALUES ('P002', 'CNY Promotion', 'Happy Chinese New Year!', 'N', 8.88)
INSERT INTO Promotion VALUES ('P003', 'Valentines Discount ', 'Have an enjoyable Valentines in the comfort of your own home', 'Y', 2.14)
INSERT INTO Promotion VALUES ('P004', 'Easter Promotion ', 'Eggcellent discounts, while stocks last', 'N', 10)
INSERT INTO Promotion VALUES ('P005', 'Labour Day Promotion ', 'Time to take a break with our Labour Day discounts', 'N', 10)
INSERT INTO Promotion VALUES ('P006', 'Hari Raya Puasa Promotion', 'Selamat Hari Raya! ', 'Y', 10)
INSERT INTO Promotion VALUES ('P007', 'Deepavali Promotion', 'Happy Diwali!', 'Y', 10)
INSERT INTO Promotion VALUES ('P008', 'National Day Promotion', 'Happy 56th Birthday Singapore', 'Y', 5.6)
INSERT INTO Promotion VALUES ('P009', '11/11 Sale', 'Celebrate all your discounted purchases with more discounts!', 'N', 11)
INSERT INTO Promotion VALUES ('P010', 'Christmas Promotion ', 'Merry Christmas! Applicable with purchases totalling over $200', 'N', 25)


-- OutletPromotions NOT DONE


-- Menu NOT DONE


-- Item
INSERT INTO Item VALUES ('I001', 'Xiao Long Bao', 'Juicy pork wrapped in steamed dumplings', '5.50') 
INSERT INTO Item VALUES ('I002', 'Pot Stickers', 'Crispy pork dumplings', '5.00' ) 
INSERT INTO Item VALUES ('I003', 'Roast Beef Noodle', 'Hand-pulled noodles served in hearty beef broth and topped with succulent, slow-roasted beef', '7.00') 
INSERT INTO Item VALUES ('I004', 'Mapo Tofu with Rice', 'Tofu in savoury, spicy meat sauce served on rice', '6.50') 
INSERT INTO Item VALUES ('I005', 'Salted Egg Yolk Chicken with Rice', 'Fried chicken bites stir-fried in creamy salted egg yolk sauce served on rice', '7.00') 
INSERT INTO Item VALUES ('I006', 'Sweet and Sour Pork with Rice', 'Fried pork stir-fried in sweet and sour sauce served on rice', '6.00') 
INSERT INTO Item VALUES ('I007', 'Pad Thai', 'Stir-fried rice noodle with chicken, egg and vegetables', '5.50') 
INSERT INTO Item VALUES ('I008', 'Lontong', 'Rice cakes in coconut-based soup', '4.50') 
INSERT INTO Item VALUES ('I009', 'Nasi Lemak', 'Fragrant coconut rice served with fried chicken, sambal and egg', '5.20') 
INSERT INTO Item VALUES ('I010', 'Ikan Penyet', 'Fried, smashed fish with rice', '5.80') 
INSERT INTO Item VALUES ('I011', 'Ayam Penyet', 'Fried, smashed chicken with rice', '5.30') 
INSERT INTO Item VALUES ('I012', 'Beef Rendang', 'Beef simmered in spicy, savoury sauce', '7.00') 
INSERT INTO Item VALUES ('I013', 'Spaghetti Bolognese', 'Slow-cooked meat sauce served with spaghetti', '5.50') 
INSERT INTO Item VALUES ('I014', 'Spaghetti Carbonara', 'Spaghetti served in creamy sauce made with bacon, cheese, egg and black pepper', '7.00') 
INSERT INTO Item VALUES ('I015', 'English Breakfast', 'Eat like a true Brit- crispy bacon, sunny-side eggs, juicy sausages, mushrooms, seared tomatoes, buttery toast and hearty baked beans all on one plate', '12.00') 
INSERT INTO Item VALUES ('I016', 'French Toast with Tea', 'Thick white bread dipped in custard and toasted, served with freshly brewed earl grey tea', '7.60') 
INSERT INTO Item VALUES ('I017', 'Hotcakes and Sausages', 'Fluffy American pancakes topped with butter and real Canadian syrup, served with a side of thick, juicy sausages', '8.20') 
INSERT INTO Item VALUES ('I018', 'Croque Madame', 'Dine like a real Frenchman- Buttery toast with creamy white sauce, ham and gruyere cheese topped with a sunny-side up egg', '8.00') 
INSERT INTO Item VALUES ('I019', 'Tiramisu', 'Coffee-flavoured dessert, layered with cheese and topped with cream', '7.70') 
INSERT INTO Item VALUES ('I020', 'Key Lime Pie', 'Sweet, tangy lime filling in flaky, buttery crust', '5.80') 
INSERT INTO Item VALUES ('I021', 'Bibimbap', 'Korean rice dish served in a hot stone plate, topped with carrots, soy sauce, kimchi, chicken and egg', '6.30') 
INSERT INTO Item VALUES ('I022', 'Oyakodon', 'Japanese scrambled eggs cooked with chicken cubes, served over rice', '4.80') 
INSERT INTO Item VALUES ('I023', 'Omurice', 'Silky Japanese omelette coated over ketchup rice and chicken', '4.80') 
INSERT INTO Item VALUES ('I024', 'Taco al pastor', 'Juicy grilled pork in taco shells topped with salsa and sour cream', '7.80') 
INSERT INTO Item VALUES ('I025', 'Beef enchiladas', 'Ground beef, cheese, black beans and chilli wrapped in flour tortilla', '6.40') 
INSERT INTO Item VALUES ('I026', 'Banh mi', 'French baguette filled with savoury meat and ingredients', '5.00') 
INSERT INTO Item VALUES ('I027', 'Banh Xeo', 'Crispy stuffed rice pancake made with rice flour, turmeric and water', '4.30') 
INSERT INTO Item VALUES ('I028', 'Pho bo', 'Rice noodles served in hearty broth, topped with beef and vegetables', '8.00') 
INSERT INTO Item VALUES ('I029', 'Pho ga', 'Rice noodles served in hearty broth, topped with chicken and vegetables', '7.00') 
INSERT INTO Item VALUES ('I030', 'Bun bo Hue', 'Rice vermicelli served in spicy broth, topped with beef and flavoured with lemongrass', '9.30') 
INSERT INTO Item VALUES ('I031', 'Kaya Butter Toast with Egg', 'Crispy bread toasted with butter, served with kaya and half-boiled eggs', '4.30') 
INSERT INTO Item VALUES ('I032', 'Roti Prata', 'Savoury Indian flatbread', '1.30') 
INSERT INTO Item VALUES ('I033', 'Hainanese Chicken Rice', 'Chicken poached in broth, served with aromatic rice cooked in broth', '3.80') 
INSERT INTO Item VALUES ('I034', 'Hokkien Prawn Noodle', 'Fried noodle simmered in rich prawn stock, served with pork belly, squid and egg', '4.50') 
INSERT INTO Item VALUES ('I035', 'Mutton Biryani', 'Mutton curry served on fragrant basmati rice cooked with various indian spices', '6.00') 
INSERT INTO Item VALUES ('I036', 'Maggi Goreng', 'Stir-fried maggi noodles', '5.20') 
INSERT INTO Item VALUES ('I037', 'Thosai', 'Thin, crispy pancake made from a fermented batter', '4.80') 
INSERT INTO Item VALUES ('I038', 'Paneer Curry', 'Creamy Indian cheese cubes cooked in spicy curry', '5.50')


-- MenuItem NOT DONE


-- Rider NOT DONE


-- Award
INSERT INTO Award VALUES ('A001', 'Highest Rating',  'Individual')
INSERT INTO Award VALUES ('A002', 'Highest Rating', 'Team')
INSERT INTO Award VALUES ('A003', 'Most Orders fulfilled', 'Individual')
INSERT INTO Award VALUES ('A004', 'Most Orders fulfilled', 'Team')
INSERT INTO Award VALUES ('A005', 'Fastest Average Delivery Time', 'Individual')
INSERT INTO Award VALUES ('A006', 'Fastest Average Delivery Time', 'Team')
INSERT INTO Award VALUES ('A007', 'Best Newcomer', 'Individual')
INSERT INTO Award VALUES ('A008', 'Best Team', 'Team')
INSERT INTO Award VALUES ('A009', 'Rider of the year (Junior)', 'Individual')
INSERT INTO Award VALUES ('A010', 'Rider of the year (Senior)', 'Individual')


-- AwardsWon NOT DONE


-- Team
INSERT INTO Team VALUES ('T001', 'SkateRider', NULL, NULL)
INSERT INTO Team VALUES ('T002', 'Sleepers', NULL, NULL)
INSERT INTO Team VALUES ('T003', 'Ridle', NULL, NULL)
INSERT INTO Team VALUES ('T004', 'Cyclistic', NULL, NULL)
INSERT INTO Team VALUES ('T005', ' Tortoise ', 'A006', NULL)
INSERT INTO Team VALUES ('T006', 'Wavel', NULL, NULL)
INSERT INTO Team VALUES ('T007', 'Speed', NULL, NULL)
INSERT INTO Team VALUES ('T008', 'Roller', NULL, NULL)
INSERT INTO Team VALUES ('T009', 'UltityBike', 'A008', NULL)
INSERT INTO Team VALUES ('T010', 'CrewWay', NULL, NULL)


-- Equipment
INSERT INTO Equipment VALUES ('E000', 'T-Shirt (Sleeveless)', '10', NULL)
INSERT INTO Equipment VALUES ('E001', 'T-Shirt (Long)', '10', NULL)
INSERT INTO Equipment VALUES ('E002', 'T-Shirt (Slim)', '10', NULL)
INSERT INTO Equipment VALUES ('E003', 'T-Shirt (Fat)', '10', NULL)
INSERT INTO Equipment VALUES ('E004', 'T-Shirt (Transparent)', '10', NULL)

INSERT INTO Equipment VALUES ('E005', 'Pants (Short)', '10', NULL)
INSERT INTO Equipment VALUES ('E006', 'Pants (Long)', '10', NULL)
INSERT INTO Equipment VALUES ('E007', 'Pants (Slim)', '10', NULL)
INSERT INTO Equipment VALUES ('E009', 'Pants (Fat)', '10', NULL)

INSERT INTO Equipment VALUES ('E010', 'Umbrella', '10', NULL)
INSERT INTO Equipment VALUES ('E011', 'Raincoat', '10', NULL)
INSERT INTO Equipment VALUES ('E012', 'Hat', '10', NULL)
INSERT INTO Equipment VALUES ('E013', 'Backpack', '10', NULL)
INSERT INTO Equipment VALUES ('E014', 'Water Bottle', '10', NULL)
INSERT INTO Equipment VALUES ('E015', 'Fire Extinguisher', '10', NULL)
INSERT INTO Equipment VALUES ('E016', 'Toilet Brush', '10', NULL)
INSERT INTO Equipment VALUES ('E017', 'Backup brain', '10', NULL)
INSERT INTO Equipment VALUES ('E018', 'Jacket ', '10', NULL)

INSERT INTO Equipment VALUES ('SE001', 'Starter Set', '10', NULL)
INSERT INTO Equipment VALUES ('ST011', 'Pants (Short)', '10', 'SE001')
INSERT INTO Equipment VALUES ('ST012', 'T-Shirt (Sleeveless)', '10', 'SE001')
INSERT INTO Equipment VALUES ('ST013', 'Backpack', '10', 'SE001')

INSERT INTO Equipment VALUES ('SE002', 'Value Set', '10', NULL)
INSERT INTO Equipment VALUES ('ST021', 'T-Shirt (Sleeveless)', '10', 'SE002')
INSERT INTO Equipment VALUES ('ST022', 'Pants (Short)', '10', 'SE002')
INSERT INTO Equipment VALUES ('ST023', 'Backpack', '10', 'SE002')
INSERT INTO Equipment VALUES ('ST024', 'Hat', '10', 'SE002')
INSERT INTO Equipment VALUES ('ST025', 'Raincoat', '10', 'SE002')

INSERT INTO Equipment VALUES ('SE003', 'Advanced Set', '10', NULL)
INSERT INTO Equipment VALUES ('ST031', 'T-Shirt (Sleeveless)', '10', 'SE003')
INSERT INTO Equipment VALUES ('ST032', 'Pants (Short)', '10', 'SE003')
INSERT INTO Equipment VALUES ('ST033', 'Backpack', '10', 'SE003')
INSERT INTO Equipment VALUES ('ST034', 'Hat', '10', 'SE003')
INSERT INTO Equipment VALUES ('ST035', 'Water Bottle', '10', 'SE003')
INSERT INTO Equipment VALUES ('ST036', 'Raincoat', '10', 'SE003')
INSERT INTO Equipment VALUES ('ST037', 'Bonus Sticker Pack', '10', 'SE003')
INSERT INTO Equipment VALUES ('ST038', 'Food Container', '10', 'SE003')

INSERT INTO Equipment VALUES ('SE004', 'Impossible Set', '10', NULL)
INSERT INTO Equipment VALUES ('ST041', 'Backup brain', '10', 'SE004')
INSERT INTO Equipment VALUES ('ST042', 'Rocket', '10', 'SE004')
INSERT INTO Equipment VALUES ('ST043', 'Teleporter', '10', 'SE004')


-- EquipmentPurchase NOT DONE


-- Customer
INSERT INTO Customer VALUES ('C001', 'Anth La', 'Sui Bian Road #00-01 88888', '91111111', 'justputwhatever@gmail.com') 
INSERT INTO Customer VALUES ('C002',' Harry Botter', 'Drawer under the stairs Alley #13-06', '23423424',  'iamalizard@gmail.com') 
INSERT INTO Customer VALUES ('C003', 'Justin Beaver', '11 Baby Street #18-21 Singapore 382011', '43243553', 'justinbaby123@gmail.com') 
INSERT INTO Customer VALUES ('C005', 'Ronald Bacdonald', '24 McBishan McPark McSingapore 912090', '43243553', 'MAC@gmail.com') 
INSERT INTO Customer VALUES ('C006', 'Selena Bomez', '38 Marina Bay #22-69 Singapore 483038', '82123232', 'justiniloveyou@gmail.com') 
INSERT INTO Customer VALUES ('C007', 'LeBruh James', '23 Goat Avenue #01-01 Singapore 232323', '93712107', 'kingjames@gmail.com') 
INSERT INTO Customer VALUES ('C008', 'Stepan Chilli', '23 Mountain Goat Avenue #06-01 Singapore 653663', '97863635', 'godstepan@gmail.com' ) 
INSERT INTO Customer VALUES ('C009', 'Tom Clementi', '645 Holland Road', '99999999', 'froginmouth@gmail.com') 
INSERT INTO Customer VALUES ('C010', 'Sillie Eyelash', '1 Billboard Charts #01-01 Singapore 272401', '94768343', 'imthebadguy@duhmail.com') 
INSERT INTO Customer VALUES ('C011', 'Ariana Medium,', '43 High Pitch #34-35 Singapore 343569', '93526371', 'arianagrande@hotmail.com')
INSERT INTO Customer VALUES ('C012', 'Benjamin Who J.K', 'School of Science and Technology', '82990118', 'codecreatecoordinate@impressive.isntit') 
INSERT INTO Customer VALUES ('C013', 'Jack Daniel', 'Crescent Street Blk 45 #10-34', '94356554', 'jackdaniel123@gmail.com') 
INSERT INTO Customer VALUES ('C014', 'Anna Lim', 'Clementi Street 64 Blk 345 #12-34', '90523533', 'annalim@gmail.com') 
INSERT INTO Customer VALUES ('C015', 'Daniel Chua', 'Hunter Street Blk 353 #35-02', '92939453', 'danielc@gmail.com') 
INSERT INTO Customer VALUES ('C016', 'Steven Lee', 'Oxford Rd 123', '84654365', 'stevenlee@gmail.com') 
INSERT INTO Customer VALUES ('C017', 'Giselle Oon', 'Rochester Street Blk 41 #17-32', '97685665', 'giselleoon@gmail.com') 


-- Voucher
INSERT INTO Voucher VALUES ('V001', 'R', '$5 off all Chinese food', '2020-06-01 00:00:00 AM', '2020-12-31 23:59:59 PM', NULL, '5.00', 'C001')
INSERT INTO Voucher VALUES ('V002', 'R', '$5 off all Mexican food', '20200801 12:00:00 PM', '20210228 12:00:00 PM', NULL, '5.00', 'C010')
INSERT INTO Voucher VALUES ('V003', 'R', '$5 off delivery fees', '20200101 00:00:00 AM', '20210101 23:59:59 PM', NULL, '5.00', 'C008')
INSERT INTO Voucher VALUES ('V004', 'N', '$3 off delivery fees', '20200401 00:00:00 AM', '20200430 23:59:59 PM', NULL, '3.00', 'C008')
INSERT INTO Voucher VALUES ('V005', 'N', '$8 off Western food with $30 minimum spend', '20200801 00:00:00 AM', '20200831 23:59:59 PM', '30.00', '8.00', 'C009')
INSERT INTO Voucher VALUES ('V006', 'R', 'Free thosai worth $4.80 with minimum order of $15', '20200901 00:00:00 AM', '20210228 23:59:59 PM', '15.00', '4.80', 'C009')
INSERT INTO Voucher VALUES ('V007', 'N', 'Free key lime pie worth $5.80 with minimum order of $25', '20201001 00:00:00 AM', '20210228 23:59:59 PM', '25.00', '5.80', 'C009')
INSERT INTO Voucher VALUES ('V008', 'R', '1 for 1 pho bo worth $8', '20210101 00:00:00 AM', '20210531 23:59:59 PM', '8.00', '8.00', 'C001')
INSERT INTO Voucher VALUES ('V009', 'N', ' Free chicken rice worth $3.80', '20210101 00:00:00 AM', '20210131 23:59:59 PM', NULL, '3.80', 'C002')
INSERT INTO Voucher VALUES ('V010', 'R', 'Free lontong worth $4.50', '20210101 00:00:00 AM', '20210630 23:59:59 PM', NULL, '4.50', 'C002')
INSERT INTO Voucher VALUES ('V011', 'R', '$5 off delivery fees', '20210101 00:00:00 AM', '20210630 23:59:59 PM', NULL, '5.00', 'C001')
INSERT INTO Voucher VALUES ('V012', 'R', '$5 off delivery fees', '20210101 00:00:00 AM', '20210630 23:59:59 PM', NULL, '5.00', 'C006')
INSERT INTO Voucher VALUES ('V013', 'R', '$5 off delivery fees', '20210101 00:00:00 AM', '20210630 23:59:59 PM', NULL, '5.00', 'C005')


-- CustOrder NOT DONE


-- Payment NOT DONE


-- OrderItem NOT DONE


-- OrderPromotions NOT DONE


-- Pickup NOT DONE


-- Delivery NOT DONE


-- DeliveryAssignment NOT DONE


-- Table data output
SELECT * from Zone
SELECT * from Outlet
SELECT * from OutletContact
SELECT * from Cuisine
SELECT * from OutletCuisines
SELECT * from Promotion
SELECT * from OutletPromotions
SELECT * from Menu
SELECT * from Item
SELECT * from MenuItem
SELECT * from Rider
SELECT * from Award
SELECT * from AwardsWon
SELECT * from Team
SELECT * from Equipment
SELECT * from EquipmentPurchase
SELECT * from Customer
SELECT * from Voucher
SELECT * from CustOrder
SELECT * from Payment
SELECT * from OrderItem
SELECT * from OrderPromotions
SELECT * from Pickup
SELECT * from Delivery
SELECT * from DeliveryAssignment
