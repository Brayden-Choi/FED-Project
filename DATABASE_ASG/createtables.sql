-- Create fresh database, delete old one if needed
USE master

IF EXISTS(SELECT * FROM sys.databases WHERE name='MokeFoodDelivery')
DROP DATABASE MokeFoodDelivery
GO

CREATE DATABASE MokeFoodDelivery
GO

USE MokeFoodDelivery
GO


--T Business
CREATE TABLE Business  
(  
bizID     char(5)		 NOT NULL,  
bizName   varchar(256)   NOT NULL,  

CONSTRAINT PK_Business PRIMARY KEY (bizID)  
)  


--T Zone
CREATE TABLE Zone  
(  
zoneID     char(5)       NOT NULL,  
zoneName   varchar(32)   NOT NULL,  

CONSTRAINT PK_Zone PRIMARY KEY (zoneID)  
)  
 

--T Outlet
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


--T OutletContact
CREATE TABLE OutletContact  
(  
outletID     char(5)     NOT NULL,  
contactNo    char(8)     NOT NULL,  

CONSTRAINT PK_OutletContact PRIMARY KEY NONCLUSTERED (outletID, contactNo),  
CONSTRAINT FK_OutletContact_outletID FOREIGN KEY (outletID) REFERENCES Outlet(outletID)  
)  
 

--T Cuisine
CREATE TABLE Cuisine  
(  
cuisineID     char(5)        NOT NULL,  
cuisineName   varchar(128)   NOT NULL,  

CONSTRAINT PK_Cuisine PRIMARY KEY (cuisineID)  
)  
 

--T OutletCuisines
CREATE TABLE OutletCuisines   
(  
outletID    char(5)   NOT NULL,  
cuisineID   char(5)   NOT NULL,  

CONSTRAINT PK_OutletCuisines PRIMARY KEY NONCLUSTERED (outletID, cuisineID),  
CONSTRAINT FK_Outlet_outletID FOREIGN KEY (outletID) REFERENCES Outlet(outletID),  
CONSTRAINT FK_Cuisine_cuisineID FOREIGN KEY (cuisineID) REFERENCES Cuisine(cuisineID)  
)
 

--T Promotion
CREATE TABLE Promotion  
(  
promoID           char(5)        NOT NULL,  
promoName         varchar(100)   NOT NULL,  
promoDesc         varchar(200)   NULL,  
isFreeDelivery    char(1)        NULL,  
percentDiscount   float          NULL,  

CONSTRAINT PK_Promotion PRIMARY KEY (promoID),
CONSTRAINT CHK_isFreeDelivery CHECK (isFreeDelivery IN ('Y','N'))
)  
 

--T OutletPromotions
CREATE TABLE OutletPromotions   
(  
outletID char(5) NOT NULL,  
promoID char(5) NOT NULL,   
maxCount int NULL,   

CONSTRAINT PK_OutletPromotions PRIMARY KEY NONCLUSTERED (outletID, promoID),  
CONSTRAINT FK_OutletPromotions_outletID FOREIGN KEY (outletID) REFERENCES Outlet(outletID),  
CONSTRAINT FK_OutletPromotions_promoID FOREIGN KEY (promoID) REFERENCES Promotion(promoID)  
)  


--T Menu
CREATE TABLE Menu
(  
outletID   char(5)       NOT NULL,  
menuNo     int           NOT NULL,  
menuName   varchar(50)   NOT NULL,

CONSTRAINT PK_Menu PRIMARY KEY NONCLUSTERED (outletID, menuNo),  
CONSTRAINT FK_Menu_outletID FOREIGN KEY (outletID) REFERENCES Outlet(outletID)  
)  
 

--T Item
CREATE TABLE Item   
(  
itemID     char(5)        NOT NULL,  
itemName   varchar(100)   NOT NULL,  
itemDesc   varchar(200)   NULL,  
itemPrice  float          NULL, 

CONSTRAINT PK_Item PRIMARY KEY (itemID)  
)  


--T MenuItem
CREATE TABLE MenuItem   
(  
outletID   char(5)  NOT NULL,  
menuNo     int      NOT NULL,  
itemID     char(5)  NOT NULL, 

CONSTRAINT PK_MenuItem PRIMARY KEY NONCLUSTERED (outletID, menuNo, itemID),
CONSTRAINT FK_MenuItem_outletID_menuNo FOREIGN KEY (outletID, menuNo) REFERENCES Menu(outletID, menuNo),  
CONSTRAINT FK_MenuItem_itemID FOREIGN KEY (itemID) REFERENCES Item(itemID)  
)  


