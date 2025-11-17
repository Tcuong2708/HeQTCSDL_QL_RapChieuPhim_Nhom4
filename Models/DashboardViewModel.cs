using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace QuanLyRapChieuPhim.Models.ViewModels
{
    public class DashboardViewModel
    {
        public decimal TotalRevenue { get; set; }
        public int TicketsSold { get; set; }
        public int CustomerCount { get; set; }
        public int MovieCount { get; set; }
    }
}