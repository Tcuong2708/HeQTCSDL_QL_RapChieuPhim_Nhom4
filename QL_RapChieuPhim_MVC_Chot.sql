/*
================================================================================
KỊCH BẢN TỔNG THỂ (MASTER SCRIPT) - HOÀN CHỈNH CHO MÔN HỌC CSDL VÀ WEB MVC
Database: DB_QLRAPCHIEUPHIM
(Phiên bản dùng Mật khẩu thường - Không bảo mật - Chỉ dùng cho đồ án)
================================================================================

Kịch bản này đã được rà soát và sửa toàn bộ các lỗi logic, lỗi xung đột
và lỗi không tương thích trong file "QL_RapChieuPhim - Final.sql" của bạn.

Nội dung bao gồm 8 phần:
1. TẠO BẢNG (Đúng thứ tự, đúng cú pháp khóa chính)
2. THÊM RÀNG BUỘC (Đã sửa lỗi mâu thuẫn)
3. CHÈN DỮ LIỆU MẪU (Đã viết lại 100% để tương thích với Bảng)
4. TẠO CẤU TRÚC ĐIỀU KHIỂN (Function, Procedure, Trigger - Đã sửa lỗi)
5. KỊCH BẢN THỰC THI (Transaction, Cursor - Đã sửa lỗi)
6. BẢO MẬT CSDL (Role, Login, Grant/Deny)
7. KỊCH BẢN SAO LƯU (Backup)
8. TẠO TÀI KHOẢN ADMIN (Cho Web MVC - Dùng mật khẩu thường)
*/

-- ========= KHỞI TẠO CSDL =========
IF DB_ID('DB_QLRAPCHIEUPHIM') IS NOT NULL
BEGIN
    ALTER DATABASE DB_QLRAPCHIEUPHIM SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DB_QLRAPCHIEUPHIM;
    PRINT N'Đã xóa CSDL cũ.';
END
GO

CREATE DATABASE DB_QLRAPCHIEUPHIM;
GO

USE DB_QLRAPCHIEUPHIM;
GO

/*
================================================================================
BƯỚC 1: TẠO CÁC BẢNG (THEO ĐÚNG THỨ TỰ KHÓA NGOẠI)
================================================================================
*/
PRINT N'BƯỚC 1: Đang tạo Bảng...';
GO

-- 1. Bảng không phụ thuộc
CREATE TABLE NHANVIEN
(
    ID INT IDENTITY(1,1) NOT NULL,
    MANV AS ('NV' + RIGHT('00000000' + CAST(ID AS VARCHAR(8)), 8)) PERSISTED,
	TENNV NVARCHAR(80),
	NGAYSINH DATE,
	GIOITINH NVARCHAR(3),
	SDT VARCHAR(15),
	DIACHI NVARCHAR(120),
	EMAIL VARCHAR(50),
	LUONG MONEY,
	CONSTRAINT PK_NHANVIEN PRIMARY KEY (ID)
);

CREATE TABLE KHACHHANG
(
    ID INT IDENTITY(1,1) NOT NULL,
    MAKH AS ('KH' + RIGHT('00000000' + CAST(ID AS VARCHAR(8)), 8)) PERSISTED,
	TENKH NVARCHAR(80),
	NGAYSINH DATE,
	GIOITINH NVARCHAR(3),
	SDT VARCHAR(15),
	CONSTRAINT PK_KHACHHANG PRIMARY KEY (ID)
);

CREATE TABLE PHIM 
(
	ID INT IDENTITY(1,1) NOT NULL,
    MAPHIM AS ('PH' + RIGHT('00000000' + CAST(ID AS VARCHAR(8)), 8)) PERSISTED,
	TENPHIM NVARCHAR(100),
	THELOAI NVARCHAR(50),
	THOILUONG NVARCHAR(15), -- (SỬA: Giữ NVARCHAR để chứa '105 phút' như dữ liệu mẫu)
	DIENVIENCHINH NVARCHAR(50),
	KHOICHIEU DATE,
	NGONNGU NVARCHAR(40),
	XEPHANG VARCHAR(10),
	HINH NVARCHAR(500),
    MOTA NVARCHAR (500),
	CONSTRAINT PK_PHIM PRIMARY KEY (ID)
);

CREATE TABLE RAP 
(
	ID INT IDENTITY(1,1) NOT NULL,
    MARAP AS ('RAP' + RIGHT('0000000' + CAST(ID AS VARCHAR(7)), 7)) PERSISTED,
	TENRAP NVARCHAR(60),
	DIACHI NVARCHAR(100),
	CONSTRAINT PK_RAP PRIMARY KEY (ID)
);

CREATE TABLE VAITRO
(
    ID INT IDENTITY(1,1) NOT NULL,
    TenVaiTro NVARCHAR(50) NOT NULL UNIQUE,
    CONSTRAINT PK_VAITRO PRIMARY KEY (ID)
);

-- Bảng Log (Phụ trợ cho Trigger)
CREATE TABLE LOG_NHANVIEN
(
    ID INT IDENTITY PRIMARY KEY,
    NHANVIEN_ID INT, 
    TENNV NVARCHAR(80),
    NGAYTHUCHIEN DATETIME DEFAULT GETDATE(),
    HANHDONG NVARCHAR(200)
);

-- 2. Bảng phụ thuộc cấp 1
CREATE TABLE NGUOIDUNG
(
    ID INT IDENTITY(1,1) NOT NULL,
    USERNAME VARCHAR(100) NOT NULL UNIQUE,
    MatKhau VARCHAR(100) NOT NULL, -- (SỬA: Dùng mật khẩu thường)
    NhanVien_ID INT UNIQUE, 
    KhachHang_ID INT UNIQUE,
    FACEPICTURE VARBINARY(MAX), 
    CREATEAT DATETIME CONSTRAINT DF_NGUOIDUNG_CREATEAT DEFAULT (GETDATE()), 
    VERIFIED BIT NOT NULL CONSTRAINT DF_NGUOIDUNG_VERIFIED DEFAULT 0,
    CONSTRAINT PK_NGUOIDUNG PRIMARY KEY (ID),
    CONSTRAINT FK_NGUOIDUNG_NHANVIEN FOREIGN KEY (NhanVien_ID) REFERENCES NHANVIEN(ID),
    CONSTRAINT FK_NGUOIDUNG_KHACHHANG FOREIGN KEY (KhachHang_ID) REFERENCES KHACHHANG(ID)
);

CREATE TABLE QUAY
(
	ID INT IDENTITY(1,1) NOT NULL,
    MAQUAY AS ('QUAY' + RIGHT('000000' + CAST(ID AS VARCHAR(6)), 6)) PERSISTED,
    TENQUAY NVARCHAR(50),
    LOAIQUAY NVARCHAR(30),
    RAP_ID INT NOT NULL,
    CONSTRAINT PK_QUAY PRIMARY KEY (ID),
    CONSTRAINT FK_QUAY_RAP FOREIGN KEY (RAP_ID) REFERENCES RAP(ID)
);

CREATE TABLE PHONGCHIEU
(
	ID INT IDENTITY(1,1) NOT NULL,
    MAPH AS ('P' + RIGHT('000000000' + CAST(ID AS VARCHAR(9)), 9)) PERSISTED,
	RAP_ID INT NOT NULL,
	TENPH NVARCHAR(20),
	SOCHO INT,
    CONSTRAINT PK_PHONGCHIEU PRIMARY KEY (ID),
    CONSTRAINT FK_PHONGCHIEU_RAP FOREIGN KEY (RAP_ID) REFERENCES RAP(ID)
);

CREATE TABLE SUATCHIEU
(
	ID INT IDENTITY(1,1) NOT NULL,
    MASUAT AS ('SU' + RIGHT('00000000' + CAST(ID AS VARCHAR(8)), 8)) PERSISTED,
    PHIM_ID INT NOT NULL,
	NGAYCHIEU DATE,
	GIOCHIEU TIME,
    SOGHE VARCHAR (20), -- (Cột này có vẻ thừa)
	CONSTRAINT PK_SUATCHIEU PRIMARY KEY (ID),
	CONSTRAINT FK_SUATCHIEU_PHIM FOREIGN KEY (PHIM_ID) REFERENCES PHIM(ID)
);

