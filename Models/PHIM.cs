using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace QuanLyRapChieuPhim.Models
{
    // [Table("PHIM")] chỉ định rõ tên bảng trong SQL
    [Table("PHIM")]
    public class PHIM
    {
        // [Key] chỉ định đây là Khóa chính
        // Giả sử khóa chính của bạn là một số (int)
        [Key]
        public int ID { get; set; }

        // Các thuộc tính khác, tên phải khớp với tên cột
        public string MAPHIM { get; set; }
        public string TENPHIM { get; set; }
        public string THELOAI { get; set; }
        public string THOILUONG { get; set; }
        public string DIENVIENCHINH { get; set; }
        public DateTime? KHOICHIEU { get; set; } // Dùng DateTime? nếu cho phép NULL
        public string NGONNGU { get; set; }
        public string XEPHANG { get; set; }
        public string HINH { get; set; }

        // Thêm bất kỳ cột nào khác bạn có ở đây...
    }
}