--T Award
CREATE TABLE Award  
(  
awardID     char(5)       NOT NULL,  
awardName   varchar(200)  NULL,  
awardType   varchar(100)  NULL,

CONSTRAINT PK_Award PRIMARY KEY (awardID)
)  


--T AwardsWon
CREATE TABLE AwardsWon
(  
awardID   char(5)   NOT NULL,  
riderID   char(5)   NOT NULL,  
winDate   datetime  NOT NULL, 

CONSTRAINT PK_AwardsWon PRIMARY KEY NONCLUSTERED (winDate, awardID, riderID),  
CONSTRAINT FK_AwardsWon_awardID FOREIGN KEY (awardID) REFERENCES Award(awardID)
)  
 

--T Team
Create TABLE Team  
(  
teamID     char(5)       NOT NULL,  
teamName   varchar(200)  NULL,  
awardID    char(5)       NULL,  
leaderID   char(5)       NULL,

CONSTRAINT PK_Team PRIMARY KEY (teamID),  
CONSTRAINT FK_Team_awardID FOREIGN KEY (awardID) REFERENCES Award(awardID)
)  
 

--T Rider
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


--T Equipment
CREATE TABLE Equipment
(  
equipID       char(5)        NOT NULL,  
equipName     varchar(200)   NULL,  
equipPrice    float          NULL,  
setID         char(5)        NULL,

CONSTRAINT PK_Equipment PRIMARY KEY (equipID),  
CONSTRAINT FK_Equipment_setID FOREIGN KEY (setID) REFERENCES Equipment(equipID),  
)
 

--T EquipmentPurchase
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


--T Customer
CREATE TABLE Customer
(   
CustID        char(5)        NOT NULL,  
custName      varchar(100)   NOT NULL,  
custAddress   varchar (200)  NULL,  
custContact   char(8)        NULL,  
custEmail     varchar(100)   NULL,  

CONSTRAINT PK_Customer PRIMARY KEY (custID)  
) 
 

--T Voucher
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


--T CustOrder
CREATE TABLE CustOrder
(  
orderID        char(5)     NOT NULL,  
orderStatus    char(1)     NULL,  
orderDateTime  dateTime    NULL,  
custID         char(5)     NOT NULL,  
voucherID      char(5)     NULL,  
outletID       char(5)     NOT NULL,  

CONSTRAINT PK_CustOrder PRIMARY KEY (OrderID),  
CONSTRAINT FK_CustOrder_custID FOREIGN KEY (custID) REFERENCES Customer(custID),  
CONSTRAINT FK_CustOrder_voucherID FOREIGN KEY (voucherID) REFERENCES Voucher(voucherID),  
CONSTRAINT FK_CustOrder_outletID FOREIGN KEY (outletID) REFERENCES Outlet(outletID),
CONSTRAINT CHK_orderStatus CHECK (orderStatus IN ('D','N'))  
)
 

--T Payment
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
 

--T OrderItem
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
 

--T OrderPromotions
CREATE TABLE OrderPromotions  
(  
orderID   Char(5)  NOT NULL,  
promoID   Char(5)  NOT NULL,

CONSTRAINT PK_OrderPromotions PRIMARY KEY NONCLUSTERED (orderID, promoID),  
CONSTRAINT FK_OrderPromotions_orderID FOREIGN KEY (orderID) REFERENCES CustOrder(orderID),  
CONSTRAINT FK_OrderPromotions_promoID FOREIGN KEY (promoID) REFERENCES Promotion(promoID)  
)  
 

--T Pickup
CREATE TABLE Pickup  
(  
orderID          char(5)       NOT NULL,  
pickupRefNo      varchar(50)   NOT NULL,  
pickupDateTime   dateTime      NULL,  

CONSTRAINT PK_Pickup PRIMARY KEY (orderID),  
CONSTRAINT FK_Pickup_orderID FOREIGN KEY (orderID) REFERENCES CustOrder(orderID)  
)  

 
--T Delivery
CREATE TABLE Delivery  
(  
orderID           char(5)        NOT NULL,  
deliveryDateTime  dateTime       NULL,  
deliveryAddress   varchar(256)   NOT NULL,  
riderID           char(5)        NOT NULL,  

CONSTRAINT PK_Delivery PRIMARY KEY (orderID),  
CONSTRAINT FK_Delivery_custID FOREIGN KEY (orderID) REFERENCES CustOrder(orderID),  
CONSTRAINT FK_Delivery_riderID FOREIGN KEY (riderID) REFERENCES Rider(riderID)  
)


