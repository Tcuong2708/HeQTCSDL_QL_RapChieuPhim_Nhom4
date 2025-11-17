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
    public class VeController : Controller
    {
        private QuanLyRapChieuPhimContext db = new QuanLyRapChieuPhimContext();

        // GET: Ve
        public ActionResult Index()
        {
            var vEs = db.VEs.Include(v => v.GHE).Include(v => v.KHACHHANG).Include(v => v.SUATCHIEU);
            return View(vEs.ToList());
        }

        // GET: Ve/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            VE vE = db.VEs.Find(id);
            if (vE == null)
            {
                return HttpNotFound();
            }
            return View(vE);
        }

        // GET: Ve/Create
        public ActionResult Create()
        {
            ViewBag.GHE_ID = new SelectList(db.GHEs, "ID", "MAGHE");
            ViewBag.KH_ID = new SelectList(db.KHACHHANGs, "ID", "MAKH");
            ViewBag.SUATCHIEU_ID = new SelectList(db.SUATCHIEUs, "ID", "MASUAT");
            return View();
        }

        // POST: Ve/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "ID,MAVE,KH_ID,SUATCHIEU_ID,GHE_ID,NGAYMUA,GIAVE")] VE vE)
        {
            if (ModelState.IsValid)
            {
                db.VEs.Add(vE);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            ViewBag.GHE_ID = new SelectList(db.GHEs, "ID", "MAGHE", vE.GHE_ID);
            ViewBag.KH_ID = new SelectList(db.KHACHHANGs, "ID", "MAKH", vE.KH_ID);
            ViewBag.SUATCHIEU_ID = new SelectList(db.SUATCHIEUs, "ID", "MASUAT", vE.SUATCHIEU_ID);
            return View(vE);
        }

        // GET: Ve/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            VE vE = db.VEs.Find(id);
            if (vE == null)
            {
                return HttpNotFound();
            }
            ViewBag.GHE_ID = new SelectList(db.GHEs, "ID", "MAGHE", vE.GHE_ID);
            ViewBag.KH_ID = new SelectList(db.KHACHHANGs, "ID", "MAKH", vE.KH_ID);
            ViewBag.SUATCHIEU_ID = new SelectList(db.SUATCHIEUs, "ID", "MASUAT", vE.SUATCHIEU_ID);
            return View(vE);
        }

        // POST: Ve/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "ID,MAVE,KH_ID,SUATCHIEU_ID,GHE_ID,NGAYMUA,GIAVE")] VE vE)
        {
            if (ModelState.IsValid)
            {
                db.Entry(vE).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.GHE_ID = new SelectList(db.GHEs, "ID", "MAGHE", vE.GHE_ID);
            ViewBag.KH_ID = new SelectList(db.KHACHHANGs, "ID", "MAKH", vE.KH_ID);
            ViewBag.SUATCHIEU_ID = new SelectList(db.SUATCHIEUs, "ID", "MASUAT", vE.SUATCHIEU_ID);
            return View(vE);
        }

        // GET: Ve/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            VE vE = db.VEs.Find(id);
            if (vE == null)
            {
                return HttpNotFound();
            }
            return View(vE);
        }

        // POST: Ve/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            VE vE = db.VEs.Find(id);
            db.VEs.Remove(vE);
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