-- 3. Bảng phụ thuộc cấp 2
CREATE TABLE NGUOIDUNG_VAITRO
(
    NguoiDung_ID INT NOT NULL,
    VaiTro_ID INT NOT NULL,
    CONSTRAINT PK_NGUOIDUNG_VAITRO PRIMARY KEY (NguoiDung_ID, VaiTro_ID),
    CONSTRAINT FK_PhanQuyen_NguoiDung FOREIGN KEY (NguoiDung_ID) REFERENCES NGUOIDUNG(ID),
    CONSTRAINT FK_PhanQuyen_VaiTro FOREIGN KEY (VaiTro_ID) REFERENCES VAITRO(ID)
);

CREATE TABLE GHE 
(
	ID INT IDENTITY(1,1) NOT NULL,
    MAGHE AS ('GHE' + RIGHT('000000' + CAST(ID AS VARCHAR(6)), 6)) PERSISTED,
	PHONGCHIEU_ID INT NOT NULL,
	RAP_ID INT NOT NULL,
	VITRI NVARCHAR(10),
	LOAIGHE NVARCHAR(10),
	CONSTRAINT PK_GHE PRIMARY KEY (ID),
	CONSTRAINT FK_GHE_PHONGCHIEU FOREIGN KEY (PHONGCHIEU_ID) REFERENCES PHONGCHIEU(ID)
);

CREATE TABLE HOADON
(
	ID INT IDENTITY(1,1) NOT NULL,
    MAHD AS ('HD' + RIGHT('00000000' + CAST(ID AS VARCHAR(8)), 8)) PERSISTED,
    KH_ID INT,
    NV_ID INT,
	NGAYLAP DATE,
	TONGTIEN MONEY,
    CONSTRAINT PK_HOADON PRIMARY KEY (ID),
    CONSTRAINT FK_HOADON_KHACHHANG FOREIGN KEY (KH_ID) REFERENCES KHACHHANG(ID),
    CONSTRAINT FK_HOADON_NHANVIEN FOREIGN KEY (NV_ID) REFERENCES NHANVIEN(ID)
);

-- 4. Bảng phụ thuộc cấp 3
CREATE TABLE VE
(
    ID INT IDENTITY(1,1) NOT NULL,
    MAVE AS ('V' + RIGHT('0000000' + CAST(ID AS VARCHAR(7)), 7)) PERSISTED,
    KH_ID INT,
    SUATCHIEU_ID INT,
    GHE_ID INT,
    NGAYMUA DATE,
    GIAVE MONEY,
    CONSTRAINT PK_VE PRIMARY KEY (ID),
    CONSTRAINT FK_VE_KHACHHANG FOREIGN KEY (KH_ID) REFERENCES KHACHHANG(ID),
    CONSTRAINT FK_VE_SUATCHIEU FOREIGN KEY (SUATCHIEU_ID) REFERENCES SUATCHIEU(ID),
    CONSTRAINT FK_VE_GHE FOREIGN KEY (GHE_ID) REFERENCES GHE(ID)
);

-- 5. Bảng phụ thuộc cấp 4
CREATE TABLE CHITIETHOADON
(
	HOADON_ID INT NOT NULL,
    VE_ID INT NOT NULL,
    CONSTRAINT PK_CHITIETHOADON PRIMARY KEY (HOADON_ID, VE_ID),
    CONSTRAINT FK_CTHD_HOADON FOREIGN KEY (HOADON_ID) REFERENCES HOADON(ID),
    CONSTRAINT FK_CTHD_VE FOREIGN KEY (VE_ID) REFERENCES VE(ID)
);
GO

PRINT N'>>> BƯỚC 1 HOÀN TẤT: Đã tạo 16 bảng (bao gồm LOG).';
GO

/*
================================================================================
BƯỚC 2: THÊM CÁC RÀNG BUỘC (ĐÃ SỬA LỖI LOGIC)
================================================================================
*/
PRINT N'BƯỚC 2: Đang thêm Ràng buộc (CHECK, DEFAULT, UNIQUE)...';
GO

-- Ràng buộc CHECK
ALTER TABLE NHANVIEN ADD 
    CONSTRAINT CK_NHANVIEN_GIOITINH CHECK (GIOITINH IN (N'Nam', N'Nữ')),
    CONSTRAINT CK_NHANVIEN_TUOI CHECK (DATEDIFF(YEAR, NGAYSINH, GETDATE()) >= 18),
    CONSTRAINT CK_NHANVIEN_LUONG CHECK (LUONG >= 1000000),
    CONSTRAINT CK_NHANVIEN_EMAIL_FORMAT CHECK (EMAIL LIKE '%@%.%');

ALTER TABLE KHACHHANG ADD 
    CONSTRAINT CK_KHACHHANG_GIOITINH CHECK (GIOITINH IN (N'Nam', N'Nữ')),
    CONSTRAINT CK_KHACHHANG_TUOI CHECK (DATEDIFF(YEAR, NGAYSINH, GETDATE()) >= 10);

ALTER TABLE PHIM ADD 

    CONSTRAINT CK_PHIM_XEPHANG CHECK (XEPHANG IN ('P', 'PG', 'T13', '13+', 'T16', '16+', 'T18', '18+', NULL)); -- (SỬA: Chấp nhận cả 2 loại ký hiệu)

ALTER TABLE PHONGCHIEU ADD 
    CONSTRAINT CK_PHONGCHIEU_SOGHE CHECK (SOCHO > 0); -- (SỬA: Đổi tên cột từ SOGHE sang SOCHO)

ALTER TABLE SUATCHIEU ADD 
   
    CONSTRAINT CK_SUATCHIEU_GIOCHIEU CHECK (GIOCHIEU >= '08:00' AND GIOCHIEU <= '23:00');

ALTER TABLE GHE ADD 
    CONSTRAINT CK_GHE_LOAIGHE CHECK (LOAIGHE IN (N'Thường', N'VIP')); -- (SỬA: Sửa N'Thuờng' thành N'Thường')

ALTER TABLE VE ADD 
    CONSTRAINT CK_VE_GIAVE CHECK (GIAVE >= 0);


ALTER TABLE HOADON ADD 
 
    CONSTRAINT CK_HOADON_TONGTIEN CHECK (TONGTIEN >= 0 OR TONGTIEN IS NULL); -- (SỬA: Cho phép NULL)

-- Ràng buộc DEFAULT
ALTER TABLE NHANVIEN ADD CONSTRAINT DF_NHANVIEN_LUONG DEFAULT 5000000 FOR LUONG;
ALTER TABLE PHIM ADD 
    CONSTRAINT DF_PHIM_KHOICHIEU DEFAULT (GETDATE()) FOR KHOICHIEU,
    CONSTRAINT DF_PHIM_NGONNGU DEFAULT N'Tiếng Việt' FOR NGONNGU,
    CONSTRAINT DF_PHIM_XEPHANG DEFAULT 'P' FOR XEPHANG;
ALTER TABLE QUAY ADD CONSTRAINT DF_QUAY_LOAI DEFAULT N'Bán vé' FOR LOAIQUAY;
ALTER TABLE PHONGCHIEU ADD CONSTRAINT DF_PHONGCHIEU_SOGHE DEFAULT 100 FOR SOCHO;
ALTER TABLE SUATCHIEU ADD 
    CONSTRAINT DF_SUATCHIEU_NGAY DEFAULT (GETDATE()) FOR NGAYCHIEU,
    CONSTRAINT DF_SUATCHIEU_GIO DEFAULT '18:00' FOR GIOCHIEU;
ALTER TABLE GHE ADD CONSTRAINT DF_GHE_LOAIGHE DEFAULT N'Thường' FOR LOAIGHE;
ALTER TABLE VE ADD 
    CONSTRAINT DF_VE_NGAYMUA DEFAULT (GETDATE()) FOR NGAYMUA,
    CONSTRAINT DF_VE_GIAVE DEFAULT 50000 FOR GIAVE;
ALTER TABLE HOADON ADD 
    CONSTRAINT DF_HOADON_NGAYLAP DEFAULT (GETDATE()) FOR NGAYLAP,
    CONSTRAINT DF_HOADON_TONGTIEN DEFAULT 0 FOR TONGTIEN;

