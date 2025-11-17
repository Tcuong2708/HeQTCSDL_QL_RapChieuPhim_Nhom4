using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;       // <-- Cần EF6
using System.ComponentModel.DataAnnotations.Schema; // <-- Cần EF6

namespace QuanLyRapChieuPhim.Models 
{
    [Table("NHANVIEN")]
    public class NHANVIEN
    {
        [Key]
        public int ID { get; set; }

        [DatabaseGenerated(DatabaseGeneratedOption.Computed)]
        [Display(Name = "Mã Nhân Viên")]
        public string MANV { get; set; }

        [Display(Name = "Tên Nhân Viên")]
        public string TENNV { get; set; }

        [Display(Name = "Ngày Sinh")]
        [DataType(DataType.Date)]
        public DateTime? NGAYSINH { get; set; }

        [Display(Name = "Giới Tính")]
        public string GIOITINH { get; set; }

        [Display(Name = "Số Điện Thoại")]
        public string SDT { get; set; }

        [Display(Name = "Địa Chỉ")]
        public string DIACHI { get; set; }

        [Display(Name = "Email")]
        public string EMAIL { get; set; }

        [Display(Name = "Lương")]
        public decimal? LUONG { get; set; }

        public virtual ICollection<NGUOIDUNG> NGUOIDUNGs { get; set; }
        public virtual ICollection<HOADON> HOADONs { get; set; }
    }

    [Table("KHACHHANG")]
    public class KHACHHANG
    {
        [Key]
        public int ID { get; set; }

        [DatabaseGenerated(DatabaseGeneratedOption.Computed)]
        [Display(Name = "Mã Khách Hàng")]
        public string MAKH { get; set; }

        [Display(Name = "Tên Khách Hàng")]
        public string TENKH { get; set; }

        [Display(Name = "Ngày Sinh")]
        [DataType(DataType.Date)]
        public DateTime? NGAYSINH { get; set; }

        [Display(Name = "Giới Tính")]
        public string GIOITINH { get; set; }

        [Display(Name = "Số Điện Thoại")]
        public string SDT { get; set; }

        public virtual ICollection<NGUOIDUNG> NGUOIDUNGs { get; set; }
        public virtual ICollection<VE> VEs { get; set; }
        public virtual ICollection<HOADON> HOADONs { get; set; }
    }


    [Table("PHIM")]
    public class PHIM
    {
        [Key]
        public int ID { get; set; }
        [DatabaseGenerated(DatabaseGeneratedOption.Computed)]
        public string MAPHIM { get; set; }
        [Display(Name = "Tên Phim")] 
        public string TENPHIM { get; set; }
        [Display(Name = "Thể Loại")] 
        public string THELOAI { get; set; }
        [Display(Name = "Thời Lượng")] 
        public string THOILUONG { get; set; }
        [Display(Name = "Diễn Viên")] 
        public string DIENVIENCHINH { get; set; }
        [Display(Name = "Khởi Chiếu")] 
        [DataType(DataType.Date)]
        public DateTime? KHOICHIEU { get; set; }
        [Display(Name = "Ngôn Ngữ")] 
        public string NGONNGU { get; set; }
        [Display(Name = "Xếp Hạng")] 
        public string XEPHANG { get; set; }
        public string HINH { get; set; }
        public virtual ICollection<SUATCHIEU> SUATCHIEUs { get; set; }
    }


    [Table("RAP")]
    public class RAP
    {
        [Key]
        public int ID { get; set; }

        [DatabaseGenerated(DatabaseGeneratedOption.Computed)]
        [Display(Name = "Mã Rạp")]
        public string MARAP { get; set; }

        [Display(Name = "Tên Rạp")]
        public string TENRAP { get; set; }

        [Display(Name = "Địa Chỉ")]
        public string DIACHI { get; set; }

        public virtual ICollection<QUAY> QUAYs { get; set; }
        public virtual ICollection<PHONGCHIEU> PHONGCHIEUs { get; set; }
    }