--T DeliveryAssignment
CREATE TABLE DeliveryAssignment  
(  
orderID   Char(5)       NOT NULL,  
riderID   Char(5)       NOT NULL,  
Status    varchar(50)   NULL, 

CONSTRAINT PK_DeliveryAssignment PRIMARY KEY NONCLUSTERED (orderID, riderID),  
CONSTRAINT FK_DeliveryAssignment_orderID FOREIGN KEY (orderID) REFERENCES CustOrder(orderID),  
CONSTRAINT FK_DeliveryAssignment_riderID FOREIGN KEY (riderID) REFERENCES Rider (riderID)  
)	


--A Rider
ALTER TABLE Rider
ADD CONSTRAINT FK_Rider_TeamID FOREIGN KEY (teamID) REFERENCES
Team(teamID)


--A Team
ALTER TABLE Team
ADD CONSTRAINT FK_Team_leaderID FOREIGN KEY (leaderId) REFERENCES Rider(riderID)


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
<<<<<<< HEAD
INSERT INTO Zone VALUES ('Z001', 'North')  
INSERT INTO Zone VALUES ('Z002', 'East')  
INSERT INTO Zone VALUES ('Z003', 'West') 
INSERT INTO Zone VALUES ('Z004', 'Central') 
=======
INSERT INTO Zone VALUES ('Z001', 'North') 
INSERT INTO Zone VALUES ('Z002', 'South') 
INSERT INTO Zone VALUES ('Z003', 'East') 
INSERT INTO Zone VALUES ('Z004', 'West')
INSERT INTO Zone VALUES ('Z005', 'Central')

>>>>>>> 0acf8695a350855b7864adfb13a6b4a8c00225b6

-- Outlet
INSERT INTO Outlet VALUES ('O001', 'Ahmad Makan', '18 Tampines Drive, Singapore 374018', '08:00:00', '21:00:00', '09:00:00', '21:00:00', 'B001', 'Z002')  
INSERT INTO Outlet VALUES ('O002', 'Just Eat La', '377 Jurong Avenue, Singapore 536377', '12:00:00', '20:00:00', '12:00:00', '20:00:00', 'B002', 'Z003')  
INSERT INTO Outlet VALUES ('O003', 'Mark’s Place', '24 Bishan Street, Singapore 549604', '08:00:00', '21:00:00', '09:00:00', '20:00:00', 'B003', 'Z004') 
INSERT INTO Outlet VALUES ('O004', 'Vietry Good', '188 Pasir Ris Road, Singapore 271188', '12:00:00', '22:00:00', '12:00:00', '21:00:00', 'B004', 'Z002')  
INSERT INTO Outlet VALUES ('O005', 'La Chancla', '24 Ang Mo Kio Avenue, Singapore 549604', '07:00:00', '21:00:00', '07:00:00', '20:00:00', 'B005', 'Z004')  
INSERT INTO Outlet VALUES ('O006', 'Muthu Foods', '768 Woodlands Plaza, Singapore 720768', '10:00:00', '21:00:00', '10:00:00', '19:30:00', 'B006', 'Z001')  
INSERT INTO Outlet VALUES ('O007', 'Sooshi', '133 Choa Chu Kang Road, Singapore 059413', '11:00:00', '20:30:00', '12:00:00', '19:00:00', 'B007', 'Z003') 
INSERT INTO Outlet VALUES ('O008', 'Jerk Thai', '377 Chinese Garden, Singapore 536377', '12:00:00', '20:00:00', '12:00:00', '20:00:00', 'B008', 'Z003') 
INSERT INTO Outlet VALUES ('O009', 'Oppa Chicken', '930 Yishun Ave 2, Singapore 769098', '10:30:00', '23:00:00', '10:30:00', '21:00:00', 'B005', 'Z001') 
INSERT INTO Outlet VALUES ('O010', 'Din Tai Fong', '80 Marine Parade Rd, Singapore 449269', '10:00:00', '22:00:00', '11:00:00', '19:00:00', 'B002', 'Z004') 