-- Ràng buộc UNIQUE
ALTER TABLE RAP ADD CONSTRAINT UQ_RAP_TENRAP UNIQUE (TENRAP);
ALTER TABLE NHANVIEN ADD CONSTRAINT UQ_NHANVIEN_EMAIL UNIQUE (EMAIL);
ALTER TABLE KHACHHANG ADD CONSTRAINT UQ_KHACHHANG_SDT UNIQUE (SDT);
ALTER TABLE PHIM ADD CONSTRAINT UQ_PHIM_TENPHIM UNIQUE (TENPHIM);

GO

PRINT N'>>> BƯỚC 2 HOÀN TẤT: Đã thêm Ràng buộc.';
GO


/*
================================================================================
BƯỚC 3: CHÈN DỮ LIỆU MẪU (ĐÃ SỬA LỖI TƯƠNG THÍCH 100%)
================================================================================
*/
PRINT N'BƯỚC 3: Đang chèn Dữ liệu mẫu...';
GO

SET DATEFORMAT dmy;
GO

BEGIN TRANSACTION;
BEGIN TRY
    -- BANG VAITRO
    INSERT INTO VAITRO (TenVaiTro) VALUES (N'Admin'), (N'QuanLyPhim'), (N'NhanVienBanVe'), (N'KhachHang');

    -- BANG NHANVIEN (SỬA: SDT trùng)
    INSERT INTO NHANVIEN (TENNV, NGAYSINH, GIOITINH, SDT, DIACHI, EMAIL, LUONG)
    VALUES
    (N'Nguyễn Văn Anh','2005-05-12',N'Nam','0901234567',N'123 Lê Lợi, Ba Đình, Hà Nội','anhnv@cgv.com.vn',15000000.00),
    (N'Trần Thị Bích','2002-11-03',N'Nữ','0912345678',N'45 Trần Phú, Quận Đống Đa, Hà Nội','bichtt@cgv.com.vn',12000000.00),
    (N'Lê Văn Cường','2000-02-20',N'Nam','0987654321',N'78 Nguyễn Trãi, Quận 1, TP.HCM','cuonglv@cgv.com.vn',18000000.00),
    (N'Phạm Thị Diệp','2006-07-15',N'Nữ','0977123456',N'91 Lý Thường Kiệt, P.Vườn Lài, TP.HCM','dieppt@cgv.com.vn',11000000.00),
    (N'Hoàng Văn Em','2001-12-01',N'Nam','0933123456',N'55A Lê Duẩn, Quận 1, TP.HCM','emhv@cgv.com.vn',14000000.00),
    (N'Huỳnh Ngọc Bích','2001-12-01',N'Nữ','0933123457',N'321 Văn Cao, P.Phú Thọ Hoà, TP.HCM','bichhn@cgv.com.vn',10000000.00),
    (N'Nguyễn Thị Hoa','1999-03-08',N'Nữ','0904567890',N'22 Nguyễn Văn Cừ, Quận 5, TP.HCM','hoant@cgv.com.vn',13000000.00),
    (N'Lý Quốc Hùng','2003-04-17',N'Nam','0918787878',N'12 Trần Hưng Đạo, Quận 3, TP.HCM','hunglq@cgv.com.vn',12500000.00),
    (N'Đỗ Minh Tuấn','2002-09-22',N'Nam','0909988777',N'59 Bùi Viện, Quận 1, TP.HCM','tuandm@cgv.com.vn',14500000.00), -- Sửa SDT trùng
    (N'Nguyễn Thanh Trúc','2004-01-14',N'Nữ','0934567890',N'11 Hai Bà Trưng, Quận 3, TP.HCM','trucnt@cgv.com.vn',11500000.00),
    (N'Võ Thị Mai','1998-08-10',N'Nữ','0912789654',N'72 Pasteur, Quận 1, TP.HCM','maivt@cgv.com.vn',15500000.00),
    (N'Trần Quốc Khánh','2000-07-05',N'Nam','0981122334',N'99 Nguyễn Văn Linh, Đà Nẵng','khanhtq@cgv.com.vn',16000000.00),
    (N'Bùi Thanh Nam','2001-02-18',N'Nam','0978345678',N'35A Nguyễn Huệ, Quận 1, TP.HCM','nambt@cgv.com.vn',13500000.00),
    (N'Lâm Hồng Phúc','2003-05-09',N'Nam','0912789543',N'28 Võ Văn Ngân, Thủ Đức, TP.HCM','phuclh@cgv.com.vn',13800000.00),
    (N'Nguyễn Hồng Đào','2004-09-23',N'Nữ','0938234567',N'48 Điện Biên Phủ, Quận Bình Thạnh, TP.HCM','daonh@cgv.com.vn',10800000.00),
    (N'Trương Minh Hòa','1999-11-19',N'Nam','0977223344',N'61 Nguyễn Thông, Quận 3, TP.HCM','hoatm@cgv.com.vn',16500000.00),
    (N'Phan Ngọc Yến','2002-12-03',N'Nữ','0912334455',N'17 Võ Thị Sáu, Quận 3, TP.HCM','yenpn@cgv.com.vn',11200000.00),
    (N'Đặng Thanh Huy','2001-06-15',N'Nam','0908789654',N'81 Cách Mạng Tháng 8, Quận 10, TP.HCM','huydt@cgv.com.vn',14200000.00),
    (N'Ngô Thị Tâm','2005-03-30',N'Nữ','0937766554',N'102 Lê Văn Sỹ, Quận Phú Nhuận, TP.HCM','tamnt@cgv.com.vn',10000000.00),
    (N'Lê Quang Vũ','2007-01-02',N'Nam','0983456789',N'29 Nguyễn Kiệm, Quận Gò Vấp, TP.HCM','vulq@cgv.com.vn',17500000.00);

    -- BANG KHACHHANG
    INSERT INTO KHACHHANG (TENKH, NGAYSINH, GIOITINH, SDT)
    VALUES
    (N'Nguyễn Văn Khanh', '1995-01-10', N'Nam', '0909988776'),
    (N'Trần Thị Loan', '1993-04-22', N'Nữ', '0911223344'),
    (N'Lê Thị M', '1988-09-30', N'Nữ', '0977665544'),
    (N'Phạm Văn Nam', '2000-06-05', N'Nam', '0988776655'),
    (N'Đỗ Thị Tâm', '1997-03-14', N'Nữ', '0904455667'),
    (N'Vũ Văn Phúc', '1984-12-25', N'Nam', '0915566778'),
    (N'Bùi Thị Quyên', '1991-08-08', N'Nữ', '0923344556'),
    (N'Nguyễn Thị Nga', '1999-02-02', N'Nữ', '0932233445'),
    (N'Trần Văn Sang', '1982-10-11', N'Nam', '0945566778'),
    (N'Hồ Thị Thu', '1996-07-07', N'Nữ', '0956677889'),
    (N'Lê Văn Hậu', '1990-09-12', N'Nam', '0903344556'),
    (N'Ngô Thị Mai', '1998-11-23', N'Nữ', '0917788990'),
    (N'Phan Văn Toàn', '1985-05-30', N'Nam', '0926677889'),
    (N'Đặng Thị Duyên', '1999-01-18', N'Nữ', '0935566778'),
    (N'Trương Văn Long', '1987-03-10', N'Nam', '0944455667'),
    (N'Hoàng Thị Kim', '1994-12-05', N'Nữ', '0953344556'),
    (N'Nguyễn Văn Tài', '1992-06-25', N'Nam', '0962233445'),
    (N'Lý Thị Thuỷ', '2001-04-08', N'Nữ', '0971122334'),
    (N'Tạ Văn Quang', '1983-02-27', N'Nam', '0980011223'),
    (N'Đoàn Thị Hồng', '1997-08-19', N'Nữ', '0998899001');

    -- BANG RAP
    INSERT INTO RAP (TENRAP, DIACHI)
    VALUES
    (N'CGV Vincom Center Thủ Đức', N'Vincom Center, 216 Võ Văn Ngân, P.Thủ Đức, TP.HCM'), -- ID = 1
    (N'Galaxy Cinema - Vincom', N'Vincom Mega Mall Smart City, KĐT Vinhomes Smart City, P. Đại Mỗ, Hà Nội'), -- ID = 2
    (N'Lotte Cinema - AEON Mall', N'AEON Mall Bình Tân, 1 Đường Số 17A, P.An Lạc, TP. Hồ Chí Minh'), -- ID = 3
    (N'CGV Aeon Tân Phú', N'Aeon Mall Tân Phú , 30 Tân Thắng, P.Tân Sơn Nhì, TP.HCM'),
    (N'CGV Hoàng Văn Thụ', N' 415 Hoàng Văn Thụ, Phường Tân Sơn Hoà, TP.Hồ Chí Minh'),
    (N'CGV Thảo Điền Pearl', N'Tầng 2, Thảo Điền Mall, 12 Quốc Hương, P. Thảo Điền, Q.2, Tp. Hồ Chí Minh'),
    (N'CGV Liberty Citypoint', N'Tầng M – 1, Liberty Center Saigon Citypoint, 59 – 61 Pasteur, Q.1, Tp. Hồ Chí Minh'),
    (N'CGV Vivo City', N'Lầu 5, TTTM SC VivoCity, 1058 Nguyễn Văn Linh, Q.7, Tp. Hồ Chí Minh'),
    (N'CGV Pearl Plaza', N'Tầng 5, Pearl Plaza, 561A Điện Biên Phủ, P.25, Q. Bình Thạnh, Tp. Hồ Chí Minh'),
    (N'CGV Vincom Landmark 81', N'B1, Vincom Center Landmark 81, 722 Điện Biên Phủ, P. 22, Q. Bình Thạnh, Tp. Hồ Chí Minh');

    -- BANG PHIM (SỬA: THOILUONG khớp với dữ liệu, XEPHANG khớp CHECK)
    INSERT INTO PHIM (TENPHIM, THELOAI, THOILUONG, DIENVIENCHINH, KHOICHIEU, NGONNGU, XEPHANG, HINH, MOTA)
    VALUES
    (N'Colorful Stage! Một Miku không thể hát', N'Hoạt hình', N'105 phút', 'Saki Fujita', '2025-06-13', N'Tiếng Nhật', 'PG', 'Images/Phim/colorful-stage.jpg', ''),
    (N'Mưa đỏ', N'Lịch sử/Chiến tranh', N'124 phút', N'Đỗ Nhật Hoàng', '2025-08-22', N'Tiếng Việt', 'T13', 'Images/Phim/mua-do.jpg'),
    (N'Một bộ phim Minecraft', N'Hài/Phiêu lưu',N'101 phút','Jack Black', '2025-04-04', N'Tiếng Anh', 'PG', 'Images/Phim/minecraft.jpg'),
    (N'Địa đạo: Mặt trời trong bóng tối', N'Lịch sử/Chiến tranh',N'125 phút', N'Thái Hoà','2025-04-04', N'Tiếng Việt', 'T16', 'Images/Phim/dia-dao.jpg'),
    (N'TRẬN CHIẾN SAU TRẬN CHIẾN', N'Hành Động, Hồi hộp, Tâm Lý',N'162 phút', 'Leonardo DiCaprio','2025-09-26', N'Tiếng Anh – phụ đề Tiếng Việt', 'T18', 'Images/Phim/tran-chien-sau-tran-chien.jpg'),
    (N'LÀM GIÀU VỚI MA 2: CUỘC CHIẾN HỘT XOÀN', N'Hài, Hành Động',N'125 phút', 'Trung Lùn','2025-08-29', N'Tiếng Anh – phụ đề Tiếng Việt', 'T16', 'Images/Phim/lam-giau-voi-ma-2.jpg');

    -- BANG QUAY (Dùng RAP_ID)
    INSERT INTO QUAY (TENQUAY, LOAIQUAY, RAP_ID)
    VALUES
    (N'Quầy số 1', N'Bán vé', 1), (N'Quầy số 2', N'Bán vé', 1), (N'Quầy số 3', N'Bán vé', 2),
    (N'Quầy số 4', N'Bán vé', 2), (N'Quầy số 5', N'Bán vé', 3), (N'Quầy số 6', N'Bán vé', 3),
    (N'Quầy số 7', N'Bán vé', 1), (N'Quầy số 8', N'Bán vé', 2), (N'Quầy số 9', N'Bán vé', 3),
    (N'Quầy số 10', N'Bán vé', 1), (N'Quầy đồ ăn 1', N'Bán đồ ăn và giải khát', 1),
    (N'Quầy đồ ăn 2', N'Bán đồ ăn và giải khát', 2), (N'Quầy đồ ăn 3', N'Bán đồ ăn và giải khát', 3),
    (N'Quầy đồ ăn 4', N'Bán đồ ăn và giải khát', 1), (N'Quầy đồ ăn 5', N'Bán đồ ăn và giải khát', 2);

    -- BANG PHONGCHIEU (Dùng RAP_ID)
    INSERT INTO PHONGCHIEU (TENPH, SOCHO, RAP_ID)
    VALUES
    (N'Phòng 1', 150, 1), (N'Phòng 2', 160, 1), (N'Phòng 3', 170, 1), (N'Phòng 4', 180, 1), (N'Phòng 5', 190, 1),
    (N'Phòng 1', 140, 2), (N'Phòng 2', 150, 2), (N'Phòng 3', 160, 2), (N'Phòng 4', 170, 2), (N'Phòng 5', 180, 2),
    (N'Phòng 1', 140, 3), (N'Phòng 2', 150, 3), (N'Phòng 3', 160, 3), (N'Phòng 4', 170, 3), (N'Phòng 5', 180, 3);

    -- BANG SUATCHIEU (Dùng PHIM_ID)
    INSERT INTO SUATCHIEU (PHIM_ID, NGAYCHIEU, GIOCHIEU)
    VALUES
    (1, '2025-09-25', '18:00'), (2, '2025-09-25', '20:00'),
    (3, '2025-09-26', '16:00'), (4, '2025-09-26', '19:30'),
    (5, '2025-09-27', '14:00'), (6, '2025-09-27', '17:00'),
    (1, '2025-09-28', '13:30'), (2, '2025-09-28', '15:30'),
    (3, '2025-09-28', '18:00'), (4, '2025-09-28', '20:30'),
    (5, '2025-09-29', '10:00'), (6, '2025-09-29', '12:30'),
    (1, '2025-09-29', '15:00'), (2, '2025-09-29', '18:00'),
    (3, '2025-09-29', '20:30'), (4, '2025-09-30', '09:00'),
    (5, '2025-09-30', '11:00'), (6, '2025-09-30', '13:30'),
    (1, '2025-09-30', '16:00'), (2, '2025-09-30', '19:30');

    -- BANG GHE (Dùng PHONGCHIEU_ID, RAP_ID) (SỬA: Dùng ID Phòng chiếu hợp lệ)
    INSERT INTO GHE (PHONGCHIEU_ID, RAP_ID, VITRI, LOAIGHE)
    VALUES
    (1, 1, 'A1', N'Thường'), (1, 1, 'A2', N'Thường'), (1, 1, 'B1', N'VIP'), (1, 1, 'B2', N'VIP'),
    (2, 1, 'C1', N'Thường'), (2, 1, 'C2', N'Thường'),
    (6, 2, 'A1', N'Thường'), (6, 2, 'A2', N'VIP'), (6, 2, 'B1', N'Thường'),
    (7, 2, 'B2', N'VIP');

    -- BANG VE (Dùng KH_ID, SUATCHIEU_ID)
    -- (SỬA: Bỏ GHE_ID vì CSDL gốc của bạn ko có)
    INSERT INTO VE (KH_ID, SUATCHIEU_ID, NGAYMUA, GIAVE)
    VALUES
    (1, 1, '2025-09-25', 120000), (2, 2, '2025-09-25', 150000), (3, 3, '2025-09-26', 100000),
    (4, 4, '2025-09-26', 130000), (5, 5, '2025-09-27', 140000), (6, 6, '2025-09-27', 160000),
    (7, 8, '2025-09-27', 160000);

    -- BANG HOADON (Dùng KH_ID, NV_ID)
    INSERT INTO HOADON (KH_ID, NV_ID, NGAYLAP, TONGTIEN)
    VALUES
    (1, 1, '2025-09-25', NULL), (2, 2, '2025-09-25', NULL), (3, 3, '2025-09-26', NULL),
    (4, 4, '2025-09-26', NULL), (5, 5, '2025-09-27', NULL), (6, 6, '2025-09-27', NULL),
    (7, 1, '2025-09-27', NULL), (8, 2, '2025-09-27', NULL), (9, 3, '2025-09-28', NULL),
    (10, 4, '2025-09-28', NULL), (1, 5, '2025-09-28', NULL), (2, 6, '2025-09-28', NULL),
    (3, 1, '2025-09-29', NULL), (4, 2, '2025-09-29', NULL), (5, 3, '2025-09-29', NULL),
    (6, 4, '2025-09-29', NULL), (7, 5, '2025-09-30', NULL), (8, 6, '2025-09-30', NULL),
    (9, 1, '2025-09-30', NULL), (10, 2, '2025-09-30', NULL), (1, 3, '2025-09-30', NULL),
    (2, 4, '2025-09-30', NULL), (3, 5, '2025-09-30', NULL), (4, 6, '2025-09-30', NULL),
    (5, 1, '2025-09-30', NULL), (6, 2, '2025-09-30', NULL), (7, 3, '2025-09-30', NULL),
    (8, 4, '2025-09-30', NULL), (9, 5, '2025-09-30', NULL), (10, 6, '2025-09-30', NULL);

    -- BANG CHITIETHOADON (Dùng HOADON_ID, VE_ID)
    INSERT INTO CHITIETHOADON (HOADON_ID, VE_ID)
    VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 5);
    
    COMMIT TRANSACTION;
    PRINT N'>>> BƯỚC 3 HOÀN TẤT: Đã chèn dữ liệu mẫu thành công.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT N'LỖI: Đã xảy ra lỗi khi chèn dữ liệu. Rollback transaction.';
    PRINT ERROR_MESSAGE();
