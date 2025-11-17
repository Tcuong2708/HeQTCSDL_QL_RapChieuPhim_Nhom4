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
    public class GheController : Controller
    {
        private QuanLyRapChieuPhimContext db = new QuanLyRapChieuPhimContext();

        // GET: Ghe
        public ActionResult Index()
        {
            var gHEs = db.GHEs.Include(g => g.PHONGCHIEU);
            return View(gHEs.ToList());
        }

        // GET: Ghe/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            GHE gHE = db.GHEs.Find(id);
            if (gHE == null)
            {
                return HttpNotFound();
            }
            return View(gHE);
        }

        // GET: Ghe/Create
        public ActionResult Create()
        {
            ViewBag.PHONGCHIEU_ID = new SelectList(db.PHONGCHIEUs, "ID", "MAPH");
            return View();
        }

        // POST: Ghe/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "ID,MAGHE,PHONGCHIEU_ID,RAP_ID,VITRI,LOAIGHE")] GHE gHE)
        {
            if (ModelState.IsValid)
            {
                db.GHEs.Add(gHE);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            ViewBag.PHONGCHIEU_ID = new SelectList(db.PHONGCHIEUs, "ID", "MAPH", gHE.PHONGCHIEU_ID);
            return View(gHE);
        }

        // GET: Ghe/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            GHE gHE = db.GHEs.Find(id);
            if (gHE == null)
            {
                return HttpNotFound();
            }
            ViewBag.PHONGCHIEU_ID = new SelectList(db.PHONGCHIEUs, "ID", "MAPH", gHE.PHONGCHIEU_ID);
            return View(gHE);
        }

        // POST: Ghe/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "ID,MAGHE,PHONGCHIEU_ID,RAP_ID,VITRI,LOAIGHE")] GHE gHE)
        {
            if (ModelState.IsValid)
            {
                db.Entry(gHE).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.PHONGCHIEU_ID = new SelectList(db.PHONGCHIEUs, "ID", "MAPH", gHE.PHONGCHIEU_ID);
            return View(gHE);
        }

        // GET: Ghe/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            GHE gHE = db.GHEs.Find(id);
            if (gHE == null)
            {
                return HttpNotFound();
            }
            return View(gHE);
        }

        // POST: Ghe/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            GHE gHE = db.GHEs.Find(id);
            db.GHEs.Remove(gHE);
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