    [Table("VAITRO")]
    public class VAITRO
    {
        [Key]
        public int ID { get; set; }

        [Display(Name = "Tên Vai Trò")]
        public string TenVaiTro { get; set; }

        //Quan hệ nhiều-nhiều
        public virtual ICollection<NGUOIDUNG> NGUOIDUNGs { get; set; }
    }


    [Table("NGUOIDUNG")]
    public class NGUOIDUNG
    {
        [Key]
        public int ID { get; set; }

        [Display(Name = "Tên Đăng Nhập")]
        public string USERNAME { get; set; }

        [Display(Name = "Mật Khẩu (Hash)")]
        public string MatKhau { get; set; }

        [Display(Name = "Nhân Viên")]
        public int? NhanVien_ID { get; set; }

        [Display(Name = "Khách Hàng")]
        public int? KhachHang_ID { get; set; }

        [Display(Name = "Ảnh Khuôn Mặt")]
        public byte[] FACEPICTURE { get; set; }

        [Display(Name = "Ngày Tạo")]
        public DateTime? CREATEAT { get; set; }

        [Display(Name = "Xác Thực?")]
        public bool VERIFIED { get; set; }

        [ForeignKey("NhanVien_ID")]
        public virtual NHANVIEN NHANVIEN { get; set; }

        [ForeignKey("KhachHang_ID")]
        public virtual KHACHHANG KHACHHANG { get; set; }

        public virtual ICollection<VAITRO> VAITROs { get; set; }
    }


    [Table("QUAY")]
    public class QUAY
    {
        [Key]
        public int ID { get; set; }

        [DatabaseGenerated(DatabaseGeneratedOption.Computed)]
        [Display(Name = "Mã Quầy")]
        public string MAQUAY { get; set; }

        [Display(Name = "Tên Quầy")]
        public string TENQUAY { get; set; }

        [Display(Name = "Loại Quầy")]
        public string LOAIQUAY { get; set; }

        [Display(Name = "Rạp")]
        public int RAP_ID { get; set; }

        [ForeignKey("RAP_ID")]
        public virtual RAP RAP { get; set; }
    }


    [Table("PHONGCHIEU")]
    public class PHONGCHIEU
    {
        [Key]
        public int ID { get; set; }

        [DatabaseGenerated(DatabaseGeneratedOption.Computed)]
        [Display(Name = "Mã Phòng")]
        public string MAPH { get; set; }

        [Display(Name = "Rạp")]
        public int RAP_ID { get; set; }

        [Display(Name = "Tên Phòng")]
        public string TENPH { get; set; }

        [Display(Name = "Số Chỗ")]
        public int? SOCHO { get; set; }

        [ForeignKey("RAP_ID")]
        public virtual RAP RAP { get; set; }

        public virtual ICollection<GHE> GHEs { get; set; }
    }


    [Table("SUATCHIEU")]
    public class SUATCHIEU
    {
        [Key]
        public int ID { get; set; }

        [DatabaseGenerated(DatabaseGeneratedOption.Computed)]
        [Display(Name = "Mã Suất")]
        public string MASUAT { get; set; }

        [Display(Name = "Phim")]
        public int PHIM_ID { get; set; }

        [Display(Name = "Ngày Chiếu")]
        [DataType(DataType.Date)]
        public DateTime? NGAYCHIEU { get; set; }

        [Display(Name = "Giờ Chiếu")]
        public TimeSpan? GIOCHIEU { get; set; }

        [Display(Name = "Số Ghế Còn")]
        public string SOGHE { get; set; }

        [ForeignKey("PHIM_ID")]
        public virtual PHIM PHIM { get; set; }

        public virtual ICollection<VE> VEs { get; set; }
    }


    [Table("GHE")]
    public class GHE
    {
        [Key]
        public int ID { get; set; }