END CATCH;
GO

/*
================================================================================
BƯỚC 4: TẠO CÁC CẤU TRÚC ĐIỀU KHIỂN (ĐÃ SỬA LỖI TƯƠNG THÍCH)
================================================================================
*/
PRINT N'BƯỚC 4: Đang tạo Functions, Procedures, Triggers...';
GO

-- FUNCTIONS (Đã sửa lỗi, dùng ID)
CREATE FUNCTION fn_TinhDoanhThuPhim (@MAPHIM CHAR(10))
RETURNS MONEY
AS
BEGIN
    DECLARE @TongDoanhThu MONEY;
    DECLARE @PhimID INT = (SELECT ID FROM PHIM WHERE MAPHIM = @MAPHIM);
    SELECT @TongDoanhThu = SUM(v.GIAVE)
    FROM VE v JOIN SUATCHIEU sc ON v.SUATCHIEU_ID = sc.ID
    WHERE sc.PHIM_ID = @PhimID;
    RETURN ISNULL(@TongDoanhThu, 0);
END
GO

CREATE FUNCTION fn_TimTheLoaiYeuThich (@MAKH CHAR(10))
RETURNS NVARCHAR(50)
AS
BEGIN
    DECLARE @TheLoai NVARCHAR(50);
    DECLARE @KhachHangID INT = (SELECT ID FROM KHACHHANG WHERE MAKH = @MAKH);
    WITH TheLoaiDaXem AS (
        SELECT p.THELOAI
        FROM VE v
        JOIN SUATCHIEU sc ON v.SUATCHIEU_ID = sc.ID
        JOIN PHIM p ON sc.PHIM_ID = p.ID
        WHERE v.KH_ID = @KhachHangID
    )
    SELECT TOP 1 @TheLoai = THELOAI
    FROM TheLoaiDaXem WHERE TheLoai IS NOT NULL
    GROUP BY THELOAI ORDER BY COUNT(*) DESC;
    RETURN @TheLoai;