-- OutletContact
INSERT INTO OutletContact VALUES ('O001', '85366336') 
INSERT INTO OutletContact VALUES ('O001', '88943276') 
INSERT INTO OutletContact VALUES ('O002', '94356431') 
INSERT INTO OutletContact VALUES ('O003', '81431244') 
INSERT INTO OutletContact VALUES ('O004', '94523223') 
INSERT INTO OutletContact VALUES ('O005', '92542542') 
INSERT INTO OutletContact VALUES ('O006', '91444634') 
INSERT INTO OutletContact VALUES ('O007', '81475344') 
INSERT INTO OutletContact VALUES ('O008', '87645342') 
INSERT INTO OutletContact VALUES ('O009', '97876235')
INSERT INTO OutletContact VALUES ('O009', '69214365')
INSERT INTO OutletContact VALUES ('O009', '96127354')
INSERT INTO OutletContact VALUES ('O010', '82345647')
INSERT INTO OutletContact VALUES ('O010', '64952367')


-- Cuisine
INSERT INTO Cuisine VALUES ('CS001', 'Chinese') 
INSERT INTO Cuisine VALUES ('CS002', 'Thai') 
INSERT INTO Cuisine VALUES ('CS003', 'Malay') 
INSERT INTO Cuisine VALUES ('CS004', 'Western') 
INSERT INTO Cuisine VALUES ('CS005', 'Korean') 
INSERT INTO Cuisine VALUES ('CS006', 'Japanese') 
INSERT INTO Cuisine VALUES ('CS007', 'Mexican') 
INSERT INTO Cuisine VALUES ('CS008', 'Vietnamese') 
INSERT INTO Cuisine VALUES ('CS009', 'Singaporean') 
INSERT INTO Cuisine VALUES ('CS010', 'Indian')
INSERT INTO Cuisine VALUES ('CS011', 'German')
INSERT INTO Cuisine VALUES ('CS012', 'Vietnamese')
INSERT INTO Cuisine VALUES ('CS013', 'French')
INSERT INTO Cuisine VALUES ('CS014', 'Italian')


-- OutletCuisines
INSERT INTO OutletCuisines VALUES ('O001', 'CS003')
INSERT INTO OutletCuisines VALUES ('O002', 'CS009')
INSERT INTO OutletCuisines VALUES ('O003', 'CS004')
INSERT INTO OutletCuisines VALUES ('O004', 'CS008')
INSERT INTO OutletCuisines VALUES ('O005', 'CS007')
INSERT INTO OutletCuisines VALUES ('O006', 'CS010')
INSERT INTO OutletCuisines VALUES ('O007', 'CS006')
INSERT INTO OutletCuisines VALUES ('O008', 'CS002')
INSERT INTO OutletCuisines VALUES ('O009', 'CS005')
INSERT INTO OutletCuisines VALUES ('O010', 'CS001')


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


-- OutletPromotions
INSERT INTO OutletPromotions VALUES ('O003', 'P010', 200)
INSERT INTO OutletPromotions VALUES ('O007', 'P002', 150)
INSERT INTO OutletPromotions VALUES ('O009', 'P004', 80)
INSERT INTO OutletPromotions VALUES ('O001', 'P007', 260)
INSERT INTO OutletPromotions VALUES ('O006', 'P003', 300)
INSERT INTO OutletPromotions VALUES ('O010', 'P005', 50)
INSERT INTO OutletPromotions VALUES ('O008', 'P008', 120)
INSERT INTO OutletPromotions VALUES ('O002', 'P001', 310)
INSERT INTO OutletPromotions VALUES ('O004', 'P009', 240)
INSERT INTO OutletPromotions VALUES ('O005', 'P006', 100)


-- Menu
INSERT INTO Menu VALUES ('O001', 1, 'Lunch')
INSERT INTO Menu VALUES ('O001', 2, 'Dinner')

INSERT INTO Menu VALUES ('O002', 1, 'Breakfast')
INSERT INTO Menu VALUES ('O002', 2, 'Lunch')

INSERT INTO Menu VALUES ('O003', 1, 'Lunch')
INSERT INTO Menu VALUES ('O003', 2, 'Dinner')

