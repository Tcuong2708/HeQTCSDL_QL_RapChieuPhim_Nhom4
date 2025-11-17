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
    public class PhongChieuController : Controller
    {
        private QuanLyRapChieuPhimContext db = new QuanLyRapChieuPhimContext();

        // GET: PhongChieu
        public ActionResult Index()
        {
            var pHONGCHIEUs = db.PHONGCHIEUs.Include(p => p.RAP);
            return View(pHONGCHIEUs.ToList());
        }

        // GET: PhongChieu/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            PHONGCHIEU pHONGCHIEU = db.PHONGCHIEUs.Find(id);
            if (pHONGCHIEU == null)
            {
                return HttpNotFound();
            }
            return View(pHONGCHIEU);
        }

        // GET: PhongChieu/Create
        public ActionResult Create()
        {
            ViewBag.RAP_ID = new SelectList(db.RAPs, "ID", "MARAP");
            return View();
        }

        // POST: PhongChieu/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "ID,MAPH,RAP_ID,TENPH,SOCHO")] PHONGCHIEU pHONGCHIEU)
        {
            if (ModelState.IsValid)
            {
                db.PHONGCHIEUs.Add(pHONGCHIEU);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            ViewBag.RAP_ID = new SelectList(db.RAPs, "ID", "MARAP", pHONGCHIEU.RAP_ID);
            return View(pHONGCHIEU);
        }

        // GET: PhongChieu/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            PHONGCHIEU pHONGCHIEU = db.PHONGCHIEUs.Find(id);
            if (pHONGCHIEU == null)
            {
                return HttpNotFound();
            }
            ViewBag.RAP_ID = new SelectList(db.RAPs, "ID", "MARAP", pHONGCHIEU.RAP_ID);
            return View(pHONGCHIEU);
        }

        // POST: PhongChieu/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "ID,MAPH,RAP_ID,TENPH,SOCHO")] PHONGCHIEU pHONGCHIEU)
        {
            if (ModelState.IsValid)
            {
                db.Entry(pHONGCHIEU).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.RAP_ID = new SelectList(db.RAPs, "ID", "MARAP", pHONGCHIEU.RAP_ID);
            return View(pHONGCHIEU);
        }

        // GET: PhongChieu/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            PHONGCHIEU pHONGCHIEU = db.PHONGCHIEUs.Find(id);
            if (pHONGCHIEU == null)
            {
                return HttpNotFound();
            }
            return View(pHONGCHIEU);
        }

        // POST: PhongChieu/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            PHONGCHIEU pHONGCHIEU = db.PHONGCHIEUs.Find(id);
            db.PHONGCHIEUs.Remove(pHONGCHIEU);
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