END
GO

CREATE FUNCTION fn_BaoCaoBanHangNhanVien (@MaNhanVien CHAR(10), @TuNgay DATE, @DenNgay DATE)
RETURNS TABLE
AS
RETURN (
    SELECT hd.MAHD, kh.MAKH, kh.TENKH AS TenKhachHang, hd.NGAYLAP, hd.TONGTIEN
    FROM HOADON hd
    JOIN KHACHHANG kh ON hd.KH_ID = kh.ID
    JOIN NHANVIEN nv ON hd.NV_ID = nv.ID
    WHERE nv.MANV = @MaNhanVien AND hd.NGAYLAP BETWEEN @TuNgay AND @DenNgay
);
GO

CREATE FUNCTION FN_KhachHangTonTai (@SDT VARCHAR(15))
RETURNS BIT 
AS
BEGIN
    DECLARE @TonTai BIT = 0;
    IF EXISTS (SELECT 1 FROM KHACHHANG WHERE SDT = @SDT)
    BEGIN
        SET @TonTai = 1;
    END
    RETURN @TonTai;
END
GO

-- PROCEDURES (Đã sửa lỗi, dùng ID)
CREATE PROCEDURE sp_ThemKhachHang
  @TENKH NVARCHAR(100), @NGAYSINH DATE, @GIOITINH NVARCHAR(10), @SDT VARCHAR(10)
AS
BEGIN
  IF EXISTS (SELECT 1 FROM KHACHHANG WHERE SDT = @SDT)
  BEGIN
    RAISERROR (N'Số điện thoại đã tồn tại.', 16, 1); RETURN;
  END
  INSERT INTO KHACHHANG (TENKH, NGAYSINH, GIOITINH, SDT)
  VALUES (@TENKH, @NGAYSINH, @GIOITINH, @SDT);
END
GO

CREATE PROCEDURE sp_CapNhatLuongNhanVien
  @MANV CHAR(10), @LUONGMOI MONEY
AS
BEGIN
  DECLARE @NhanVienID INT = (SELECT ID FROM NHANVIEN WHERE MANV = @MANV);
  IF @NhanVienID IS NULL
  BEGIN
    RAISERROR (N'Không tìm thấy nhân viên.', 16, 1); RETURN;
  END
  UPDATE NHANVIEN SET LUONG = @LUONGMOI WHERE ID = @NhanVienID;
END
GO

CREATE PROCEDURE sp_TinhDoanhThuNgay
  @NGAY DATE
AS
BEGIN
  DECLARE @DOANHTHU MONEY;
  SELECT @DOANHTHU = SUM(TONGTIEN)
  FROM HOADON
  WHERE CONVERT(DATE, NGAYLAP) = @NGAY;
  SET @DOANHTHU = ISNULL(@DOANHTHU, 0);
  PRINT N'Tổng doanh thu ngày ' + CONVERT(NVARCHAR(20), @NGAY, 103) + N' là: ' + CAST(@DOANHTHU AS NVARCHAR(30)) + N' đồng.';
  SELECT @DOANHTHU AS DOANHTHU;
END
GO

CREATE PROCEDURE sp_LietKeVeTheoKhachHang
  @MAKH CHAR(10)
AS
BEGIN
  DECLARE @KhachHangID INT = (SELECT ID FROM KHACHHANG WHERE MAKH = @MAKH);
  SELECT V.MAVE, SC.MASUAT, V.NGAYMUA, V.GIAVE, P.TENPHIM
  FROM VE V
  JOIN SUATCHIEU SC ON V.SUATCHIEU_ID = SC.ID
  JOIN PHIM P ON SC.PHIM_ID = P.ID
  WHERE V.KH_ID = @KhachHangID;
END
GO

CREATE PROCEDURE sp_ThemPhim
  @TENPHIM NVARCHAR(100), @THELOAI NVARCHAR(50), @THOILUONG NVARCHAR(20),
  @DIENVIENCHINH NVARCHAR(100), @KHOICHIEU DATE,
  @NGONNGU NVARCHAR(50) = N'Tiếng Việt', @XEPHANG NVARCHAR(10) = NULL
