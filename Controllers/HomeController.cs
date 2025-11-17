using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace WebQuanLyRapChieuPhim.Controllers 
{
    // Đảm bảo toàn bộ Controller này chỉ người đã đăng nhập mới vào được
    [Authorize]
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            ViewBag.Title = "Trang chủ";
            ViewBag.WelcomeMessage = User.Identity.Name;
            return View();
        }

    }
}