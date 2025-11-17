using QuanLyRapChieuPhim.Data;
using System;
using System.Data.Entity;
using System.Linq;
using System.Threading.Tasks;
using System.Web.Mvc;
using QuanLyRapChieuPhim.Data;
using QuanLyRapChieuPhim.Models.ViewModels; 

namespace WebQuanLyRapChieuPhim.Controllers 
{
    [Authorize(Roles = "Admin, NhanVienBanVe")] // Chỉ Admin/Nhân viên thấy
    public class DashboardController : Controller
    {
        private QuanLyRapChieuPhimContext db = new QuanLyRapChieuPhimContext();

        // GET: Dashboard/Index
        public async Task<ActionResult> Index()
        {
            // 1. Tính tổng doanh thu (từ Hóa đơn)
            // Dùng (decimal?)h.TONGTIEN để Sum() chấp nhận cột có thể NULL
            decimal totalRevenue = await db.HOADONs.SumAsync(h => (decimal?)h.TONGTIEN) ?? 0;

            // 2. Đếm tổng số vé đã bán
            int ticketsSold = await db.VEs.CountAsync();

            // 3. Đếm tổng số khách hàng
            int customerCount = await db.KHACHHANGs.CountAsync();

            // 4. Đếm số phim đang có
            int movieCount = await db.PHIMs.CountAsync();

            // 5. Tạo ViewModel để gửi đi
            var viewModel = new DashboardViewModel
            {
                TotalRevenue = totalRevenue,
                TicketsSold = ticketsSold,
                CustomerCount = customerCount,
                MovieCount = movieCount
            };

            return View(viewModel);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}