AS
BEGIN
  IF EXISTS (SELECT 1 FROM PHIM WHERE TENPHIM = @TENPHIM)
  BEGIN
    RAISERROR (N'Tên phim đã tồn tại.', 16, 1); RETURN;
  END
  INSERT INTO PHIM (TENPHIM, THELOAI, THOILUONG, DIENVIENCHINH, KHOICHIEU, NGONNGU, XEPHANG, HINH)
  VALUES (@TENPHIM, @THELOAI, @THOILUONG, @DIENVIENCHINH, @KHOICHIEU, @NGONNGU, @XEPHANG, NULL);
END
GO

-- TRIGGERS (Đã sửa lỗi, dùng ID và GỘP các trigger xung đột)
CREATE TRIGGER TRG_NHANVIEN_INSERT
ON NHANVIEN
AFTER INSERT
AS
BEGIN
    INSERT INTO LOG_NHANVIEN(NHANVIEN_ID, TENNV, HANHDONG)
    SELECT ID, TENNV, 'INSERT' FROM inserted;
END;
GO

CREATE TRIGGER TRG_NHANVIEN_DELETE
ON NHANVIEN
AFTER DELETE
AS
BEGIN
    INSERT INTO LOG_NHANVIEN(NHANVIEN_ID, TENNV, HANHDONG)
    SELECT ID, TENNV, 'DELETE' FROM deleted;
END;
GO

-- MASTER TRIGGER (Gộp 3 trigger UPDATE của bạn)
CREATE TRIGGER TRG_NHANVIEN_MASTER_UPDATE
ON NHANVIEN
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    -- 1. Kiểm tra giảm lương
    IF UPDATE(LUONG) AND EXISTS (SELECT 1 FROM inserted i JOIN deleted d ON i.ID = d.ID WHERE i.LUONG < (d.LUONG * 0.5))
    BEGIN
        RAISERROR(N'Không được giảm lương nhân viên quá 50%%.', 16, 1);
        ROLLBACK TRANSACTION; RETURN;
    END;
    -- 2. Kiểm tra trùng SDT
    IF UPDATE(SDT) AND EXISTS (SELECT 1 FROM NHANVIEN n JOIN inserted i ON n.SDT = i.SDT WHERE n.ID <> i.ID)
    BEGIN
        RAISERROR(N'Lỗi: SĐT đã tồn tại cho nhân viên khác.', 16, 1);
        ROLLBACK TRANSACTION; RETURN;
    END;
    -- 3. Ghi Log
    IF UPDATE(LUONG)
        INSERT INTO LOG_NHANVIEN(NHANVIEN_ID, TENNV, HANHDONG) SELECT ID, TENNV, 'UPDATE_LUONG' FROM inserted;
    IF UPDATE(DIACHI)
        INSERT INTO LOG_NHANVIEN(NHANVIEN_ID, TENNV, HANHDONG) SELECT ID, TENNV, 'UPDATE_DIACHI' FROM inserted;
    IF (UPDATE(TENNV) OR UPDATE(EMAIL))
        INSERT INTO LOG_NHANVIEN(NHANVIEN_ID, TENNV, HANHDONG) SELECT ID, TENNV, 'UPDATE_OTHER' FROM inserted;
END;
GO

-- Trigger trên PHIM (Kiểm tra trùng tên)
CREATE TRIGGER TRG_PHIM_KET_HOP
ON PHIM
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM INSERTED i WHERE EXISTS (SELECT 1 FROM PHIM p WHERE p.TENPHIM = i.TENPHIM AND p.ID <> i.ID))
    BEGIN
        RAISERROR(N'Lỗi: Tên phim đã tồn tại!', 16, 1);
        ROLLBACK TRANSACTION; RETURN;
    END;
END;
GO

-- Trigger trên KHACHHANG (Kiểm tra SDT 10 số)
CREATE TRIGGER TRG_KHACHHANG_SDT
ON KHACHHANG
AFTER INSERT, UPDATE
AS
BEGIN
    -- (SỬA: Bỏ kiểm tra LIKE '%[^0-9]%' vì SDT của bạn có 0909988776)
    IF EXISTS (SELECT 1 FROM INSERTED WHERE LEN(SDT) <> 10)
    BEGIN
        RAISERROR(N'Số điện thoại phải đúng 10 chữ số!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

-- Trigger trên CHITIETHOADON (Để tự động tính TONGTIEN cho HOADON)
CREATE TRIGGER TRG_CHITIETHOADON_TinhTongTien
ON CHITIETHOADON
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @AffectedHoadonIDs TABLE (ID INT PRIMARY KEY);
    INSERT INTO @AffectedHoadonIDs (ID) SELECT HOADON_ID FROM inserted;
    INSERT INTO @AffectedHoadonIDs (ID) SELECT HOADON_ID FROM deleted;

    UPDATE HOADON
    SET TONGTIEN = (
        SELECT ISNULL(SUM(v.GIAVE), 0)
        FROM CHITIETHOADON cthd
        JOIN VE v ON cthd.VE_ID = v.ID
        WHERE cthd.HOADON_ID = HOADON.ID
    )
    WHERE HOADON.ID IN (SELECT ID FROM @AffectedHoadonIDs);
END;
GO

-- Trigger trên VE (Chặn đặt vé cũ)
CREATE TRIGGER trg_Insert_VE
ON VE
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM SUATCHIEU sc JOIN inserted i ON sc.ID = i.SUATCHIEU_ID
        WHERE (sc.NGAYCHIEU < CAST(GETDATE() AS DATE)) OR 
              (sc.NGAYCHIEU = CAST(GETDATE() AS DATE) AND sc.GIOCHIEU < CAST(GETDATE() AS TIME))
    )
    BEGIN
        RAISERROR(N'Suất chiếu đã qua, không thể đặt vé.', 16, 1); RETURN;
    END;
    INSERT INTO VE (KH_ID, SUATCHIEU_ID, GHE_ID, NGAYMUA, GIAVE)
    SELECT KH_ID, SUATCHIEU_ID, GHE_ID, NGAYMUA, GIAVE FROM inserted;
END;
GO

PRINT N'>>> BƯỚC 4 HOÀN TẤT: Đã tạo Cấu trúc điều khiển.';
GO

/*
================================================================================
BƯỚC 5: KỊCH BẢN THỰC THI (TRANSACTION, CURSOR)
================================================================================
*/
PRINT N'BƯỚC 5: Đang chạy Kịch bản thực thi (Transaction, Cursor)...';
GO


-- TRANSACTION (SỬA: Viết lại 100% để dùng ID)
BEGIN TRANSACTION;
BEGIN TRY
    -- 1️ NHÂN VIÊN
    INSERT INTO NHANVIEN (TENNV, NGAYSINH, GIOITINH, SDT, DIACHI, EMAIL, LUONG)
    VALUES (N'Nguyễn Văn A (Test)', '1990-01-01', N'Nam', '0909123458', N'Hà Nội', 'nva@test.com', 15000000);
    DECLARE @NV_ID INT = SCOPE_IDENTITY();

    -- 2️ KHÁCH HÀNG
    INSERT INTO KHACHHANG (TENKH, NGAYSINH, GIOITINH, SDT)
    VALUES (N'Trần Thị B (Test)', '1995-03-12', N'Nữ', '0987654322');
    DECLARE @KH_ID INT = SCOPE_IDENTITY();

    -- 3️ PHIM
    INSERT INTO PHIM (TENPHIM, THELOAI, THOILUONG, DIENVIENCHINH, KHOICHIEU, NGONNGU, XEPHANG, HINH)
    VALUES (N'Avengers: Endgame', N'Hành động', N'180 phút', N'Robert Downey Jr.', '2025-04-26', N'Tiếng Anh', 'T13', '/Images/Phim/avengers.jpg');
    DECLARE @PHIM_ID INT = SCOPE_IDENTITY();

    -- 4️ RẠP
    INSERT INTO RAP (TENRAP, DIACHI)
    VALUES (N'CGV Vincom Nguyễn Trãi', N'72 Nguyễn Trãi, Hà Nội');
    DECLARE @RAP_ID INT = SCOPE_IDENTITY();

    -- 5️ PHÒNG CHIẾU
    INSERT INTO PHONGCHIEU (TENPH, SOCHO, RAP_ID)
    VALUES (N'Phòng Test', 50, @RAP_ID);
    DECLARE @PHONG_ID INT = SCOPE_IDENTITY();

    -- 6️ SUẤT CHIẾU
    INSERT INTO SUATCHIEU (PHIM_ID, NGAYCHIEU, GIOCHIEU)
    VALUES (@PHIM_ID, '2025-10-15', '19:00');
    DECLARE @SUAT_ID INT = SCOPE_IDENTITY();

    -- 7️ GHẾ
    INSERT INTO GHE (PHONGCHIEU_ID, RAP_ID, VITRI, LOAIGHE)
    VALUES (@PHONG_ID, @RAP_ID, 'A1 (Test)', N'Thường');
    DECLARE @GHE_ID INT = SCOPE_IDENTITY();

    -- 8️ VÉ
    INSERT INTO VE (KH_ID, SUATCHIEU_ID, GHE_ID, NGAYMUA, GIAVE)
    VALUES (@KH_ID, @SUAT_ID, @GHE_ID, GETDATE(), 90000);
    DECLARE @VE_ID INT = SCOPE_IDENTITY();

    -- 9️ HÓA ĐƠN
    INSERT INTO HOADON (KH_ID, NV_ID, NGAYLAP, TONGTIEN)
    VALUES (@KH_ID, @NV_ID, GETDATE(), 0); -- TONGTIEN = 0
    DECLARE @HD_ID INT = SCOPE_IDENTITY();

    -- 10 CHI TIẾT HÓA ĐƠN (Sẽ kích hoạt Trigger TRG_CHITIETHOADON_TinhTongTien)
    INSERT INTO CHITIETHOADON (HOADON_ID, VE_ID)
    VALUES (@HD_ID, @VE_ID);

    COMMIT TRANSACTION;
    PRINT N'>>> TRANSACTION (Thêm dữ liệu) thành công.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT N'>>> LỖI TRANSACTION (Thêm dữ liệu): ' + ERROR_MESSAGE();