INSERT INTO Menu VALUES ('O004', 1, 'All-day Breakfast')
INSERT INTO Menu VALUES ('O004', 2, 'Dessert')
INSERT INTO Menu VALUES ('O004', 3, 'Student Deals')

INSERT INTO Menu VALUES ('O005', 1, 'All-day Menu')

INSERT INTO Menu VALUES ('O006', 1, 'Lunch')
INSERT INTO Menu VALUES ('O006', 2, 'Dinner')

INSERT INTO Menu VALUES ('O006', 3, 'Supper')

INSERT INTO Menu VALUES ('O007', 1, 'All-day Menu')

INSERT INTO Menu VALUES ('O008', 1, 'Lunch')

INSERT INTO Menu VALUES ('O009', 1, 'All-day Menu')

INSERT INTO Menu VALUES ('O010', 1, 'Appetizers')
INSERT INTO Menu VALUES ('O010', 2, 'Lunch')


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


-- MenuItem
INSERT INTO MenuItem VALUES ('O001', 1, 'I008')
INSERT INTO MenuItem VALUES ('O001', 1, 'I009')
INSERT INTO MenuItem VALUES ('O001', 2, 'I010')
INSERT INTO MenuItem VALUES ('O001', 2, 'I011')
INSERT INTO MenuItem VALUES ('O001', 2, 'I012')
INSERT INTO MenuItem VALUES ('O002', 1, 'I031')
INSERT INTO MenuItem VALUES ('O002', 1, 'I032')
INSERT INTO MenuItem VALUES ('O002', 2, 'I033')
INSERT INTO MenuItem VALUES ('O002', 2, 'I034')
INSERT INTO MenuItem VALUES ('O003', 1, 'I015')
INSERT INTO MenuItem VALUES ('O003', 1, 'I016')
INSERT INTO MenuItem VALUES ('O003', 1, 'I017')
INSERT INTO MenuItem VALUES ('O003', 1, 'I018')
INSERT INTO MenuItem VALUES ('O003', 2, 'I019')
INSERT INTO MenuItem VALUES ('O003', 2, 'I020')
INSERT INTO MenuItem VALUES ('O003', 2, 'I013')
INSERT INTO MenuItem VALUES ('O003', 2, 'I014')
INSERT INTO MenuItem VALUES ('O004', 1, 'I026')
INSERT INTO MenuItem VALUES ('O004', 1, 'I027')
INSERT INTO MenuItem VALUES ('O004', 2, 'I028')
INSERT INTO MenuItem VALUES ('O004', 2, 'I029')
INSERT INTO MenuItem VALUES ('O004', 2, 'I030')
INSERT INTO MenuItem VALUES ('O005', 1, 'I024')
INSERT INTO MenuItem VALUES ('O005', 1, 'I025')
INSERT INTO MenuItem VALUES ('O006', 2, 'I035')
INSERT INTO MenuItem VALUES ('O006', 2, 'I036')
INSERT INTO MenuItem VALUES ('O006', 3, 'I037')
INSERT INTO MenuItem VALUES ('O006', 3, 'I038')
INSERT INTO MenuItem VALUES ('O007', 1, 'I022')
INSERT INTO MenuItem VALUES ('O007', 1, 'I023')
INSERT INTO MenuItem VALUES ('O008', 1, 'I007')
INSERT INTO MenuItem VALUES ('O009', 1, 'I021')
INSERT INTO MenuItem VALUES ('O010', 1, 'I001')
INSERT INTO MenuItem VALUES ('O010', 1, 'I002')
INSERT INTO MenuItem VALUES ('O010', 2, 'I003')
INSERT INTO MenuItem VALUES ('O010', 2, 'I004')
INSERT INTO MenuItem VALUES ('O010', 2, 'I005')
INSERT INTO MenuItem VALUES ('O010', 2, 'I006')


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


-- Team
INSERT INTO Team VALUES ('T001', 'SkateRider', NULL, NULL)
INSERT INTO Team VALUES ('T002', 'Sleepers', NULL, NULL)
INSERT INTO Team VALUES ('T003', 'Ridle', NULL, NULL)
INSERT INTO Team VALUES ('T004', 'Cyclistic', NULL, NULL)
INSERT INTO Team VALUES ('T005', ' Tortoise', NULL, NULL)
INSERT INTO Team VALUES ('T006', 'Wavel', NULL, NULL)
INSERT INTO Team VALUES ('T007', 'Speed', NULL, NULL)
INSERT INTO Team VALUES ('T008', 'Roller', NULL, NULL)
INSERT INTO Team VALUES ('T009', 'UltityBike', NULL, NULL)
INSERT INTO Team VALUES ('T010', 'CrewWay', NULL, NULL)


