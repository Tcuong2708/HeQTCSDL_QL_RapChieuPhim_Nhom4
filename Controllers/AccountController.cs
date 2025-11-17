using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;
using QuanLyRapChieuPhim.Data;   
using QuanLyRapChieuPhim.Models;  


namespace QuanLyRapChieuPhim.Controllers 
{
    [Authorize]
    public class AccountController : Controller
    {
        private QuanLyRapChieuPhimContext db = new QuanLyRapChieuPhimContext();

        // GET: /Account/Login
        [AllowAnonymous]
        public ActionResult Login(string returnUrl)
        {
            if (User.Identity.IsAuthenticated)
            {
                return RedirectToAction("Index", "Phim");
            }
            ViewBag.ReturnUrl = returnUrl;
            return View();
        }

        // POST: /Account/Login
        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Login(string username, string password, string returnUrl)
        {
            var user = await db.NGUOIDUNGs
                               .Include(u => u.VAITROs)
                               .FirstOrDefaultAsync(u => u.USERNAME == username);

            // ▼▼ SỬA LỖI: SO SÁNH TRỰC TIẾP MẬT KHẨU (KHÔNG HASH) ▼▼
            // Bỏ: PasswordHelper.VerifyPassword(password, user.MatKhauHash)
            // Thay bằng:
            if (user != null && user.VERIFIED && user.MatKhau == password)
            {
                string[] roles = user.VAITROs.Select(v => v.TenVaiTro).ToArray();
                string roleString = string.Join(",", roles);

                FormsAuthenticationTicket ticket = new FormsAuthenticationTicket(
                    1, user.USERNAME, DateTime.Now, DateTime.Now.AddMinutes(60),
                    false, roleString, FormsAuthentication.FormsCookiePath
                );

                string encryptedTicket = FormsAuthentication.Encrypt(ticket);
                HttpCookie authCookie = new HttpCookie(FormsAuthentication.FormsCookieName, encryptedTicket);
                Response.Cookies.Add(authCookie);

                if (!string.IsNullOrEmpty(returnUrl) && Url.IsLocalUrl(returnUrl))
                {
                    return Redirect(returnUrl);
                }

                if (roles.Contains("Admin") || roles.Contains("NhanVienBanVe"))
                {
                    return RedirectToAction("Index", "Dashboard");
                }
                else
                {
                    return RedirectToAction("Index", "Home");
                }
            }

            ModelState.AddModelError("", "Tên đăng nhập hoặc mật khẩu không đúng.");
            return View();
        }

        // GET: /Account/Register
        [AllowAnonymous]
        public ActionResult Register()
        {
            return View();
        }

        // POST: /Account/Register
        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Register(string username, string password, string tenKhachHang, DateTime ngaySinh, string sdt, string gioitinh)
        {
            if (await db.NGUOIDUNGs.AnyAsync(u => u.USERNAME == username))
            {
                ModelState.AddModelError("", "Tên đăng nhập đã tồn tại.");
                return View();
            }

            KHACHHANG newKhachHang = new KHACHHANG
            {
                TENKH = tenKhachHang,
                NGAYSINH = ngaySinh,
                GIOITINH = gioitinh,
                SDT = sdt
            };

            db.KHACHHANGs.Add(newKhachHang);
            await db.SaveChangesAsync();

            var khachRole = await db.VAITROs.FirstOrDefaultAsync(v => v.TenVaiTro == "KhachHang");
            if (khachRole == null)
            {
                ModelState.AddModelError("", "Lỗi hệ thống: Không tìm thấy vai trò 'KhachHang'.");
                return View();
            }

            NGUOIDUNG newUser = new NGUOIDUNG
            {
                USERNAME = username,
                // ▼▼ SỬA LỖI: LƯU MẬT KHẨU THƯỜNG (KHÔNG HASH) ▼▼
                MatKhau = password,
                KhachHang_ID = newKhachHang.ID,
                VERIFIED = true,
                CREATEAT = DateTime.Now
            };

            newUser.VAITROs = new List<VAITRO> { khachRole };
            db.NGUOIDUNGs.Add(newUser);
            await db.SaveChangesAsync();

            FormsAuthentication.SetAuthCookie(newUser.USERNAME, false);
            return RedirectToAction("Index", "Home");
        }


        // GET: /Account/Logout
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Logout()
        {
            FormsAuthentication.SignOut(); // Xóa Cookie
            return RedirectToAction("Login", "Account");
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