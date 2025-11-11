using QuanLyRapChieuPhim.Data;
using QuanLyRapChieuPhim.Models;
using System.Data.Entity;
using System.Threading.Tasks;
using System.Web.Mvc;

public class PhimController : Controller
{
    // Dòng này bây giờ sẽ gọi Context.cs "bằng tay"
    private QuanLyRapChieuPhimContext db = new QuanLyRapChieuPhimContext();

    // GET: Phim
    public async Task<ActionResult> Index()
    {
        // Dòng này sẽ dùng DbSet "PHIMs" mà bạn đã khai báo
        return View(await db.PHIMs.ToListAsync());
    }

    // GET: Phim/Details/5
    public async Task<ActionResult> Details(int? id)
    {
        // FindAsync(id) sẽ tìm trên cột [Key] (là cột ID)
        PHIM pHIM = await db.PHIMs.FindAsync(id);

        // ... (phần còn lại của code) ...
        return View(pHIM);
    }

    // ... (Tất cả các Action khác đều sẽ hoạt động) ...
}