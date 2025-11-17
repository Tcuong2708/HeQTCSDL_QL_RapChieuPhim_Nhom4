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
    public class HoaDonController : Controller
    {
        private QuanLyRapChieuPhimContext db = new QuanLyRapChieuPhimContext();

        // GET: HoaDon
        public ActionResult Index()
        {
            var hOADONs = db.HOADONs.Include(h => h.KHACHHANG).Include(h => h.NHANVIEN);
            return View(hOADONs.ToList());
        }

        // GET: HoaDon/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            HOADON hOADON = db.HOADONs.Find(id);
            if (hOADON == null)
            {
                return HttpNotFound();
            }
            return View(hOADON);
        }

        // GET: HoaDon/Create
        public ActionResult Create()
        {
            ViewBag.KH_ID = new SelectList(db.KHACHHANGs, "ID", "MAKH");
            ViewBag.NV_ID = new SelectList(db.NHANVIENs, "ID", "MANV");
            return View();
        }

        // POST: HoaDon/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "ID,MAHD,KH_ID,NV_ID,NGAYLAP,TONGTIEN")] HOADON hOADON)
        {
            if (ModelState.IsValid)
            {
                db.HOADONs.Add(hOADON);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            ViewBag.KH_ID = new SelectList(db.KHACHHANGs, "ID", "MAKH", hOADON.KH_ID);
            ViewBag.NV_ID = new SelectList(db.NHANVIENs, "ID", "MANV", hOADON.NV_ID);
            return View(hOADON);
        }

        // GET: HoaDon/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            HOADON hOADON = db.HOADONs.Find(id);
            if (hOADON == null)
            {
                return HttpNotFound();
            }
            ViewBag.KH_ID = new SelectList(db.KHACHHANGs, "ID", "MAKH", hOADON.KH_ID);
            ViewBag.NV_ID = new SelectList(db.NHANVIENs, "ID", "MANV", hOADON.NV_ID);
            return View(hOADON);
        }

        // POST: HoaDon/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "ID,MAHD,KH_ID,NV_ID,NGAYLAP,TONGTIEN")] HOADON hOADON)
        {
            if (ModelState.IsValid)
            {
                db.Entry(hOADON).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.KH_ID = new SelectList(db.KHACHHANGs, "ID", "MAKH", hOADON.KH_ID);
            ViewBag.NV_ID = new SelectList(db.NHANVIENs, "ID", "MANV", hOADON.NV_ID);
            return View(hOADON);
        }

        // GET: HoaDon/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            HOADON hOADON = db.HOADONs.Find(id);
            if (hOADON == null)
            {
                return HttpNotFound();
            }
            return View(hOADON);
        }

        // POST: HoaDon/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            HOADON hOADON = db.HOADONs.Find(id);
            db.HOADONs.Remove(hOADON);
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