-- Rider
INSERT INTO Rider VALUES ('R001', 'S3123642J', 'Samuel Low', '86543143', 'Fernville Road #14-01 353448', '02/05/1976', 'Bicycle', 'T001')  
INSERT INTO Rider VALUES ('R002', 'S7676723T', 'Darron Mann', '86755433', 'Nashville Road #17-30 765345', '07/23/1996', 'Motocycle', 'T001') 
INSERT INTO Rider VALUES ('R003', 'S8745234U', 'Zachary Chan', '91039124', 'Ring Road #10-01 353448', '11/28/1998', 'Car', 'T001') 
INSERT INTO Rider VALUES ('R004', 'S0734980A', 'Robert Teo', '90589341', ' Road #14-01 353448', '07/12/1976', 'E-Scooter', 'T002') 
INSERT INTO Rider VALUES ('R005', 'S5421754Y', 'James Chia', '81463981', 'Tilda Street #20-12 353448', '02/15/1989', 'E-Scooter', 'T003') 
INSERT INTO Rider VALUES ('R006', 'S0978763V', 'Rachel Liau', '99089046', 'Bukit Batok Street 21 #04-04 624543', '01/12/1967', 'E-Scooter', 'T004') 
INSERT INTO Rider VALUES ('R007', 'S1047343D', 'Darren Tok', '85642134', 'West Coast Road Blk 930#15-32 786534', '09/19/1978', 'Car', 'T005')
INSERT INTO Rider VALUES ('R008', 'S9074893H', 'Sam Guy', '94359687', 'HoolaRow Road #14-01 353448', '06/30/1997', 'Motocycle', 'T005') 
INSERT INTO Rider VALUES ('R009', 'S7609353K', 'Thomas Trent', '90308232', 'YuoTze Road Blk 54 #17-06 876465', '03/21/1986', 'Bicycle',  'T005') 
INSERT INTO Rider VALUES ('R010', 'S8743099C', 'Dan Toh', '89897323', 'Mollow Street 57', '06/08/1988', 'Foot', 'T005')


-- AwardsWon
INSERT INTO AwardsWon VALUES ('A001', 'R003', '12/29/2018')
INSERT INTO AwardsWon VALUES ('A001', 'R008', '12/28/2019')
INSERT INTO AwardsWon VALUES ('A001', 'R008', '12/29/2020')
INSERT INTO AwardsWon VALUES ('A003', 'R004', '12/29/2018')
INSERT INTO AwardsWon VALUES ('A003', 'R002', '12/28/2019')
INSERT INTO AwardsWon VALUES ('A003', 'R010', '12/29/2020')
INSERT INTO AwardsWon VALUES ('A005', 'R006', '12/29/2020')
INSERT INTO AwardsWon VALUES ('A007', 'R007', '12/29/2020')
INSERT INTO AwardsWon VALUES ('A009', 'R002', '12/28/2019')
INSERT INTO AwardsWon VALUES ('A009', 'R009', '12/29/2020')
INSERT INTO AwardsWon VALUES ('A010', 'R001', '12/28/2019')


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


-- EquipmentPurchase
INSERT INTO EquipmentPurchase VALUES ('R001', 'E001', '04/21/2018', 2)
INSERT INTO EquipmentPurchase VALUES ('R001', 'E017', '04/21/2018', 1)
INSERT INTO EquipmentPurchase VALUES ('R009', 'E011', '06/04/2018', 1)
INSERT INTO EquipmentPurchase VALUES ('R002', 'E001', '07/28/2018', 3)
INSERT INTO EquipmentPurchase VALUES ('R004', 'E012', '08/11/2018', 1)
INSERT INTO EquipmentPurchase VALUES ('R008', 'E005', '01/12/2018', 1)
INSERT INTO EquipmentPurchase VALUES ('R010', 'E013', '02/23/2019', 1)
INSERT INTO EquipmentPurchase VALUES ('R001', 'E017', '03/30/2019', 1)
INSERT INTO EquipmentPurchase VALUES ('R003', 'E015', '08/25/2019', 1)
INSERT INTO EquipmentPurchase VALUES ('R002', 'E001', '10/08/2019', 1)


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
INSERT INTO Voucher VALUES ('V013', 'R', '$5 off delivery fees', '20210101 00:00:00 AM', '20210630 23:59:59', NULL, '5.00', 'C005')


