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
    public class QuayController : Controller
    {
        private QuanLyRapChieuPhimContext db = new QuanLyRapChieuPhimContext();

        // GET: Quay
        public ActionResult Index()
        {
            var qUAYs = db.QUAYs.Include(q => q.RAP);
            return View(qUAYs.ToList());
        }

        // GET: Quay/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            QUAY qUAY = db.QUAYs.Find(id);
            if (qUAY == null)
            {
                return HttpNotFound();
            }
            return View(qUAY);
        }

        // GET: Quay/Create
        public ActionResult Create()
        {
            ViewBag.RAP_ID = new SelectList(db.RAPs, "ID", "MARAP");
            return View();
        }

        // POST: Quay/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "ID,MAQUAY,TENQUAY,LOAIQUAY,RAP_ID")] QUAY qUAY)
        {
            if (ModelState.IsValid)
            {
                db.QUAYs.Add(qUAY);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            ViewBag.RAP_ID = new SelectList(db.RAPs, "ID", "MARAP", qUAY.RAP_ID);
            return View(qUAY);
        }

        // GET: Quay/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            QUAY qUAY = db.QUAYs.Find(id);
            if (qUAY == null)
            {
                return HttpNotFound();
            }
            ViewBag.RAP_ID = new SelectList(db.RAPs, "ID", "MARAP", qUAY.RAP_ID);
            return View(qUAY);
        }

        // POST: Quay/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "ID,MAQUAY,TENQUAY,LOAIQUAY,RAP_ID")] QUAY qUAY)
        {
            if (ModelState.IsValid)
            {
                db.Entry(qUAY).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.RAP_ID = new SelectList(db.RAPs, "ID", "MARAP", qUAY.RAP_ID);
            return View(qUAY);
        }

        // GET: Quay/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            QUAY qUAY = db.QUAYs.Find(id);
            if (qUAY == null)
            {
                return HttpNotFound();
            }
            return View(qUAY);
        }

        // POST: Quay/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            QUAY qUAY = db.QUAYs.Find(id);
            db.QUAYs.Remove(qUAY);
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
