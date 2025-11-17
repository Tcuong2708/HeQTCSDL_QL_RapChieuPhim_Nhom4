using QuanLyRapChieuPhim.Models;
using System.Data.Entity;
using System.Data.Entity.ModelConfiguration.Conventions;
using QuanLyRapChieuPhim.Models; // <-- SỬA NAMESPACE NÀY

namespace QuanLyRapChieuPhim.Data // <-- SỬA NAMESPACE NÀY
{
    public class QuanLyRapChieuPhimContext : DbContext
    {
        public QuanLyRapChieuPhimContext() : base("name=DB_QLRAPCHIEUPHIM")
        {
            Database.SetInitializer<QuanLyRapChieuPhimContext>(null);
        }

        // Khai báo tất cả các bảng (Tên DbSet là SỐ NHIỀU)
        public DbSet<NHANVIEN> NHANVIENs { get; set; }
        public DbSet<KHACHHANG> KHACHHANGs { get; set; }
        public DbSet<PHIM> PHIMs { get; set; }
        public DbSet<RAP> RAPs { get; set; }
        public DbSet<VAITRO> VAITROs { get; set; }
        public DbSet<NGUOIDUNG> NGUOIDUNGs { get; set; }
        public DbSet<QUAY> QUAYs { get; set; }
        public DbSet<PHONGCHIEU> PHONGCHIEUs { get; set; }
        public DbSet<SUATCHIEU> SUATCHIEUs { get; set; }
        public DbSet<GHE> GHEs { get; set; }
        public DbSet<HOADON> HOADONs { get; set; }
        public DbSet<VE> VEs { get; set; }
        public DbSet<CHITIETHOADON> CHITIETHOADONs { get; set; }
        public DbSet<LOG_NHANVIEN> LOG_NHANVIEN { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            // TẮT TÍNH NĂNG TỰ THÊM 'S'
            modelBuilder.Conventions.Remove<PluralizingTableNameConvention>();

            // Cấu hình quan hệ Nhiều-Nhiều (NGUOIDUNG <-> VAITRO)
            modelBuilder.Entity<NGUOIDUNG>()
                .HasMany(t => t.VAITROs)
                .WithMany(v => v.NGUOIDUNGs)
                .Map(m =>
                {
                    m.ToTable("NGUOIDUNG_VAITRO");
                    m.MapLeftKey("NguoiDung_ID");
                    m.MapRightKey("VaiTro_ID");
                });

            // ▼▼ SỬA LỖI QUAN HỆ 1:1 NẰM Ở ĐÂY ▼▼
            // NGUOIDUNG – NHANVIEN (1 – N)
            modelBuilder.Entity<NGUOIDUNG>()
                .HasOptional(nd => nd.NHANVIEN)
                .WithMany(nv => nv.NGUOIDUNGs)
                .HasForeignKey(nd => nd.NhanVien_ID);

            // NGUOIDUNG – KHACHHANG (1 – N)
            modelBuilder.Entity<NGUOIDUNG>()
                .HasOptional(nd => nd.KHACHHANG)
                .WithMany(kh => kh.NGUOIDUNGs)
                .HasForeignKey(nd => nd.KhachHang_ID);

            // ▲▲ KẾT THÚC KHỐI SỬA LỖI ▲▲

            // Cấu hình Khóa chính phức hợp cho CHITIETHOADON
            modelBuilder.Entity<CHITIETHOADON>()
                .HasKey(c => new { c.HOADON_ID, c.VE_ID });

            base.OnModelCreating(modelBuilder);
        }
    }
}