-- CustOrder
INSERT INTO CustOrder VALUES ('DE001', 'D', '20201204 18:25:32 PM', 'C001', 'V001', 'O010')
INSERT INTO CustOrder VALUES ('DE002', 'N', '20200823 13:12:45 PM', 'C007', 'V012', 'O002')
INSERT INTO CustOrder VALUES ('PU003', 'D', '20201107 10:01:05 AM', 'C010', 'V008', 'O004')
INSERT INTO CustOrder VALUES ('DE004', 'D', '20201217 18:29:23 PM', 'C001', 'V013', 'O003')
INSERT INTO CustOrder VALUES ('PU005', 'N', '20200715 12:35:12 PM', 'C008', NULL, 'O007')
INSERT INTO CustOrder VALUES ('DE006', 'D', '20201111 22:24:01 PM', 'C001', 'V003', 'O003')
INSERT INTO CustOrder VALUES ('PU007', 'N', '20201224 13:12:45 PM', 'C009', NULL, 'O006')
INSERT INTO CustOrder VALUES ('PU008', 'D', '20210201 11:55:23 AM', 'C008', NULL, 'O009')
INSERT INTO CustOrder VALUES ('DE009', 'D', '20200513 16:53:54 PM', 'C002', 'V010', 'O001')
INSERT INTO CustOrder VALUES ('PU010', 'D', '20201010 20:33:32 PM', 'C007', NULL,  'O003')
INSERT INTO CustOrder VALUES ('DE011', 'D', '20201204 18:25:32 PM', 'C001', NULL, 'O010')
INSERT INTO CustOrder VALUES ('PU012', 'N', '20201113 15:02:35 PM', 'C007', NULL, 'O002')
INSERT INTO CustOrder VALUES ('PU013', 'D', '20200508 18:40:12 PM', 'C010', NULL, 'O004')
INSERT INTO CustOrder VALUES ('PU014', 'D', '20200427 14:22:53 PM', 'C001', NULL, 'O003')
INSERT INTO CustOrder VALUES ('DE015', 'N', '20201125 21:30:52 PM', 'C008', 'V011', 'O007')
INSERT INTO CustOrder VALUES ('PU016', 'N', '20210108 12:26:32 AM', 'C003', 'V002' , 'O005')
INSERT INTO CustOrder VALUES ('DE017', 'N', '20201224 15:40:41 PM', 'C009', 'V006', 'O006')
INSERT INTO CustOrder VALUES ('DE018', 'D', '20210911 11:25:53 AM', 'C008', NULL, 'O009')
INSERT INTO CustOrder VALUES ('PU019', 'D', '20200719 16:53:54 PM', 'C002', NULL, 'O001')
INSERT INTO CustOrder VALUES ('DE020', 'D', '20201010 20:33:32 PM', 'C007', NULL,  'O003')


-- Payment NOT DONE


-- OrderItem
INSERT INTO OrderItem VALUES ('DE001', 'I001', 2, 5.50)
INSERT INTO OrderItem VALUES ('DE002', 'I034', 1, 4.50)
INSERT INTO OrderItem VALUES ('PU003', 'I018', 1, 8)
INSERT INTO OrderItem VALUES ('DE004', 'I014', 2, 7)
INSERT INTO OrderItem VALUES ('PU005', 'I022', 1, 4.80)
INSERT INTO OrderItem VALUES ('DE006', 'I013', 1, 5.50)
INSERT INTO OrderItem VALUES ('PU007', 'I036', 1, 5.20)
INSERT INTO OrderItem VALUES ('PU008', 'I021', 3, 6.30)
INSERT INTO OrderItem VALUES ('DE009', 'I012', 2, 7)
INSERT INTO OrderItem VALUES ('PU010', 'I001', 2, 5.50)
INSERT INTO OrderItem VALUES ('DE011', 'I001', 2, 5.50)
INSERT INTO OrderItem VALUES ('PU012', 'I001', 2, 5.50)
INSERT INTO OrderItem VALUES ('PU013', 'I001', 2, 5.50)
INSERT INTO OrderItem VALUES ('PU014', 'I001', 2, 5.50)
INSERT INTO OrderItem VALUES ('DE015', 'I001', 2, 5.50)
INSERT INTO OrderItem VALUES ('PU016', 'I001', 2, 5.50)
INSERT INTO OrderItem VALUES ('DE017', 'I001', 2, 5.50)
INSERT INTO OrderItem VALUES ('DE018', 'I001', 2, 5.50)
INSERT INTO OrderItem VALUES ('PU019', 'I001', 2, 5.50)
INSERT INTO OrderItem VALUES ('DE020', 'I001', 2, 5.50)