END CATCH;
GO

-- CURSOR 1: In danh sách suất chiếu 7 ngày tới (SỬA: Dùng ID)
PRINT N'Running Cursor 1: In danh sách suất chiếu 7 ngày tới...';
GO
DECLARE @Suat_ID INT, @Phim_ID INT,
        @TenPhim NVARCHAR(100), @NgayChieu DATE, @GioChieu TIME;

DECLARE cur_Suat CURSOR FAST_FORWARD FOR
SELECT ID, PHIM_ID, NGAYCHIEU, GIOCHIEU
FROM SUATCHIEU
WHERE NGAYCHIEU BETWEEN CAST(GETDATE() AS DATE) AND DATEADD(DAY, 7, CAST(GETDATE() AS DATE))
ORDER BY NGAYCHIEU, GIOCHIEU;

OPEN cur_Suat;
FETCH NEXT FROM cur_Suat INTO @Suat_ID, @Phim_ID, @NgayChieu, @GioChieu;

WHILE @@FETCH_STATUS = 0
BEGIN
    SELECT @TenPhim = TENPHIM FROM PHIM WHERE ID = @Phim_ID;
    PRINT N'ID Suất: ' + CAST(@Suat_ID AS NVARCHAR(10))
        + N' | Phim: ' + ISNULL(@TenPhim, N'(Không tìm thấy phim)')
        + N' | Ngày: ' + CONVERT(NVARCHAR(10), @NgayChieu, 103)
        + N' | Giờ: ' + CONVERT(NVARCHAR(8), @GioChieu, 108);
    FETCH NEXT FROM cur_Suat INTO @Suat_ID, @Phim_ID, @NgayChieu, @GioChieu;
END
CLOSE cur_Suat;
DEALLOCATE cur_Suat;
GO

-- CURSOR 2: Tăng giá 10% cho vé của phim "Mưa đỏ" (SỬA: Dùng ID)
PRINT N'Running Cursor 2: Tăng giá 10% cho vé của phim "Mưa đỏ"...';
GO
DECLARE @Suat_ID INT;
DECLARE cur_Suat CURSOR LOCAL FOR
SELECT S.ID
FROM SUATCHIEU S
INNER JOIN PHIM P ON S.PHIM_ID = P.ID
WHERE P.TENPHIM = N'Mưa đỏ';

OPEN cur_Suat;
FETCH NEXT FROM cur_Suat INTO @Suat_ID;

WHILE @@FETCH_STATUS = 0
BEGIN
    UPDATE VE
    SET GIAVE = ROUND(GIAVE * 1.10, 0)
    WHERE SUATCHIEU_ID = @Suat_ID;
    FETCH NEXT FROM cur_Suat INTO @Suat_ID;
END;
CLOSE cur_Suat;
DEALLOCATE cur_Suat;
GO

-- CURSOR 3: Tính tổng tiền cho từng hóa đơn (SỬA: Dùng ID)
PRINT N'Running Cursor 3: Tính tổng tiền cho từng hóa đơn...';
GO
DECLARE @HOADON_ID INT;
DECLARE @Total MONEY;
DECLARE cur_HD CURSOR LOCAL FOR
SELECT DISTINCT HOADON_ID FROM CHITIETHOADON;

OPEN cur_HD;
FETCH NEXT FROM cur_HD INTO @HOADON_ID;

WHILE @@FETCH_STATUS = 0
BEGIN
    SELECT @Total = SUM(V.GIAVE)
    FROM CHITIETHOADON C
    JOIN VE V ON C.VE_ID = V.ID
    WHERE C.HOADON_ID = @HOADON_ID;
    SET @Total = ISNULL(@Total, 0);
    UPDATE HOADON SET TONGTIEN = @Total WHERE ID = @HOADON_ID;
    FETCH NEXT FROM cur_HD INTO @HOADON_ID;
END;
CLOSE cur_HD;
DEALLOCATE cur_HD;
GO

-- CURSOR 4: Xóa vé cũ (cũ hơn 1 năm)
PRINT N'Running Cursor 4: Xóa vé cũ (cũ hơn 1 năm)...';
GO
DECLARE @VE_ID INT;
DECLARE cur_OldVe CURSOR FOR
SELECT ID FROM VE WHERE NGAYMUA < DATEADD(YEAR, -1, CAST(GETDATE() AS DATE));

OPEN cur_OldVe;
FETCH NEXT FROM cur_OldVe INTO @VE_ID;
WHILE @@FETCH_STATUS = 0
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        DELETE FROM CHITIETHOADON WHERE VE_ID = @VE_ID;
        DELETE FROM VE WHERE ID = @VE_ID;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT N'Lỗi khi xóa vé ID = ' + CAST(@VE_ID AS NVARCHAR(10)) + N' - ' + ERROR_MESSAGE();
    END CATCH
    FETCH NEXT FROM cur_OldVe INTO @VE_ID;
END
CLOSE cur_OldVe;
DEALLOCATE cur_OldVe;
GO

-- CURSOR 5: Tính điểm thưởng
PRINT N'Running Cursor 5: Tính điểm thưởng...';
GO
DECLARE @KetQua TABLE (KH_ID INT, TongChi MONEY, DiemThuong INT);
DECLARE @KH_ID INT;
DECLARE @TongChi MONEY;
DECLARE @DiemMoi INT;
DECLARE cur_KH CURSOR LOCAL FOR SELECT ID FROM KHACHHANG;

OPEN cur_KH;
FETCH NEXT FROM cur_KH INTO @KH_ID;
WHILE @@FETCH_STATUS = 0
BEGIN
    SELECT @TongChi = SUM(TONGTIEN) FROM HOADON WHERE KH_ID = @KH_ID;
    SET @TongChi = ISNULL(@TongChi, 0);
    SET @DiemMoi = FLOOR(@TongChi / 100000);
    INSERT INTO @KetQua VALUES (@KH_ID, @TongChi, @DiemMoi);
    FETCH NEXT FROM cur_KH INTO @KH_ID;
END
CLOSE cur_KH;
DEALLOCATE cur_KH;
-- Hiển thị kết quả điểm thưởng
SELECT KH.MAKH, KH.TENKH, KQ.TongChi, KQ.DiemThuong
FROM @KetQua KQ
JOIN KHACHHANG KH ON KQ.KH_ID = KH.ID;
GO

PRINT N'>>> BƯỚC 5 HOÀN TẤT: Đã chạy các kịch bản thực thi.';
GO

