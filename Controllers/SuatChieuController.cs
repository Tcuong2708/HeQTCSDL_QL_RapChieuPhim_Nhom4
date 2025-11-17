using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using QuanLyRapChieuPhim.Data;
using QuanLyRapChieuPhim.Models;

namespace QuanLyRapChieuPhim.Controllers
{
    public class SuatChieuController : Controller
    {
        private QuanLyRapChieuPhimContext db = new QuanLyRapChieuPhimContext();

        // GET: SuatChieu
        public ActionResult Index()
        {
            var sUATCHIEUs = db.SUATCHIEUs.Include(s => s.PHIM);
            return View(sUATCHIEUs.ToList());
        }

        // GET: SuatChieu/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            SUATCHIEU sUATCHIEU = db.SUATCHIEUs.Find(id);
            if (sUATCHIEU == null)
            {
                return HttpNotFound();
            }
            return View(sUATCHIEU);
        }

        // GET: SuatChieu/Create
        public ActionResult Create()
        {
            ViewBag.PHIM_ID = new SelectList(db.PHIMs, "ID", "MAPHIM");
            return View();
        }

        // POST: SuatChieu/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "ID,MASUAT,PHIM_ID,NGAYCHIEU,GIOCHIEU,SOGHE")] SUATCHIEU sUATCHIEU)
        {
            if (ModelState.IsValid)
            {
                db.SUATCHIEUs.Add(sUATCHIEU);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            ViewBag.PHIM_ID = new SelectList(db.PHIMs, "ID", "MAPHIM", sUATCHIEU.PHIM_ID);
            return View(sUATCHIEU);
        }

        // GET: SuatChieu/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            SUATCHIEU sUATCHIEU = db.SUATCHIEUs.Find(id);
            if (sUATCHIEU == null)
            {
                return HttpNotFound();
            }
            ViewBag.PHIM_ID = new SelectList(db.PHIMs, "ID", "MAPHIM", sUATCHIEU.PHIM_ID);
            return View(sUATCHIEU);
        }

        // POST: SuatChieu/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "ID,MASUAT,PHIM_ID,NGAYCHIEU,GIOCHIEU,SOGHE")] SUATCHIEU sUATCHIEU)
        {
            if (ModelState.IsValid)
            {
                db.Entry(sUATCHIEU).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.PHIM_ID = new SelectList(db.PHIMs, "ID", "MAPHIM", sUATCHIEU.PHIM_ID);
            return View(sUATCHIEU);
        }

        // GET: SuatChieu/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            SUATCHIEU sUATCHIEU = db.SUATCHIEUs.Find(id);
            if (sUATCHIEU == null)
            {
                return HttpNotFound();
            }
            return View(sUATCHIEU);
        }

        // POST: SuatChieu/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            SUATCHIEU sUATCHIEU = db.SUATCHIEUs.Find(id);
            db.SUATCHIEUs.Remove(sUATCHIEU);
            db.SaveChanges();
            return RedirectToAction("Index");
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