-- OrderPromotions NOT DONE


-- Pickup
INSERT INTO PickUp VALUES ('PU003', 'RN001', '20200427 04:41:33 PM')
INSERT INTO PickUp VALUES ('PU005', 'RN002', '20200719 07:02:14 PM')
INSERT INTO PickUp VALUES ('PU007', 'RN003', '20210108 11:37:12 AM')
INSERT INTO PickUp VALUES ('PU008', 'RN004', '20201010 10:43:42 PM')
INSERT INTO PickUp VALUES ('PU010', 'RN005', '20200823 01:32:25 PM')
INSERT INTO PickUp VALUES ('PU012', 'RN006', '20200715 12:43:52 PM')
INSERT INTO PickUp VALUES ('PU013', 'RN007', '20210201 11:05:40 AM')
INSERT INTO PickUp VALUES ('PU014', 'RN008', '20201224 13:22:35 PM')
INSERT INTO PickUp VALUES ('PU016', 'RN009', '20200508 08:53:52 PM')
INSERT INTO PickUp VALUES ('PU019', 'RN010', '20201107 10:41:05 AM')


-- Delivery
INSERT INTO Delivery VALUES ('DE001', '20201202 12:22:45', 'Sui Bian Road #00-01 88888', 'R003') 
INSERT INTO Delivery VALUES ('DE002', '20200429 14:51:32', '23 Goat Avenue #01-01 Singapore 232323', 'R001') 
INSERT INTO Delivery VALUES ('DE004', '20200808 10:11:12', 'Sui Bian Road #00-01 88888', 'R009') 
INSERT INTO Delivery VALUES ('DE006', '20201119 16:08:43', 'Sui Bian Road #00-01 88888', 'R007') 
INSERT INTO Delivery VALUES ('DE009', '20210121 19:06:53', 'Drawer under the stairs Alley #13-06', 'R005') 
INSERT INTO Delivery VALUES ('DE011', '20200509 15:43:55', 'Sui Bian Road #00-01 88888', 'R008') 
INSERT INTO Delivery VALUES ('DE015', '20200224 11:48:00', '23 Mountain Goat Avenue #06-01 Singapore 653663', 'R004') 
INSERT INTO Delivery VALUES ('DE017', '20200126 20:12:02', '645 Holland Road', 'R010') 
INSERT INTO Delivery VALUES ('DE018', '20201130 13:48:16', '23 Mountain Goat Avenue #06-01 Singapore 653663', 'R006') 
INSERT INTO Delivery VALUES ('DE020', '20201209 18:10:06', '23 Goat Avenue #01-01 Singapore 232323', 'R002')


-- DeliveryAssignment
INSERT INTO DeliveryAssignment VALUES ('DE001', 'R003', 'D')
INSERT INTO DeliveryAssignment VALUES ('DE002', 'R001', 'D')
INSERT INTO DeliveryAssignment VALUES ('DE004', 'R009', 'D')
INSERT INTO DeliveryAssignment VALUES ('DE006', 'R007', 'D')
INSERT INTO DeliveryAssignment VALUES ('DE009', 'R005', 'D')
INSERT INTO DeliveryAssignment VALUES ('DE011', 'R008', 'D')
INSERT INTO DeliveryAssignment VALUES ('DE015', 'R004', 'D')
INSERT INTO DeliveryAssignment VALUES ('DE017', 'R010', 'D')
INSERT INTO DeliveryAssignment VALUES ('DE018', 'R006', 'D')
INSERT INTO DeliveryAssignment VALUES ('DE020', 'R002', 'D')


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
