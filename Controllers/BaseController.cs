using System;
using System.Data.Entity.Infrastructure;
using System.Data.SqlClient;
using System.Web.Mvc;

namespace QuanLyRapChieuPhim.Controllers
{
    public class BaseController : Controller
    {
        /// <summary>
        /// Gọi trong catch… để hiển thị lỗi SQL lên MVC
        /// </summary>
        protected void AddSqlError(Exception ex)
        {
            string message = ExtractSqlMessage(ex);
            ModelState.AddModelError("", message);
        }

        /// <summary>
        /// Tách thông báo SQL từ nhiều loại lỗi (trigger, proc, cursor, FK…)
        /// </summary>
        private string ExtractSqlMessage(Exception ex)
        {
            Exception inner = ex;

            while (inner != null)
            {
                if (inner is SqlException sqlEx)
                {
                    return MapSqlException(sqlEx);
                }
                inner = inner.InnerException;
            }

            // fallback
            return "Lỗi không xác định từ hệ thống.";
        }

        /// <summary>
        /// Ánh xạ mã lỗi SQL -> Thông báo thân thiện
        /// </summary>
        private string MapSqlException(SqlException ex)
        {
            switch (ex.Number)
            {
                case 2627: // Vi phạm UNIQUE / PRIMARY KEY
                case 2601:
                    return "Dữ liệu đã tồn tại (UNIQUE KEY).";

                //case 547:  // FOREIGN KEY conflict
                //    return "Không thể xóa hoặc sửa bản ghi vì đang được sử dụng (FOREIGN KEY).";

                case 547 - 1: // hypothetical
                    break;

                case 50000: // RAISERROR hoặc THROW từ TRIGGER / PROC
                    return ex.Message;

                case 1205: // DEADLOCK
                    return "Hệ thống đang bận (DEADLOCK). Vui lòng thử lại.";

                case -2: // TIMEOUT
                    return "Giao dịch bị TIMEOUT (quá chậm).";

                default:
                    // Nếu là lỗi CHECK constraint
                    if (ex.Message.Contains("CHECK"))
                        return "Lỗi ràng buộc CHECK: " + ex.Message;

                    // Trigger trả thông báo tiếng Việt
                    if (ex.Message.Contains("RAISERROR") || ex.Message.Contains("THROW"))
                        return ex.Message;

                    return "SQL Error: " + ex.Message;
            }

            return ex.Message;
        }
    }
}