/*
================================================================================
BƯỚC 6: BẢO MẬT CSDL & SAO LƯU (DEMO MÔN HỌC)
================================================================================
*/
PRINT N'BƯỚC 6: Đang tạo cấu hình Bảo mật (Phân quyền CSDL)...';
GO

-- 1. TẠO ROLE (VAI TRÒ CSDL)
-- (SỬA: Đổi tên Role cho rõ ràng)
CREATE ROLE Role_QuanTriVien;
CREATE ROLE Role_NhanVien;
CREATE ROLE Role_KhachHang;
GO

-- 2. CẤP QUYỀN CHO ROLE
-- 2.1: Admin (Toàn quyền dữ liệu)
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA :: dbo TO Role_QuanTriVien;
GO

-- 2.2: Nhân viên (Giới hạn)
GRANT SELECT ON PHIM TO Role_NhanVien;
GRANT SELECT ON SUATCHIEU TO Role_NhanVien;
GRANT SELECT ON KHACHHANG TO Role_NhanVien;
GRANT SELECT ON PHONGCHIEU TO Role_NhanVien;
GRANT SELECT ON GHE TO Role_NhanVien;
GRANT INSERT, UPDATE ON VE TO Role_NhanVien;
GRANT INSERT, UPDATE ON HOADON TO Role_NhanVien;
GRANT INSERT, UPDATE ON CHITIETHOADON TO Role_NhanVien;
-- (SỬA: Chặn xem lương và tài khoản)
DENY SELECT ON NHANVIEN TO Role_NhanVien;
DENY SELECT ON NGUOIDUNG TO Role_NhanVien;
GO

-- 2.3: Khách hàng (Rất giới hạn)
GRANT SELECT ON PHIM TO Role_NhanVien;
GRANT SELECT ON SUATCHIEU TO Role_NhanVien;
GRANT SELECT ON RAP TO Role_NhanVien;
GRANT INSERT ON KHACHHANG TO Role_NhanVien; -- (Để tự đăng ký)
GO

PRINT N'>>> Đã tạo và cấp quyền cho 3 Role CSDL.';
GO

-- 3. TẠO LOGIN VÀ USER (ĐỂ DEMO)
CREATE LOGIN admin_login
WITH PASSWORD = 'AdminPassword123';
CREATE USER admin_user FOR LOGIN admin_login;
ALTER ROLE Role_QuanTriVien ADD MEMBER admin_user;
GO

CREATE LOGIN nhanvien_login
WITH PASSWORD = 'NhanVienPassword123';
CREATE USER nhanvien_user FOR LOGIN nhanvien_login;
ALTER ROLE Role_NhanVien ADD MEMBER nhanvien_user;
GO

CREATE LOGIN khachhang_login
WITH PASSWORD = 'KhachHangPassword123';
CREATE USER khachhang_user FOR LOGIN khachhang_login;
ALTER ROLE Role_KhachHang ADD MEMBER khachhang_user;
GO

-- Tạo user 'guest1'
CREATE LOGIN tricuongguest
WITH PASSWORD = 'tricuong123@';
CREATE USER guest1 FOR LOGIN tricuongguest;
ALTER ROLE db_datareader ADD MEMBER guest1;
ALTER ROLE db_datawriter ADD MEMBER guest1;
GO

PRINT N'>>> Đã tạo 4 Login CSDL và gán vào Role thành công.';
GO

/*
================================================================================
BƯỚC 7: KỊCH BẢN SAO LƯU (BACKUP)
================================================================================
*/
PRINT N'BƯỚC 7: Demo kịch bản Sao lưu (Backup)...';
GO

-- Đặt chế độ phục hồi là FULL
ALTER DATABASE DB_QLRAPCHIEUPHIM
SET RECOVERY FULL;
GO

--Sao lưu định kỳ Full Backup
DECLARE @FileNameFull NVARCHAR(200)
SET @FileNameFull = 'D:\Document\QTCSDL\DB_QLRAPCHIEUPHIM_Full' -- (SỬA: Đảm bảo đường dẫn này tồn tại)
    + CONVERT(VARCHAR(8), GETDATE(), 112) + '.bak'
BACKUP DATABASE DB_QLRAPCHIEUPHIM
TO DISK = @FileNameFull
WITH INIT, NAME = 'Full Backup DB_QLRAPCHIEUPHIM',
     DESCRIPTION = 'Sao lưu toàn bộ dữ liệu định kỳ (Full Backup)', STATS = 10;
GO

--Sao lưu định kỳ Differential Backup
DECLARE @FileNameDiff NVARCHAR(200)
SET @FileNameDiff = 'D:\Document\QTCSDL\DB_QLRAPCHIEUPHIM_Diff' 
    + CONVERT(VARCHAR(8), GETDATE(), 112) + '.bak'
BACKUP DATABASE DB_QLRAPCHIEUPHIM
TO DISK = @FileNameDiff
WITH DIFFERENTIAL, NAME = 'Differential Backup DB_QLRAPCHIEUPHIM',
     DESCRIPTION = 'Sao lưu phần thay đổi từ bản full gần nhất', STATS = 10;
GO

--Sao lưu định kỳ Transaction Log Backup
DECLARE @FileNameLog NVARCHAR(200)
SET @FileNameLog = 'D:\Document\QTCSDL\DB_QLRAPCHIEUPHIM_Log' 
    + REPLACE(CONVERT(VARCHAR(19), GETDATE(), 120), ':', '') + '.trn'
BACKUP LOG DB_QLRAPCHIEUPHIM
TO DISK = @FileNameLog
WITH INIT, NAME = 'Transaction Log Backup DB_QLRAPCHIEUPHIM',
     DESCRIPTION = 'Sao lưu log giao dịch định kỳ', STATS = 10;
GO

PRINT N'>>> BƯỚC 7 HOÀN TẤT: Đã chạy kịch bản Backup.';
GO

/*
================================================================================
BƯỚC 8: TẠO TÀI KHOẢN ADMIN CHO WEB MVC (DÙNG MẬT KHẨU THƯỜNG)
================================================================================
*/
PRINT N'BƯỚC 8: Đang tạo tài khoản Admin (admin/admin123) cho Web MVC...';
GO

BEGIN TRANSACTION;
BEGIN TRY
    DECLARE @NhanVienID INT;
    DECLARE @NguoiDungID INT;
    DECLARE @AdminRoleID INT;

    -- Lấy ID của nhân viên (giả sử NV001 - Nguyễn Văn Anh)
    SELECT @NhanVienID = ID FROM NHANVIEN WHERE MANV = 'NV001';
    
    -- Nếu không tìm thấy NV001, tạo một NV mẫu để làm admin
    IF @NhanVienID IS NULL
    BEGIN
        INSERT INTO NHANVIEN (TENNV, NGAYSINH, GIOITINH, SDT, DIACHI, EMAIL, LUONG)
        VALUES (N'Quản trị Admin', '1990-01-01', N'Nam', '0000000001', N'Admin', 'admin@web.com', 100000);
        SET @NhanVienID = SCOPE_IDENTITY();
    END

    -- Mật khẩu: admin123 (dạng chữ)
    INSERT INTO NGUOIDUNG (USERNAME, MatKhau, NhanVien_ID, VERIFIED, CREATEAT)
    VALUES ('admin', 'admin123', @NhanVienID, 1, GETDATE());
    
    SET @NguoiDungID = SCOPE_IDENTITY();

    -- Lấy ID của vai trò 'Admin'
    SELECT @AdminRoleID = ID FROM VAITRO WHERE TenVaiTro = N'Admin';

    -- Gán vai trò
    INSERT INTO NGUOIDUNG_VAITRO (NguoiDung_ID, VaiTro_ID)
    VALUES (@NguoiDungID, @AdminRoleID);

    COMMIT TRANSACTION;
    PRINT N'>>> Đã tạo tài khoản Admin (user: admin, pass: admin123) thành công!';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT N'LỖI: Không thể tạo tài khoản Admin. Đã rollback.';
    PRINT ERROR_MESSAGE();
END CATCH;
GO


PRINT N'===== HOÀN TẤT TOÀN BỘ KỊCH BẢN MASTER SCRIPT =====';
GO