        [DatabaseGenerated(DatabaseGeneratedOption.Computed)]
        [Display(Name = "Mã Ghế")]
        public string MAGHE { get; set; }

        [Display(Name = "Phòng Chiếu")]
        public int PHONGCHIEU_ID { get; set; }

        [Display(Name = "Rạp")]
        public int RAP_ID { get; set; }

        [Display(Name = "Vị Trí")]
        public string VITRI { get; set; }

        [Display(Name = "Loại Ghế")]
        public string LOAIGHE { get; set; }

        [ForeignKey("PHONGCHIEU_ID")]
        public virtual PHONGCHIEU PHONGCHIEU { get; set; }

        public virtual ICollection<VE> VEs { get; set; }
    }


    [Table("HOADON")]
    public class HOADON
    {
        [Key]
        public int ID { get; set; }

        [DatabaseGenerated(DatabaseGeneratedOption.Computed)]
        [Display(Name = "Mã Hóa Đơn")]
        public string MAHD { get; set; }

        [Display(Name = "Khách Hàng")]
        public int? KH_ID { get; set; }

        [Display(Name = "Nhân Viên Lập")]
        public int? NV_ID { get; set; }

        [Display(Name = "Ngày Lập")]
        public DateTime? NGAYLAP { get; set; }

        [Display(Name = "Tổng Tiền")]
        public decimal? TONGTIEN { get; set; }

        [ForeignKey("KH_ID")]
        public virtual KHACHHANG KHACHHANG { get; set; }

        [ForeignKey("NV_ID")]
        public virtual NHANVIEN NHANVIEN { get; set; }

        public virtual ICollection<CHITIETHOADON> CHITIETHOADONs { get; set; }
    }


    [Table("VE")]
    public class VE
    {
        [Key]
        public int ID { get; set; }

        [DatabaseGenerated(DatabaseGeneratedOption.Computed)]
        [Display(Name = "Mã Vé")]
        public string MAVE { get; set; }

        [Display(Name = "Khách Hàng")]
        public int? KH_ID { get; set; }

        [Display(Name = "Suất Chiếu")]
        public int? SUATCHIEU_ID { get; set; }

        [Display(Name = "Ghế")]
        public int? GHE_ID { get; set; }

        [Display(Name = "Ngày Mua")]
        public DateTime? NGAYMUA { get; set; }

        [Display(Name = "Giá Vé")]
        public decimal? GIAVE { get; set; }

        [ForeignKey("KH_ID")]
        public virtual KHACHHANG KHACHHANG { get; set; }

        [ForeignKey("SUATCHIEU_ID")]
        public virtual SUATCHIEU SUATCHIEU { get; set; }

        [ForeignKey("GHE_ID")]
        public virtual GHE GHE { get; set; }

        public virtual ICollection<CHITIETHOADON> CHITIETHOADONs { get; set; }
    }


    [Table("CHITIETHOADON")]
    public class CHITIETHOADON
    {
        [Key]
        [Column(Order = 0)]
        [Display(Name = "Hóa Đơn")]
        public int HOADON_ID { get; set; }

        [Key]
        [Column(Order = 1)]
        [Display(Name = "Vé")]
        public int VE_ID { get; set; }

        [ForeignKey("HOADON_ID")]
        public virtual HOADON HOADON { get; set; }

        [ForeignKey("VE_ID")]
        public virtual VE VE { get; set; }
    }


    [Table("LOG_NHANVIEN")]
    public class LOG_NHANVIEN
    {
        [Key]
        public int ID { get; set; }

        [Display(Name = "Nhân Viên")]
        public int? NHANVIEN_ID { get; set; }

        [Display(Name = "Tên Nhân Viên")]
        public string TENNV { get; set; }

        [Display(Name = "Ngày Thực Hiện")]
        public DateTime? NGAYTHUCHIEN { get; set; }

        [Display(Name = "Hành Động")]
        public string HANHDONG { get; set; }
    }

}